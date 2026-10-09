// V13 TTR transfer only; does not activate the package.
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto'),{spawnSync}=require('node:child_process');
const root=path.resolve(__dirname,'..');
const host=require('./settings.json')['mosaic.plcHost'].split(':')[0];
if(process.argv.includes('--compile')) require('./build-plc.cjs').build({root});
const files=fs.readdirSync(root).filter(x=>x.endsWith('.TTR')).sort((a,b)=>fs.statSync(path.join(root,b)).mtimeMs-fs.statSync(path.join(root,a)).mtimeMs);
const local=path.join(root,files[0]);
const cred=spawnSync('security',['find-generic-password','-s',`NachHouse FTP ${host} deployment`,'-w'],{encoding:'utf8'});
if(cred.status!==0||!cred.stdout.trim())throw Error('FTP credential unavailable');
const password=cred.stdout.trim();
function transfer(args){const r=spawnSync('curl',['--silent','--show-error','--fail','--connect-timeout','10','--max-time','60','--config','-',...args],{input:'user = "nhftp:'+password.replace(/\\/g,'\\\\').replace(/"/g,'\\"')+'"\n',maxBuffer:16*1024*1024});if(r.status!==0)throw Error('FTP failed: '+(r.stderr||'').toString());return r.stdout;}
const start=performance.now();transfer(['--upload-file',local,`ftp://${host}/WWW/UPLOAD/NEW_PACK.TTR`]);const uploadMs=performance.now()-start;
const readStart=performance.now();const remote=transfer([`ftp://${host}/WWW/UPLOAD/NEW_PACK.TTR`]);const readMs=performance.now()-readStart;
const bytes=fs.readFileSync(local),hash=x=>crypto.createHash('sha256').update(x).digest('hex');
if(!bytes.equals(remote))throw Error('Uploaded bytes differ');
console.log(JSON.stringify({file:files[0],bytes:bytes.length,uploadMs:Math.round(uploadMs),readbackMs:Math.round(readMs),sha256:hash(bytes),verified:true,activated:false}));
