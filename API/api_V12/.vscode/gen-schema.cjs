// Generates a compact hierarchical schema for exactly NH_ROOM and NH_USER.
const fs = require('node:fs');
const path = require('node:path');

const ROOTS = [
  {name: 'NH_ROOM', code: 'ROOM'},
  {name: 'NH_USER', code: 'USER'}
];
const ARRAY = 0x80;
const TAGS = Object.freeze({
  BOOL: 0x01,
  SINT: 0x02,
  USINT: 0x03,
  INT: 0x04,
  UINT: 0x05,
  DINT: 0x06,
  UDINT: 0x07,
  BYTE: 0x08,
  WORD: 0x09,
  DWORD: 0x0A,
  REAL: 0x0B,
  LREAL: 0x0C,
  STRING: 0x0D,
  TIME: 0x0E,
  DATE: 0x0F,
  TIME_OF_DAY: 0x10,
  DATE_AND_TIME: 0x11,
  STRUCT: 0x12
});

function attrs(text) {
  const result = {};
  for (const match of text.matchAll(/([A-Za-z_][A-Za-z0-9_]*)="([^"]*)"/g)) result[match[1]] = match[2];
  return result;
}

function integer(value, label) {
  if (value === undefined || !/^-?\d+$/.test(value)) throw Error(`Invalid ${label}: ${value}`);
  return Number(value);
}

function parsePux(xml) {
  const types = xml.match(/<TYPES\b[^>]*>([\s\S]*?)<\/TYPES>/i);
  if (!types) throw Error('PUX has no TYPES section');
  const records = new Map();
  const stack = [];
  const tokens = types[1].match(/<\/?(?:RECORD|ARRAY)\b[^>]*>|<ITEM\b[^>]*\/>/gi) || [];

  for (const token of tokens) {
    if (/^<RECORD\b/i.test(token)) {
      const a = attrs(token);
      if (!a.name || records.has(a.name)) throw Error(`Invalid or duplicate RECORD ${a.name || '?'}`);
      const record = {kind: 'record', name: a.name, size: integer(a.size, `RECORD ${a.name} size`), children: []};
      records.set(record.name, record);
      stack.push(record);
    } else if (/^<\/RECORD/i.test(token)) {
      if (stack.at(-1)?.kind !== 'record') throw Error('Unbalanced RECORD');
      stack.pop();
    } else if (/^<ARRAY\b/i.test(token)) {
      const a = attrs(token);
      const array = {
        kind: 'array', size: integer(a.size, 'ARRAY size'),
        lo: integer(a.lo, 'ARRAY lower bound'), hi: integer(a.hi, 'ARRAY upper bound'), item: null
      };
      if (stack.at(-1)?.kind !== 'record') throw Error('ARRAY outside RECORD');
      stack.at(-1).children.push(array);
      stack.push(array);
    } else if (/^<\/ARRAY/i.test(token)) {
      if (stack.at(-1)?.kind !== 'array' || !stack.at(-1).item) throw Error('Invalid ARRAY');
      stack.pop();
    } else {
      const a = attrs(token);
      if (!a.name || !a.type) throw Error('ITEM without name or type');
      const item = {
        kind: 'item', name: a.name, type: a.type,
        addr: integer(a.addr, `ITEM ${a.name} address`), size: integer(a.size, `ITEM ${a.name} size`),
        bit: a.bit === undefined ? -1 : integer(a.bit, `ITEM ${a.name} bit`)
      };
      const parent = stack.at(-1);
      if (!parent) throw Error(`ITEM ${a.name} outside RECORD`);
      if (parent.kind === 'record') parent.children.push(item);
      else if (parent.kind === 'array' && !parent.item) parent.item = item;
      else throw Error(`Invalid parent of ITEM ${a.name}`);
    }
  }
  if (stack.length) throw Error('Unclosed PUX node');
  return records;
}

