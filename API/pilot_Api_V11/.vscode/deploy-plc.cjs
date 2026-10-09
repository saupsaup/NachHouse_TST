// macOS orchestration; Windows compiler/uploader run inside the configured VM.
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const {spawnSync} = require('node:child_process');
const root = path.resolve(__dirname, '..');
const settings = JSON.parse(fs.readFileSync(path.join(__dirname, 'settings.json'), 'utf8'));
const host = settings['mosaic.plcHost'].split(':')[0];
const vm = settings['mosaic.vmName'];
const bin = settings['mosaic.mosaicBin'].replace(/\\+$/, '');
const mak = settings['mosaic.makPathWin'];
const source = path.join(root, 'prgMain.ST');
const wsModule = process.env.NH_WS_MODULE || '/Users/pambm3/NachHouse_APP/ROOMS_BROWSER_V0.5.73/node_modules/ws';
const ftpKeychainService = `NachHouse FTP ${host} deployment`;
const plcKeychainService = `NachHouse PLC ${host} deployment`;
const W = require(wsModule);
let ftpCredentials;
const sleep = ms => new Promise(r => setTimeout(r, ms));
const quote = s => '"' + s + '"';
const psQuote = s => "'" + s.replace(/'/g, "''") + "'";
const digest = b => crypto.createHash('sha256').update(b).digest('hex');
function ftpLogin() {
  if (process.env.NH_FTP_USER && process.env.NH_FTP_PASSWORD) return {user:process.env.NH_FTP_USER, password:process.env.NH_FTP_PASSWORD};
  const r=spawnSync('security',['find-generic-password','-s',ftpKeychainService,'-w'],{encoding:'utf8'});
  if (r.status!==0 || !r.stdout.trim()) throw Error(`Missing FTP password in macOS Keychain: ${ftpKeychainService}`);
  return {user:'nhftp', password:r.stdout.trim()};
}
async function webLogin() {
  const r=spawnSync('security',['find-generic-password','-s',plcKeychainService,'-w'],{encoding:'utf8'});
  if(r.status!==0 || !r.stdout.trim()) throw Error(`Missing PLC password in macOS Keychain: ${plcKeychainService}`);
  const password=r.stdout.trim();let cookie='';
  async function request(path,options={}) {
    const response=await fetch(`http://${host}${path}`,{redirect:'manual',headers:{...options.headers,...(cookie?{Cookie:cookie}:{})},...options});
    const setCookie=response.headers.get('set-cookie');if(setCookie)cookie=setCookie.split(';')[0];return response;
  }
  await request('/NACHHOUSE/');const nonce=cookie.split('=')[1];
  if(!nonce) throw Error('Missing PLC web login nonce');
  const pass=crypto.createHash('sha1').update(nonce+password).digest('hex');
  const response=await request('/SYSWWW/LOGIN.XML',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:new URLSearchParams({USER:'a',PASS:pass})});
  if(![200,302].includes(response.status))throw Error(`PLC web login failed: ${response.status}`);
}
function windows(exe, args, credentials = false) {
  let ps = "$ErrorActionPreference='Stop'; ";
  if (credentials) for (const key of ['PLC_USR','PLC_PSW','PLC_PUB_USR','PLC_PUB_PSW']) {
    ps += `$env:${key}=${psQuote(key.endsWith('USR') ? ftpCredentials.user : ftpCredentials.password)}; `;
  }
  ps += '& ' + psQuote(bin + '\\' + exe) + ' ' + args.map(psQuote).join(' ') + '; exit $LASTEXITCODE';
  const encoded = Buffer.from(ps, 'utf16le').toString('base64');
  // Web packages contain the complete browser UI and can take several minutes
  // to cross the VM boundary and PLC file service.
  // The Mosaic compiler must run in the signed-in Windows session: that is
  // where Parallels exposes the N: project share.
  const r = spawnSync('prlctl', ['exec', vm, '--current-user', 'cmd', '/c', 'powershell.exe -NoProfile -EncodedCommand ' + encoded], {encoding:'utf8', timeout:600000, maxBuffer:8*1024*1024});
  if (r.error) throw r.error;
  const output = (r.stdout || '') + (r.stderr || '');
  console.log(output.trim());
  if (r.status !== 0 || /PrlJob_|\[ST:Error\]|Compilation completed with [1-9]/.test(output)) throw Error('Windows command failed; no automatic activation retry.');
  return output;
}
function readState(activate = false, expected) {
  return new Promise((resolve,reject) => {
    const w = new W(`wss://${host}:5030/`, 'raw', {rejectUnauthorized:false});
    const timer = setTimeout(()=>finish(Error('PLC read timeout')),8000);
    let done = false;
    function finish(error,value) {if(done)return;done=true;clearTimeout(timer);w.close();error?reject(error):resolve(value);}
    w.on('error',e=>finish(e));
    w.on('open',()=>w.send(JSON.stringify({cmd:'get',data:['NHDEPLOYBUILD','NHDEPLOYREQUEST','NHAPIINFO.STATE','NHAPIINFO.APIVERSION','__PLC_RUN']})));
    w.on('message',b=>{try {
      const g=JSON.parse(b).get;if(!g)return;
      const state=Object.fromEntries(Object.entries(g).map(([k,v])=>[k,v.val]));
      if(activate) {
        if(state.NHDEPLOYBUILD!==expected || state['NHAPIINFO.STATE']!==0 || state.NHDEPLOYREQUEST!==false || state.__PLC_RUN!==true) return finish(Error('PLC not ready for activation.'));
        w.send(JSON.stringify({cmd:'set',data:{NHDEPLOYREQUEST:{dt:'BOOL',val:true}}}),e=>finish(e,state));
      } else finish(null,state);
    } catch(e){finish(e);}});
  });
}
function ftp(args, encoding='buffer') {
  const r=spawnSync('curl',['--connect-timeout','10','--max-time','120','--silent','--show-error','--fail','--user',`${ftpCredentials.user}:${ftpCredentials.password}`,...args],{encoding,maxBuffer:16*1024*1024});
  if(r.error||r.status!==0) throw Error(`FTP transfer failed${r.stderr?`: ${String(r.stderr).trim()}`:''}`);
  return r.stdout;
}
function ftpPackage() {
  return Buffer.from(ftp([`ftp://${host}/WWW/UPLOAD/NEW_PACK.TTR`]));
}
function ftpUploadPackage(local) {
  ftp(['--upload-file',local,`ftp://${host}/WWW/UPLOAD/NEW_PACK.TTR`]);
}
function sourceBuild() {
  const text=fs.readFileSync(source,'utf8');
  const match=text.match(/(NhDeployBuild\s+\{PUBLIC_API\}\s*:\s*UDINT\s*:=\s*)(\d+)/);
  if(!match) throw Error('Cannot locate NhDeployBuild');
  return {text, match, build:Number(match[2])};
}
async function compileAndUpload(old) {
  const current=sourceBuild();
  const next=Math.max(current.build,old.NHDEPLOYBUILD)+1;
  if(next>4294967295)throw Error('Build counter overflow');
  fs.writeFileSync(source,current.text.replace(current.match[0],current.match[1]+next));
  console.log(`Compile and upload ${old.NHDEPLOYBUILD} -> ${next} on ${host}`);
  const output=windows('MosaicL.exe',['-ttr','-lnk','-sg+','-sr-','-log-','-pub','-olc-','-psw-','-plcpsw-','-sc-','-sl-','-exml-','-epub-','-eexp+',mak]);
  const packageMatch=output.match(/Package '([^']+\.TTR)' successfully created/i);
  if(!packageMatch)throw Error('Compiler did not confirm a new package');
  const winPackage=packageMatch[1];
  const local=path.join(root,path.win32.basename(winPackage));
  const bytes=fs.readFileSync(local);
  ftpUploadPackage(local);
  const remote=ftpPackage();
  if(remote.length!==bytes.length||digest(remote)!==digest(bytes))throw Error('Uploaded package differs; activation stopped');
  console.log('SHA-256 verified:',digest(bytes));
  return next;
}
async function activateAndVerify(old,next) {
  const readyDeadline=Date.now()+45000;
  while((await readState())['NHAPIINFO.STATE']!==0){if(Date.now()>readyDeadline)throw Error('API remained busy');await sleep(1000);}
  await readState(true,old.NHDEPLOYBUILD);
  console.log('Activation sent once; waiting for new build and RUN…');
  const deadline=Date.now()+90000;
  while(Date.now()<deadline) {
    await sleep(2000);
    let s;try{s=await readState();}catch{continue;}
    if(s.NHDEPLOYBUILD===next&&s.__PLC_RUN===true&&s['NHAPIINFO.APIVERSION']===11&&s['NHAPIINFO.STATE']===0) {
      const status=windows('plc.exe',[settings['mosaic.plcHost'],'getsw']);
      if(!/MOD: true/.test(status)||!/ERH: false/.test(status)||!/ERS: false/.test(status))throw Error('PLC status check failed');
      console.log(`SUCCESS: build ${next}, RUN, API V11, no PLC error flags.`);return;
    }
  }
  throw Error('New build/RUN not confirmed. Inspect PLC; do not blindly repeat activation.');
}
async function main() {
  await webLogin();
  if(process.argv.includes('--check')) {console.log('Configuration:',host,vm,mak);console.log(await readState());return;}
  const uploadOnly=process.argv.includes('--upload');
  const activateOnly=process.argv.includes('--activate');
  if(uploadOnly&&activateOnly)throw Error('Choose either --upload or --activate');
  ftpCredentials=ftpLogin();
  const lock=path.join(__dirname,'.deploy.lock');
  const fd=fs.openSync(lock,'wx');
  try {
    const old=await readState();
    if(!Number.isInteger(old.NHDEPLOYBUILD)||old.__PLC_RUN!==true||old['NHAPIINFO.APIVERSION']!==11)throw Error('Expected running V11 with deployment activator');
    if(activateOnly) {
      const next=sourceBuild().build;
      if(next<=old.NHDEPLOYBUILD)throw Error('Local NhDeployBuild must be newer than PLC before activation');
      const remote=ftpPackage();
      if(!remote.length)throw Error('NEW_PACK.TTR is empty');
      const packages=fs.readdirSync(root).filter(name=>name.toUpperCase().endsWith('.TTR'))
        .map(name=>({name,time:fs.statSync(path.join(root,name)).mtimeMs})).sort((a,b)=>b.time-a.time);
      if(!packages.length)throw Error('No local TTR is available for verification');
      const local=fs.readFileSync(path.join(root,packages[0].name));
      if(remote.length!==local.length||digest(remote)!==digest(local))throw Error('Uploaded package differs from the newest local TTR; activation stopped');
      console.log('SHA-256 verified:',digest(local));
      console.log(`Activate uploaded TTR: ${old.NHDEPLOYBUILD} -> ${next}`);
      await activateAndVerify(old,next);
    } else {
      const next=await compileAndUpload(old);
      if(uploadOnly) {console.log(`SUCCESS: build ${next} is uploaded and SHA-256 verified; not activated.`);return;}
      await activateAndVerify(old,next);
    }
  } finally {fs.closeSync(fd);fs.unlinkSync(lock);}
}
main().catch(e=>{console.error('DEPLOY FAILED:',e.message);process.exitCode=1;});
