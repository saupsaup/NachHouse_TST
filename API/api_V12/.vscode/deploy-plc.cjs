// API V12: compile -> FTP upload -> LoadNewPackage2 -> RUN verification.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const {spawnSync} = require('node:child_process');
const {build} = require('./build-plc.cjs');

const root = path.resolve(__dirname, '..');
const settings = JSON.parse(fs.readFileSync(path.join(__dirname, 'settings.json'), 'utf8'));
const plcAddress = settings['mosaic.plcHost'];
const host = plcAddress.split(':')[0];
const vm = settings['mosaic.vmName'];
const bin = settings['mosaic.mosaicBin'].replace(/\\+$/, '');
const source = path.join(root, '_01_Types.ST');
const localApiPub = path.join(root, 'SendRoot', 'TecoApi.pub');
const ftpService = `NachHouse FTP ${host} deployment`;
const remoteTtr = '/WWW/UPLOAD/NEW_PACK.TTR';
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));
const sha256 = bytes => crypto.createHash('sha256').update(bytes).digest('hex');
const psQuote = value => "'" + value.replace(/'/g, "''") + "'";
let ftpCredentials;

function getFtpCredentials() {
  if (process.env.NH_FTP_USER && process.env.NH_FTP_PASSWORD) {
    return {user: process.env.NH_FTP_USER, password: process.env.NH_FTP_PASSWORD};
  }
  const result = spawnSync('security', ['find-generic-password', '-s', ftpService, '-w'], {encoding: 'utf8'});
  if (result.status !== 0 || !result.stdout.trim()) throw Error(`Missing FTP password in Keychain: ${ftpService}`);
  return {user: 'nhftp', password: result.stdout.trim()};
}

function windows(exe, args, options = {}) {
  const ps = `$ErrorActionPreference='Stop'; & ${psQuote(bin + '\\' + exe)} ${args.map(psQuote).join(' ')}; exit $LASTEXITCODE`;
  const encoded = Buffer.from(ps, 'utf16le').toString('base64');
  const retries = options.retries || 1;
  let lastOutput = '';
  for (let attempt = 1; attempt <= retries; attempt += 1) {
    const result = spawnSync('prlctl', ['exec', vm, '--current-user', 'cmd', '/c', `powershell.exe -NoProfile -EncodedCommand ${encoded}`], {
      encoding: 'utf8', timeout: 600000, maxBuffer: 16 * 1024 * 1024
    });
    lastOutput = `${result.stdout || ''}${result.stderr || ''}`.trim();
    const failed = result.error || result.status !== 0 || /PrlJob_|\[ST:Error\]|Compilation completed with [1-9]/.test(lastOutput);
    if (!failed) {
      if (!options.quiet && lastOutput) console.log(lastOutput);
      return lastOutput;
    }
    if (attempt === retries) {
      if (!options.quiet && lastOutput) console.log(lastOutput);
      throw result.error || Error(`Windows command failed: ${exe} ${args.join(' ')}`);
    }
  }
}

function ftp(args) {
  const result = spawnSync('curl', [
    '--connect-timeout', '10', '--max-time', '120', '--silent', '--show-error', '--fail',
    '--user', `${ftpCredentials.user}:${ftpCredentials.password}`, ...args
  ], {maxBuffer: 16 * 1024 * 1024});
  if (result.error || result.status !== 0) throw Error(`FTP transfer failed${result.stderr?.length ? `: ${result.stderr.toString().trim()}` : ''}`);
  return result.stdout;
}

function parseSymbols(pubBytes) {
  const text = pubBytes.toString('latin1');
  const result = {};
  const aliases = {
    DepRq: ['DepRq', 'NhV12DeployRequest'],
    BuildNo: ['BuildNo', 'NhV12DeployBuild']
  };
  for (const [key, names] of Object.entries(aliases)) {
    let match;
    for (const name of names) {
      match = text.match(new RegExp(`^${name}\\s+R\\s+([BLWD])\\s+(\\d+)(?:\\s+\\.(\\d+))?`, 'mi'));
      if (match) break;
    }
    if (!match) throw Error(`Symbol ${key} is missing in TecoApi.pub`);
    result[key] = {address: Number(match[2]), bit: Number(match[3] || 0)};
  }
  return result;
}

function readLong(address) {
  const output = windows('plc.exe', [plcAddress, 'readn', 'R', String(address), '1', '-l'], {quiet: true, retries: 3});
  const match = output.match(/\[([0-9A-F]{8})\]/i);
  if (!match) throw Error(`Cannot read R${address}: ${output}`);
  return Number.parseInt(match[1], 16) >>> 0;
}

function verifyRun() {
  const status = windows('plc.exe', [plcAddress, 'getsw'], {quiet: true, retries: 3});
  if (!/MOD:\s*true/.test(status) || !/ERH:\s*false/.test(status) || !/ERS:\s*false/.test(status)) {
    throw Error(`PLC status check failed:\n${status}`);
  }
}

function plcState() {
  const pub = ftp([`ftp://${host}/TecoApi.pub`]);
  const symbols = parseSymbols(pub);
  return {pub, symbols, build: readLong(symbols.BuildNo.address)};
}

function sourceBuild() {
  // Latin-1 gives a byte-preserving view of the Windows-1250 source.
  const text = fs.readFileSync(source).toString('latin1');
  const match = text.match(/(BuildNo\s+\{PUBLIC_API\}\s*:\s*UDINT\s*:=\s*)(\d+)/);
  if (!match) throw Error('Cannot locate BuildNo in _01_Types.ST');
  return {text, match, build: Number(match[2])};
}

function setSourceBuild(next) {
  const current = sourceBuild();
  fs.writeFileSync(source, Buffer.from(current.text.replace(current.match[0], current.match[1] + next), 'latin1'));
}

function newestPackage() {
  const packages = fs.readdirSync(root).filter(name => name.toUpperCase().endsWith('.TTR'))
    .map(name => ({path: path.join(root, name), time: fs.statSync(path.join(root, name)).mtimeMs}))
    .sort((a, b) => b.time - a.time);
  if (!packages.length) throw Error('No local TTR package is available');
  return packages[0].path;
}

function compile(next) {
  setSourceBuild(next);
  // Parallels can reject a Mosaic exec started immediately after the PLC-state exec.
  Atomics.wait(new Int32Array(new SharedArrayBuffer(4)), 0, 0, 1000);
  console.log(`Compiling API V12 build ${next}...`);
  return build({root, settings}).packagePath;
}

function uploadAndVerify(local) {
  ftp(['--upload-file', local, `ftp://${host}${remoteTtr}`]);
  const localBytes = fs.readFileSync(local);
  const remoteBytes = ftp([`ftp://${host}${remoteTtr}`]);
  if (localBytes.length !== remoteBytes.length || sha256(localBytes) !== sha256(remoteBytes)) {
    throw Error('Uploaded TTR differs from local package; activation stopped');
  }
  console.log(`TTR verified: ${localBytes.length} bytes, SHA-256 ${sha256(localBytes)}`);
}

function activate(old) {
  const request = old.symbols.DepRq;
  windows('plc.exe', [plcAddress, 'writeb', 'R', String(request.address), String(request.bit), '1'], {quiet: true, retries: 3});
  console.log(`Activation requested at R${request.address}.${request.bit}`);
}

async function waitForBuild(expected, expectedPub) {
  const deadline = Date.now() + 90000;
  while (Date.now() < deadline) {
    await sleep(2000);
    try {
      const current = plcState();
      if (current.build !== expected) continue;
      verifyRun();
      if (!current.pub.equals(expectedPub)) throw Error('Remote TecoApi.pub differs from local export');
      console.log(`SUCCESS: build ${expected}, RUN, ERH=false, ERS=false, TecoApi.pub verified.`);
      return;
    } catch (error) {
      if (/differs from/.test(error.message)) throw error;
    }
  }
  throw Error(`Build ${expected} was not confirmed; do not repeat activation blindly`);
}

async function main() {
  ftpCredentials = getFtpCredentials();
  const checkOnly = process.argv.includes('--check');
  const uploadOnly = process.argv.includes('--upload');
  const activateOnly = process.argv.includes('--activate');
  if ([checkOnly, uploadOnly, activateOnly].filter(Boolean).length > 1) throw Error('Choose only one mode');

  const lock = path.join(__dirname, '.deploy.lock');
  const fd = fs.openSync(lock, 'wx');
  try {
    const old = plcState();
    verifyRun();
    if (checkOnly) {
      console.log(`OK: ${host}, build ${old.build}, RUN, ERH=false, ERS=false.`);
      return;
    }

    let next;
    let local;
    if (activateOnly) {
      next = sourceBuild().build;
      if (next <= old.build) throw Error(`Local build ${next} must be newer than PLC build ${old.build}`);
      local = newestPackage();
      const remote = ftp([`ftp://${host}${remoteTtr}`]);
      const bytes = fs.readFileSync(local);
      if (bytes.length !== remote.length || sha256(bytes) !== sha256(remote)) {
        throw Error('Uploaded TTR differs from newest local package; activation stopped');
      }
      console.log(`Existing upload verified: SHA-256 ${sha256(bytes)}`);
    } else {
      next = Math.max(sourceBuild().build, old.build) + 1;
      if (next > 0xFFFFFFFF) throw Error('Build counter overflow');
      local = compile(next);
      uploadAndVerify(local);
      if (uploadOnly) {
        console.log(`SUCCESS: build ${next} uploaded and verified; not activated.`);
        return;
      }
    }

    activate(old);
    await waitForBuild(next, fs.readFileSync(localApiPub));
  } finally {
    fs.closeSync(fd);
    fs.unlinkSync(lock);
  }
}

main().catch(error => {
  console.error('DEPLOY FAILED:', error.message);
  process.exitCode = 1;
});