function makeSchema(records, rootSpec) {
  const root = records.get(rootSpec.name);
  if (!root) throw Error(`PUX type is missing: ${rootSpec.name}`);
  const nodes = [];
  const leaves = [];

  function primitive(item, array) {
    const baseTag = TAGS[item.type];
    if (!baseTag || baseTag === TAGS.STRUCT) throw Error(`Unsupported type ${item.type}`);
    const count = array ? array.hi - array.lo + 1 : 0;
    if (array && count < 1) throw Error(`Invalid ARRAY bounds at ${item.name}`);
    if (item.type === 'BOOL' && (item.bit < 0 || item.bit > 7)) throw Error(`Invalid BOOL bit at ${item.name}`);
    if (item.type !== 'BOOL' && item.bit !== -1) throw Error(`Unexpected bit at ${item.name}`);
    if (array) {
      const expected = item.type === 'BOOL' ? Math.ceil((item.bit + count) / 8) : item.size * count;
      if (array.size !== expected) throw Error(`ARRAY size mismatch at ${item.name}`);
    }
    return {
      name: item.name, tag: baseTag | (array ? ARRAY : 0), offset: item.addr,
      span: array ? array.size : item.size,
      aux: array ? (item.type === 'BOOL' ? item.bit : item.size) : (item.type === 'BOOL' ? item.bit : 0),
      count, low: array ? array.lo : 0
    };
  }

  function addItem(item, array, active) {
    const nested = records.get(item.type);
    if (!nested) {
      nodes.push(primitive(item, array));
      return;
    }
    if (item.size !== nested.size) throw Error(`STRUCT size mismatch at ${item.name}`);
    const count = array ? array.hi - array.lo + 1 : 0;
    if (array && (count < 1 || array.size !== item.size * count)) throw Error(`STRUCT ARRAY size mismatch at ${item.name}`);
    const index = nodes.length;
    nodes.push({
      name: item.name, tag: TAGS.STRUCT | (array ? ARRAY : 0), offset: item.addr,
      span: array ? array.size : item.size, aux: 0, count, low: array ? array.lo : 0
    });
    walk(nested, active);
    nodes[index].aux = nodes.length - index - 1;
  }

  function walk(record, active) {
    if (active.has(record.name)) throw Error(`Recursive STRUCT ${record.name}`);
    const next = new Set(active);
    next.add(record.name);
    for (const child of record.children) {
      if (child.kind === 'item') addItem(child, null, next);
      else addItem(child.item, child, next);
    }
  }

  walk(root, new Set());

  // Flat leaf table for JSON -> RAM. Array elements are expanded so every
  // JSON value has one exact path and one absolute byte/bit address.
  function walkLeaves(record, active, base, prefix) {
    if (active.has(record.name)) throw Error(`Recursive STRUCT ${record.name}`);
    const next = new Set(active);
    next.add(record.name);
    for (const child of record.children) {
      const array = child.kind === 'array' ? child : null;
      const item = array ? child.item : child;
      const nested = records.get(item.type);
      const count = array ? array.hi - array.lo + 1 : 1;
      if (array && count < 1) throw Error(`Invalid ARRAY bounds at ${item.name}`);
      for (let index = 0; index < count; index += 1) {
        const pathName = `${prefix}${item.name}${array ? `[${index}]` : ''}`;
        const itemBase = base + item.addr + (array ? index * item.size : 0);
        if (nested) {
          walkLeaves(nested, next, itemBase, `${pathName}.`);
        } else {
          const tag = TAGS[item.type];
          if (!tag || tag === TAGS.STRUCT) throw Error(`Unsupported type ${item.type}`);
          let offset = itemBase;
          let bit = item.type === 'BOOL' ? item.bit : -1;
          if (array && item.type === 'BOOL') {
            offset = base + item.addr + Math.floor((item.bit + index) / 8);
            bit = (item.bit + index) % 8;
          }
          leaves.push({path: pathName, tag, offset, span: item.size, bit});
        }
      }
    }
  }

  walkLeaves(root, new Set(), 0, '');
  return {...rootSpec, size: root.size, nodes, leaves};
}

