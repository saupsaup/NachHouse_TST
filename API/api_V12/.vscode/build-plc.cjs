// One safe build path: fresh PUX -> schema -> final TTR.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const {spawnSync} = require('node:child_process');
const {generate} = require('./gen-schema.cjs');

const COMMON = [
  '-sg+', '-sr-', '-log-', '-pub', '-olc-', '-psw', '-plcpsw-',
  '-sc-', '-sl-', '-exml3U+', '-epub+', '-eexp+'
];
const sha256 = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const psQuote = value => "'" + value.replace(/'/g, "''") + "'";

function windows(settings, exe, args, options = {}) {
  const bin = settings['mosaic.mosaicBin'].replace(/\\+$/, '');
  const vm = settings['mosaic.vmName'];
  const ps = `$ErrorActionPreference='Stop'; & ${psQuote(bin + '\\' + exe)} ${args.map(psQuote).join(' ')}; exit $LASTEXITCODE`;
  const encoded = Buffer.from(ps, 'utf16le').toString('base64');
  let lastResult;
  let output = '';
  for (let attempt = 1; attempt <= 3; attempt += 1) {
    lastResult = spawnSync('prlctl', [
      'exec', vm, '--current-user', 'cmd', '/c',
      `powershell.exe -NoProfile -EncodedCommand ${encoded}`
    ], {encoding: 'utf8', timeout: 600000, maxBuffer: 16 * 1024 * 1024});
    output = `${lastResult.stdout || ''}${lastResult.stderr || ''}`.trim();
    const compileError = /\[ST:Error\]|Compilation completed with [1-9]/.test(output);
    const transient = lastResult.error || lastResult.status !== 0 || /PrlJob_/.test(output);
    if (!compileError && !transient) {
      if (!options.quiet && output) console.log(output);
      return output;
    }
    if (compileError || attempt === 3) break;
    Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000 * attempt);
  }
  if (!options.quiet && output) console.log(output);
  throw lastResult.error || Error(`Windows command failed: ${exe} ${args.join(' ')}`);
}

function namedFile(dir, wanted) {
  if (!fs.existsSync(dir)) throw Error(`Missing directory: ${dir}`);
  const name = fs.readdirSync(dir).find(item => item.toLowerCase() === wanted.toLowerCase());
  if (!name) throw Error(`Missing ${wanted} in ${dir}`);
  return path.join(dir, name);
}

function removeCache(root) {
  const name = fs.readdirSync(root).find(item => item.toLowerCase() === 'api_v12.pch');
  if (name) fs.unlinkSync(path.join(root, name));
}

function verifyPuxPair(root) {
  const projectPux = namedFile(root, 'api_V12.pux');
  const sendPux = namedFile(path.join(root, 'SendRoot'), 'api_V12.pux');
  const projectBytes = fs.readFileSync(projectPux);
  const sendBytes = fs.readFileSync(sendPux);
  if (!projectBytes.equals(sendBytes)) throw Error('Project PUX differs from SendRoot PUX');
  return {projectPux, sendPux, bytes: projectBytes, hash: sha256(projectBytes)};
}

function build(options = {}) {
  const root = options.root || path.resolve(__dirname, '..');
  const settings = options.settings || JSON.parse(fs.readFileSync(path.join(root, '.vscode', 'settings.json'), 'utf8'));
  const mak = settings['mosaic.makPathWin'];

  removeCache(root);
  console.log('Pass 1/2: generating current PUX...');
  windows(settings, 'MosaicL.exe', ['-ttr-', '-lnk-', ...COMMON, mak]);
  const first = verifyPuxPair(root);

  const schema = generate(root);
  console.log(`Schema: ${schema.schemas.map(item => `${item.name}=${item.nodes.length}`).join(', ')}, total=${schema.nodes}.`);

  removeCache(root);
  console.log('Pass 2/2: compiling final TTR...');
  const output = windows(settings, 'MosaicL.exe', ['-ttr', '-lnk', ...COMMON, mak]);
  const second = verifyPuxPair(root);
  if (first.hash !== second.hash) throw Error('PUX changed between schema generation and final package');

  const fileList = fs.readFileSync(namedFile(path.join(root, 'SendRoot'), 'program.filelist'), 'utf8');
  if (!fileList.split(/\r?\n/).some(line => line.trim().toLowerCase() === '//api_v12.schema.json')) {
    throw Error('Final TTR file list does not contain api_V12.schema.json');
  }

  const match = output.match(/Package '([^']+\.TTR)' successfully created/i);
  if (!match) throw Error('Compiler did not confirm creation of a TTR package');
  const packagePath = path.join(root, path.win32.basename(match[1]));
  if (!fs.existsSync(packagePath)) throw Error(`Compiled package is missing: ${packagePath}`);
  console.log(`BUILD OK: ${path.basename(packagePath)}, PUX SHA-256 ${second.hash}`);
  return {packagePath, puxHash: second.hash, schema};
}

if (require.main === module) {
  try {
    build();
  } catch (error) {
    console.error(`BUILD FAILED: ${error.message}`);
    process.exitCode = 1;
  }
}

module.exports = {build, windows};
