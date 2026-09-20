function app(){
const KEY='peptide-manager-v4';
return{
compounds:[{id:'c1',name:'Tirzepatida',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c2',name:'Semaglutida',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c3',name:'Retatrutida',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c4',name:'BPC-157',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c5',name:'TB-500',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c6',name:'CJC-1295',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c7',name:'Ipamorelina',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c8',name:'GHRP-2',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c9',name:'GHRP-6',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c10',name:'Hexarelina',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c11',name:'Tesamorelina',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c12',name:'PT-141 (Bremelanotida)',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c13',name:'Selank',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c14',name:'Semax',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c15',name:'Epitalon',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c16',name:'MOTS-c',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c17',name:'AOD-9604',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c18',name:'DSIP',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c19',name:'Kisspeptina',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},{id:'c20',name:'LL-37',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'}],compoundModal:false,editingCompound:false,compoundForm:{id:null,name:'',category:'Peptídeo',initialQty:0,currentQty:0,unit:'mg'},
tab:'home',search:'',notification:'default',protocolModal:false,logModal:false,editProtocol:null,editLog:null,
month:new Date(new Date().getFullYear(),new Date().getMonth(),1),selectedDate:'',
nav:[{id:'home',icon:'fa-house',label:'Início'},{id:'applications',icon:'fa-syringe',label:'Aplicações'},{id:'stock',icon:'fa-box-open',label:'Estoque'},{id:'protocols',icon:'fa-calendar-days',label:'Protocolos'},{id:'history',icon:'fa-clock-rotate-left',label:'Histórico'}],
protocols:[],logs:[],weight:'',
formP:{id:'',name:'',dose:'',frequency:'Semanal',day:'Segunda-feira',time:'08:00'},
formL:{id:'',compound:'',custom:'',date:'',quantity:0,region:'',side:'',quadrant:''},

init(){this.load();if('Notification'in window)this.notification=Notification.permission;setInterval(()=>this.checkReminders(),30000);if('serviceWorker'in navigator&&location.protocol!=='file:')navigator.serviceWorker.register('sw.js').catch(()=>{});},
uid(){return Date.now().toString(36)+'-'+Math.random().toString(36).slice(2,8)},
today(){let d=new Date(),o=d.getTimezoneOffset()*60000;return new Date(d-o).toISOString().slice(0,10)},

openCompoundModal(c=null){this.editingCompound=!!c;this.compoundForm=c?{...c}:{id:null,name:'',category:'Peptídeo',currentQty:0,unit:'mg'};this.compoundModal=true},
formatQty(v){return Number(v||0).toLocaleString('pt-BR',{maximumFractionDigits:2})},
saveCompound(){
  const name=(this.compoundForm.name||'').trim();
  if(!name){alert('Informe o nome do composto.');return}
  const initial=Math.max(0,Number(this.compoundForm.initialQty)||0);
  const unit=this.compoundForm.unit||'mg';
  if(this.editingCompound){
    const i=this.compounds.findIndex(x=>x.id===this.compoundForm.id);
    if(i>=0){
      this.compounds[i]={...this.compounds[i],...this.compoundForm,name,currentQty:current,unit};
    }
  }else{
    this.compounds.push({
      id:'c'+Date.now(),name,
      category:(this.compoundForm.category||'Composto').trim(),
      initialQty:initial,currentQty:initial,unit
    });
  }
  this.save();
  this.compoundModal=false;
},
deleteCompound(id){if(confirm('Excluir este composto da lista?')){this.compounds=this.compounds.filter(x=>x.id!==id);this.save()}},
save(){localStorage.setItem(KEY,JSON.stringify({version:6,protocols:this.protocols,logs:this.logs,weight:this.weight,compounds:this.compounds}))},
load(){try{let d=JSON.parse(localStorage.getItem(KEY)||'null');if(d){this.protocols=d.protocols||[];this.logs=d.logs||[];this.weight=d.weight||'';this.compounds=(d.compounds||this.compounds).map(c=>({...c,initialQty:Number(c.initialQty||0),currentQty:Number(c.currentQty??c.initialQty??0),unit:c.unit||'mg'}))}}catch(e){}},
formatDateBR(s){if(!s)return'';let[a,b,c]=s.split('-');return `${c}/${b}/${a}`},
monthLabel(){return this.month.toLocaleDateString('pt-BR',{month:'long',year:'numeric'})},
changeMonth(n){this.month=new Date(this.month.getFullYear(),this.month.getMonth()+n,1);this.selectedDate=''},
goToday(){this.month=new Date(new Date().getFullYear(),new Date().getMonth(),1);this.selectedDate=this.today()},
calendarCells(){
let y=this.month.getFullYear(),m=this.month.getMonth(),start=new Date(y,m,1).getDay(),days=new Date(y,m+1,0).getDate(),a=[];
for(let i=0;i<start;i++)a.push({key:'x'+i,date:'',day:''});
for(let d=1;d<=days;d++){let date=`${y}-${String(m+1).padStart(2,'0')}-${String(d).padStart(2,'0')}`;a.push({key:date,date,day:d,count:this.logsForDate(date).length})}
return a;
},
logsForDate(d){return this.logs.filter(x=>x.date===d)},
get filteredLogs(){let q=this.search.toLowerCase();return this.logs.filter(x=>`${x.compound} ${x.siteFormatted}`.toLowerCase().includes(q)).sort((a,b)=>new Date(b.date)-new Date(a.date))},
get nextProtocols(){return [...this.protocols].sort((a,b)=>this.nextTimestamp(a)-this.nextTimestamp(b)).slice(0,3)},
scheduleText(p){return p.frequency==='Semanal'?`${p.day} às ${p.time}`:`Diário às ${p.time}`},
nextTimestamp(p){
let now=new Date(),[h,m]=p.time.split(':').map(Number),t=new Date(now);t.setHours(h,m,0,0);
if(p.frequency==='Diário'){if(t<=now)t.setDate(t.getDate()+1)}
else{let map={'Domingo':0,'Segunda-feira':1,'Terça-feira':2,'Quarta-feira':3,'Quinta-feira':4,'Sexta-feira':5,'Sábado':6},w=map[p.day]-now.getDay();if(w<0)w+=7;if(w===0&&t<=now)w=7;t.setDate(t.getDate()+w)}
return t.getTime();
},
timeUntil(p){let diff=this.nextTimestamp(p)-Date.now(),d=Math.floor(diff/86400000),h=Math.floor(diff%86400000/3600000),m=Math.floor(diff%3600000/60000);return d?`em ${d}d ${h}h`:h?`em ${h}h ${m}m`:m?`em ${m} min`:'agora'},
compoundStats(){
let map={};this.logs.forEach(l=>map[l.compound]=(map[l.compound]||0)+1);let vals=Object.entries(map).map(([name,count])=>({name,count})),max=Math.max(1,...vals.map(x=>x.count));return vals.sort((a,b)=>b.count-a.count).map(x=>({...x,percent:x.count/max*100}));
},
openProtocol(i=null){this.editProtocol=i;this.formP=i===null?{id:this.uid(),name:'',dose:'',frequency:'Semanal',day:'Segunda-feira',time:'08:00'}:JSON.parse(JSON.stringify(this.protocols[i]));this.protocolModal=true},
saveProtocol(){if(!this.formP.name.trim()||!this.formP.dose.trim()||!this.formP.time){alert('Preencha os campos obrigatórios.');return}if(this.editProtocol===null)this.protocols.push({...this.formP});else this.protocols.splice(this.editProtocol,1,{...this.formP});this.save();this.protocolModal=false},
removeProtocol(i){if(confirm('Excluir este protocolo?')){this.protocols.splice(i,1);this.save()}},
selectedLogUnit(){
let name=this.formL.compound==='Outro'?this.formL.custom:this.formL.compound;
let c=this.compounds.find(x=>x.name===name);
return c?.unit||'';
},
protocolDoseNumber(name){
let p=this.protocols.find(x=>x.name===name);
let m=String(p?.dose||'').replace(',','.').match(/\d+(?:\.\d+)?/);
return m?Number(m[0]):0;
},
openLog(i=null){
this.editLog=i;
if(i===null){
let compound=this.protocols[0]?.name||'';
this.formL={id:this.uid(),compound,custom:'',date:this.today(),quantity:this.protocolDoseNumber(compound),region:'',side:'',quadrant:''};
}else{
this.formL=JSON.parse(JSON.stringify(this.logs[i]));
this.formL.quantity=Number(this.formL.quantity||0);
}
this.logModal=true;
},
saveLog(){
let c=this.formL.compound==='Outro'?this.formL.custom.trim():this.formL.compound;
let qty=Number(this.formL.quantity||0);
if(!c||!this.formL.date||!this.formL.region||!this.formL.side){alert('Preencha composto, data, região e lado.');return}
if(!(qty>0)){alert('Informe a quantidade aplicada.');return}
let compound=this.compounds.find(x=>x.name===c);
let s=`${this.formL.region} ${this.formL.side}`+(this.formL.quadrant?` (${this.formL.quadrant})`:''),o={id:this.formL.id||this.uid(),compound:c,compoundId:compound?.id||'',quantity:qty,unit:compound?.unit||'',date:this.formL.date,siteFormatted:s};
if(this.editLog===null)this.logs.unshift(o);else this.logs.splice(this.editLog,1,o);
this.save();this.logModal=false;
},
stockUsed(c){
let total=0;
this.logs.forEach(l=>{
if((l.compoundId&&l.compoundId===c.id)||(l.compound===c.name)){total+=Number(l.quantity||0)}
});
return Math.max(0,total);
},
stockRemaining(c){
return Math.max(0,Number(c.initialQty||0)-this.stockUsed(c));
},
removeLog(i){if(confirm('Excluir este registro?')){this.logs.splice(i,1);this.save()}},
async enableNotifications(){if(!('Notification'in window)){alert('Seu navegador não oferece notificações.');return}this.notification=await Notification.requestPermission()},
checkReminders(){if(this.notification!=='granted')return;let now=new Date(),days=['Domingo','Segunda-feira','Terça-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sábado'],tm=now.toTimeString().slice(0,5),key=`r-${now.toISOString().slice(0,10)}-${tm}`;if(sessionStorage.getItem(key))return;let hit=false;this.protocols.forEach(p=>{if(p.time===tm&&(p.frequency==='Diário'||p.day===days[now.getDay()])){hit=true;if(navigator.serviceWorker?.controller)navigator.serviceWorker.ready.then(r=>r.showNotification('⏰ Peptide Manager',{body:`Lembrete: ${p.name} • ${p.dose}`,tag:p.id}));else new Notification('⏰ Peptide Manager',{body:`Lembrete: ${p.name} • ${p.dose}`})}});if(hit)sessionStorage.setItem(key,'1')},
exportData(){let b=new Blob([JSON.stringify({app:'Peptide Manager',version:6,exportedAt:new Date().toISOString(),protocols:this.protocols,logs:this.logs,weight:this.weight,compounds:this.compounds},null,2)],{type:'application/json'}),u=URL.createObjectURL(b),a=document.createElement('a');a.href=u;a.download=`peptide-manager-${this.today()}.json`;a.click();URL.revokeObjectURL(u)},
importData(e){let f=e.target.files?.[0];if(!f)return;let r=new FileReader();r.onload=()=>{try{let d=JSON.parse(r.result);if(!Array.isArray(d.protocols)||!Array.isArray(d.logs))throw 0;if(confirm('Substituir os dados atuais pelo backup?')){this.protocols=d.protocols;this.logs=d.logs;this.weight=d.weight||'';this.compounds=(d.compounds||this.compounds).map(c=>({...c,initialQty:Number(c.initialQty||0),currentQty:Number(c.currentQty??c.initialQty??0),unit:c.unit||'mg'}));this.save();alert('Backup importado.')}}catch(_){alert('Backup inválido.')}};r.readAsText(f);e.target.value=''},
clearData(){if(confirm('Apagar todos os dados deste navegador?')){localStorage.removeItem(KEY);this.protocols=[];this.logs=[];this.compounds=this.compounds.map(c=>({...c,initialQty:0,currentQty:0}));this.search='';this.tab='home';}}
}}