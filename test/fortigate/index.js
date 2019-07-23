var udp = require('dgram');

var buffer = require('buffer');

// creating a client socket

Promise.resolve().then(() => {
  var client = udp.createSocket('udp4');
  let promiseArray = [];
  for(let i=0;i<100;i++) {
    promiseArray.push(sendMessage(client,9910,"error",2019));
  }
  return Promise.all(promiseArray);
}).then(() => {
  // var client = udp.createSocket('udp4');
  // let promiseArray = [];
  // for(let i=0;i<100;i++) {
  //   promiseArray.push(sendMessage(client,9912,"warn",2019));
  // }
  // return Promise.all(promiseArray);
}).then(() => {
  process.exit();
})
  
  function sendMessage(clientInstance, port,level,yaer) {
    return new Promise((resolve,reject) => {
      clientInstance.send(`<22>date=${yaer}-1-15 time=11:44:16 logid="0000000013" type="traffic" subtype="forward" level="${level}" vd="vdom1" eventtime=1510775056 srcip=10.1.100.155 srcname="pc1" srcport=40772 srcintf="port12" srcintfrole="undefined" dstip=35.197.51.42 dstname="fortiguard.com" dstport=443 dstintf="port11" dstintfrole="undefined" poluuid="707a0d88-c972-51e7-bbc7-4d421660557b" sessionid=8058 proto=6 action="close" policyid=1 policytype="policy" policymode="learn" service="HTTPS" dstcountry="United States" srccountry="Reserved" trandisp="snat" transip=172.16.200.2 transport=40772 appid=40568 app="HTTPS.BROWSER" appcat="Web.Client" apprisk="medium" duration=2 sentbyte=1850 rcvdbyte=39898 sentpkt=25 rcvdpkt=37 utmaction="allow" countapp=1 devtype="Linux PC" osname="Linux" mastersrcmac="a2:e9:00:ec:40:01" srcmac="a2:e9:00:ec:40:01" srcserver=0 utmref=0-220586`,
      port,'127.0.0.1',function(error){
          if(error){
            client.close();
          }else{
            console.log('Data sent !!!');
            resolve();
          }
        });
    })
  }