function crc32(bytes) {
  let crc = 0xFFFFFFFF;
  for (const byte of bytes) {
    crc ^= byte;
    for (let bit = 0; bit < 8; bit += 1) crc = (crc >>> 1) ^ ((crc & 1) ? 0xEDB88320 : 0);
  }
  return (crc ^ 0xFFFFFFFF) >>> 0;
}

function stString(value) {
  if (!/^[\x20-\x7E]*$/.test(value)) throw Error(`Non-ASCII schema name: ${value}`);
  return `'${value.replace(/'/g, "''")}'`;
}

function renderSt(schemas, puxCrc) {
  const nodes = schemas.flatMap(schema => schema.nodes);
  const leaves = schemas.flatMap(schema => schema.leaves);
  const maxName = Math.max(...nodes.map(node => node.name.length));
  const maxPath = Math.max(...leaves.map(leaf => leaf.path.length));
  let first = 1;
  let firstLeaf = 1;
  const roots = schemas.map((schema, index) => {
    const row = `    (Cfg := ${index + 1}, Code := ${stString(schema.code)}, Nam := ${stString(schema.name)}, Siz := ${schema.size}, Fst := ${first}, Cnt := ${schema.nodes.length}, LFst := ${firstLeaf}, LCnt := ${schema.leaves.length})`;
    first += schema.nodes.length;
    firstLeaf += schema.leaves.length;
    return row;
  });
  const rows = nodes.map(node =>
    `    (Nam := ${stString(node.name)}, Tag := 16#${node.tag.toString(16).toUpperCase().padStart(2, '0')}, Ofs := ${node.offset}, Span := ${node.span}, Aux := ${node.aux}, Cnt := ${node.count}, Lo := ${node.low})`
  );
  const leafRows = leaves.map(leaf =>
    `    (Pth := ${stString(leaf.path)}, Tag := 16#${leaf.tag.toString(16).toUpperCase().padStart(2, '0')}, Ofs := ${leaf.offset}, Span := ${leaf.span}, BitPos := ${leaf.bit})`
  );
  const constants = Object.entries(TAGS).map(([name, tag]) =>
    `  SCH_${name} : USINT := 16#${tag.toString(16).toUpperCase().padStart(2, '0')};`
  );

  return [
    '// GENERATED from api_V12.pux. Do not edit manually.',
    'VAR_GLOBAL CONSTANT',
    ...constants,
    '  SCH_ARRAY : USINT := 16#80;',
    '  SCH_BASE : USINT := 16#7F;',
    `  SCH_DEF_N : UINT := ${schemas.length};`,
    `  SCH_NODE_N : UINT := ${nodes.length};`,
    `  SCH_LEAF_N : UINT := ${leaves.length};`,
    `  SCH_PUX_CRC : DWORD := 16#${puxCrc.toString(16).toUpperCase().padStart(8, '0')};`,
    'END_VAR',
    '',
    'TYPE',
    '  NH_SCH : STRUCT',
    '    Cfg : USINT; Code : STRING[4]; Nam : STRING[16];',
    '    Siz : UDINT; Fst : UINT; Cnt : UINT; LFst : UINT; LCnt : UINT;',
    '  END_STRUCT;',
    '  NH_NODE : STRUCT',
    `    Nam : STRING[${maxName}]; Tag : USINT; Ofs : UINT; Span : UINT;`,
    '    Aux : UINT; Cnt : UINT; Lo : INT;',
    '  END_STRUCT;',
    '  NH_LEAF : STRUCT',
    `    Pth : STRING[${maxPath}]; Tag : USINT; Ofs : UINT; Span : UINT; BitPos : SINT;`,
    '  END_STRUCT;',
    'END_TYPE',
    '',
    'VAR_GLOBAL',
    `  aSch : ARRAY[1..${schemas.length}] OF NH_SCH := [`,
    roots.join(',\r\n'),
    '  ];',
    `  aNode : ARRAY[1..${nodes.length}] OF NH_NODE := [`,
    rows.join(',\r\n'),
    '  ];',
    `  aLeaf : ARRAY[1..${leaves.length}] OF NH_LEAF := [`,
    leafRows.join(',\r\n'),
    '  ];',
    'END_VAR',
    ''
  ].join('\r\n');
}

function renderJson(sourceName, schemas, puxCrc) {
  let first = 1;
  let firstLeaf = 1;
  const roots = schemas.map((schema, index) => {
    const row = [index + 1, schema.code, schema.name, schema.size, first, schema.nodes.length, firstLeaf, schema.leaves.length];
    first += schema.nodes.length;
    firstLeaf += schema.leaves.length;
    return row;
  });
  const nodes = schemas.flatMap(schema => schema.nodes.map(node => [
    node.name, node.tag, node.offset, node.span, node.aux, node.count, node.low
  ]));
  const leaves = schemas.flatMap(schema => schema.leaves.map(leaf => [
    leaf.path, leaf.tag, leaf.offset, leaf.span, leaf.bit
  ]));
  return `${JSON.stringify({
    v: 2, source: sourceName, crc32: puxCrc.toString(16).toUpperCase().padStart(8, '0'),
    tags: TAGS, arrayFlag: ARRAY,
    rootFmt: ['id', 'code', 'name', 'size', 'first', 'count', 'leafFirst', 'leafCount'],
    nodeFmt: ['name', 'tag', 'offset', 'span', 'aux', 'count', 'low'],
    leafFmt: ['path', 'tag', 'offset', 'span', 'bit'], roots, nodes, leaves
  })}\n`;
}

function findPux(root) {
  const candidates = [path.join(root, 'SendRoot'), root]
    .filter(dir => fs.existsSync(dir))
    .flatMap(dir => fs.readdirSync(dir)
      .filter(name => name.toLowerCase() === 'api_v12.pux')
      .map(name => path.join(dir, name)));
  if (!candidates.length) throw Error('api_V12.pux was not found');
  candidates.sort((a, b) => fs.statSync(b).mtimeMs - fs.statSync(a).mtimeMs);
  return candidates[0];
}

function writeIfChanged(file, bytes) {
  if (fs.existsSync(file) && fs.readFileSync(file).equals(bytes)) return false;
  const temp = path.join(path.dirname(file), `.${path.basename(file)}.${process.pid}.tmp`);
  fs.writeFileSync(temp, bytes);
  fs.renameSync(temp, file);
  return true;
}

function generate(projectRoot = path.resolve(__dirname, '..')) {
  const source = findPux(projectRoot);
  const pux = fs.readFileSync(source);
  const records = parsePux(pux.toString('utf8'));
  const schemas = ROOTS.map(root => makeSchema(records, root));
  const puxCrc = crc32(pux);
  const stPath = path.join(projectRoot, '_03_Schema.ST');
  const jsonPath = path.join(projectRoot, 'SendRoot', 'api_V12.schema.json');
  fs.mkdirSync(path.dirname(jsonPath), {recursive: true});
  const stChanged = writeIfChanged(stPath, Buffer.from(renderSt(schemas, puxCrc), 'ascii'));
  const jsonChanged = writeIfChanged(jsonPath, Buffer.from(renderJson(path.basename(source), schemas, puxCrc), 'utf8'));
  return {source, schemas, nodes: schemas.reduce((sum, schema) => sum + schema.nodes.length, 0), puxCrc, stPath, jsonPath, stChanged, jsonChanged};
}

if (require.main === module) {
  try {
    const result = generate(process.argv[2] ? path.resolve(process.argv[2]) : undefined);
    console.log(`Schema: ${result.schemas.map(item => `${item.name}=${item.nodes.length}`).join(', ')}, total=${result.nodes}, CRC32=${result.puxCrc.toString(16).toUpperCase().padStart(8, '0')}`);
  } catch (error) {
    console.error(`SCHEMA FAILED: ${error.message}`);
    process.exitCode = 1;
  }
}

module.exports = {generate, parsePux, makeSchema};
