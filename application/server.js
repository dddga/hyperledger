// 1. 모듈포함
const express = require("express");
const bodyParser = require("body-parser");
const fs = require("fs");
const path = require("path");
const FabricCAServices = require("fabric-ca-client");
const { Gateway, Wallets } = require("fabric-network");
const sha256 = require("sha256");

// 2. connection.json 객체화
const ccpPath = path.resolve(__dirname, "ccp", "connection-org1.json");
const ccp = JSON.parse(fs.readFileSync(ccpPath, "utf8"));

// 3. 서버설정
const app = express();
app.use(express.static(path.join(__dirname, "views")));

const PORT = 3000;
const HOST = "0.0.0.0";

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));


// 4. REST api 라우팅
app.get("/", (req,res)=>{
  res.sendFile(__dirname + "/views/index.html");
});
app.get("/main", (req,res)=>{
  res.sendFile(__dirname+"/views/main.html")
});
app.get("/makeDraw", (req, res) => {
  res.sendFile(__dirname+"/views/makeDraw.html");
});
app.get("/joinDraw", (req, res) => {
  res.sendFile(__dirname+"/views/joinDraw.html");
});
app.get("/confirmDraw", (req, res) => {
  res.sendFile(__dirname+"/views/confirmDraw.html");
});
app.get("/deleteDraw", (req, res) => {
  res.sendFile(__dirname+"/views/deleteDraw.html");
});


app.post("/makeDraw-form", async (req, res) => {
  const drawname = req.body.drawname;
  const did = req.body.did;
  const drawtype = req.body.drawtype
  const maxpeople = req.body.maxpeople
  const period = req.body.period;
  const randnum = req.body.randnum;
  const timestamp = req.body.timestamp;
  const maker=true
  const drawnamedid = sha256(drawname+did);

  console.log("/makeDraw-post - '" + drawname + "':'" + did + "':'" + randnum + "':'" + timestamp + "':'");

  try{
    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(process.cwd(), "wallet");
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    // Create a new CA client for interacting with the CA.
    const caURL = ccp.certificateAuthorities["ca.org1.fortune.infinity"].url;
    const ca = new FabricCAServices(caURL);
    
    const userIdentityIs = await wallet.get(did);
    if (!userIdentityIs) {
      await userCreate(wallet, ca, did);
    }
    const userIdentity = await wallet.get(did);
    
    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: did, discovery: { enabled: true, asLocalhost: true } });
    console.log("gateway connect succses")
    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork("infinity");
    // Get the contract from the network. 
    const contract = network.getContract("fortuneInfinity");

    //
    drawExist = await contract.evaluateTransaction("FindDraw", drawname);
    drawExist = JSON.parse(drawExist)
    if (drawExist){
      res.write(`<script>alert("Draw[${drawname}] already exist")</script>`)
      res.write("<script>window.location=\"../makeDraw\"</script>");
      return;
    }
    

    // Submit the specified transaction.
    console.log("\n--> Submit Transaction: CreateDraw, creates new draw with drawname, did, type, randnum, timestamp");
    await contract.submitTransaction("CreateDraw",drawnamedid, drawname, did, randnum, timestamp, maker);
    console.log("Transaction(CreateDraw) has been submitted");

    // response -> client
    await gateway.disconnect();
  } catch(error){
    res.write(`<script>alert("error occured")</script>`)
    console.log(`error occured - ${error} `)
    res.write("<script>window.location=\"../makeDraw\"</script>");
    return;
  }
  //var mchtml = res.readFileSync("/views/makeComplete.html", "utf-8")
  fs.readFile(path.join(__dirname, "views/makeComplete.html"), "utf-8", (err,data)=>{
    console.log("readfile success")
    var replaceData = data.
    replace(/@@drawname@@/g, drawname).
    replace(/@@did@@/g, did).
    replace(/@@drawtype@@/g, drawtype).
    replace(/@@maxpeople@@/g, maxpeople).
    replace(/@@period@@/g, period);
    res.writeHead(200, {'Content-type':'text/html'});
    res.write(replaceData);
    res.end();
  })
});

app.post("/confirmDraw-form", async (req, res) => {
  const drawname = req.body.drawname
  const did = req.body.did;
  const drawnamedid = sha256(drawname+did);

  console.log("/draw " + drawname+" "+did);

  try{
    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(process.cwd(), "wallet");
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    // Check to see if we've already enrolled the admin user.
    const identity = await wallet.get(did);
    if (!identity) {
      res.write(`<script>alert("your DID[${did}] doesn't exist")</script>`)
      res.write("<script>window.location=\"../confirmDraw\"</script>");
      return;
    }

    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: did, discovery: { enabled: true, asLocalhost: true } });
    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork("infinity");
    // Get the contract from the network.
    const contract = network.getContract("fortuneInfinity");

    
    drawExist = await contract.evaluateTransaction("FindDraw", drawname);
    drawExist = JSON.parse(drawExist)
    console.log(drawExist)
    if (!drawExist){
      res.write(`<script>alert("Draw[${drawname}] doesn't exist")</script>`)
      res.write("<script>window.location=\"../confirmDraw\"</script>");    
      return;
    }

    // Submit the specified transaction.
    console.log(`\n--> Evaluate Transaction: ConfirmDraw, function returns "${drawnamedid}" attributes`);
    result = await contract.evaluateTransaction("ConfirmDraw", drawnamedid);
    IsWinner = await contract.evaluateTransaction("ConfirmDraw", drawnamedid+"!");
    if (result.length == 0){
      res.write(`<script>alert("you didn't participate - Draw[${drawname}]")</script>`)
      res.write("<script>window.location=\"../confirmDraw\"</script>");
      return
    }
    result = JSON.parse(result)
    // response -> client
    await gateway.disconnect();
  } catch(error){
    res.write(`<script>alert("error occured")</script>`)
    console.log(`error occured - ${error} `)
    res.write("<script>window.location=\"../confirmDraw\"</script>");
    return;
  }
  if (result.maker == true){
    fs.readFile(path.join(__dirname, "views/confirmComplete.html"), "utf-8", (err,data)=>{
      console.log("readfile success")
      var replaceData = data.
      replace(/@@drawname@@/g, result.drawname).
      replace(/@@did@@/g, result.did).
      replace(/@@randnum@@/g, result.randnum).
      replace(/@@timestamp@@/g, result.timestamp).
      replace(/@@maker@@/g, 
      `<form action="/runningDraw" method="post">
        <input type="hidden" name="drawname" value="${drawname}"></input>
        <input type="hidden" name="did" value="${did}"></input>
        <input type="submit" class="btn btn-lg btn-secondary fw-bold border-white bg-white" value="Running Draw"></input>
      </form>`);
      res.writeHead(200, {'Content-type':'text/html'});
      res.write(replaceData);
      res.end();
    });
  }else{
    if (IsWinner.length==0){
      fs.readFile(path.join(__dirname, "views/confirmComplete.html"), "utf-8", (err,data)=>{
        console.log("readfile success")
        var replaceData = data.
        replace(/@@drawname@@/g, result.drawname).
        replace(/@@did@@/g, result.did).
        replace(/@@randnum@@/g, result.randnum).
        replace(/@@timestamp@@/g, result.timestamp).
        replace(/@@maker@@/g,"");
        res.writeHead(200, {'Content-type':'text/html'});
        res.write(replaceData);
        res.end();
      });
    }else{
      fs.readFile(path.join(__dirname, "views/confirmComplete.html"), "utf-8", (err,data)=>{
        console.log("readfile success")
        var replaceData = data.
        replace(/@@drawname@@/g, result.drawname).
        replace(/@@did@@/g, result.did).
        replace(/@@randnum@@/g, result.randnum).
        replace(/@@timestamp@@/g, result.timestamp).
        replace(/@@maker@@/g,
        `<h2 style="color:red;font-weight:bold">Congratulations! You have won</h1>`
        );
        res.writeHead(200, {'Content-type':'text/html'});
        res.write(replaceData);
        res.end();
      });
    }
  }
});

app.post("/joinDraw-form", async(req, res)=>{
  const drawname = req.body.drawname;
  const did = req.body.did;
  const randnum = req.body.randnum;
  const timestamp = req.body.timestamp;
  const drawnamedid = sha256(drawname+did);
  const maker=false

  try{
    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(process.cwd(), "wallet");
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    // Create a new CA client for interacting with the CA.
    const caURL = ccp.certificateAuthorities["ca.org1.fortune.infinity"].url;
    const ca = new FabricCAServices(caURL);
    
    const userIdentityIs = await wallet.get(did);
    if (!userIdentityIs) {
      await userCreate(wallet, ca, did);
    }
    const userIdentity = await wallet.get(did);
    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: did, discovery: { enabled: true, asLocalhost: true } });
    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork("infinity");
    // Get the contract from the network. 
    const contract = network.getContract("fortuneInfinity");

    drawExist = await contract.evaluateTransaction("FindDraw", drawname);
    drawExist = JSON.parse(drawExist)

    if (!drawExist){
      res.write(`<script>alert("Draw[${drawname}] doesn't exist")</script>`)
      res.write("<script>window.location=\"../joinDraw\"</script>");    
      return;
    }

    //check database existed
    result = await contract.evaluateTransaction("ConfirmDraw", drawnamedid);
    if (result.length != 0){
      res.write(`<script>alert("your DID[${did}] is already participated ")</script>`)
      res.write("<script>window.location=\"../main\"</script>");
      return
    }
  

    // Submit the specified transaction.
    console.log("\n--> Submit Transaction: joinDraw, joins new draw with drawname, did, randnum, timestamp");
    await contract.submitTransaction("CreateDraw", drawnamedid, drawname, did, randnum, timestamp, maker);
    console.log("Transaction(CreateDraw) has been submitted");

    result = await contract.evaluateTransaction("ConfirmDraw", drawnamedid);
    result = JSON.parse(result)

    // response -> client
    await gateway.disconnect();
  } catch(error){
    res.write(`<script>alert("error occured")</script>`)
    console.log(`error occured - ${error} `)
    res.write("<script>window.location=\"../joinDraw\"</script>");
    return;
  }
  //var mchtml = res.readFileSync("/views/makeComplete.html", "utf-8")
  fs.readFile(path.join(__dirname, "views/joinComplete.html"), "utf-8", (err,data)=>{
    console.log("readfile success")
    var replaceData = data.
    replace(/@@drawname@@/g, result.drawname).
    replace(/@@did@@/g, result.did).
    replace(/@@randnum@@/g, result.randnum).
    replace(/@@timestamp@@/g, result.timestamp);
    res.writeHead(200, {'Content-type':'text/html'});
    res.write(replaceData);
    res.end();
  })

})

app.post("/deleteDraw-form", async (req, res) => {
  const drawname = req.body.drawname;
  const did = req.body.did
  const drawnamedid = sha256(drawname+did);

  try{
    // Create a new file system based wallet for managing identities.
    const walletPath = path.join(process.cwd(), "wallet");
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);

    // Check to see if we've already enrolled the admin user.
    const identity = await wallet.get(did);
    if (!identity) {
      res.write(`<script>alert("your DID[${did}] doesn't exist")</script>`)
      res.write("<script>window.location=\"../deleteDraw\"</script>");
      return;
    }

    // Create a new gateway for connecting to our peer node.
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: did, discovery: { enabled: true, asLocalhost: true } });
    // Get the network (channel) our contract is deployed to.
    const network = await gateway.getNetwork("infinity");
    // Get the contract from the network.
    const contract = network.getContract("fortuneInfinity");

    drawExist = await contract.evaluateTransaction("FindDraw", drawname);
    drawExist = JSON.parse(drawExist)

    if (!drawExist){
      res.write(`<script>alert("Draw[${drawname}] doesn't exist")</script>`)
      res.write("<script>window.location=\"../deleteDraw\"</script>");    
      return;
    }
    
    // Submit the specified transaction.
    console.log(`\n--> Submit Transaction: DeleteDraw ${did}'s draw`);
    result = await contract.submitTransaction("DeleteDraw", drawnamedid);
    result = JSON.parse(result)
    if (result){
      console.log("Transaction(DeleteDraw) has been submitted");
      
    }else{
      res.write(`<script>alert("your Draw[${drawname}] doesn't exist")</script>`)
      res.write("<script>window.location=\"../deleteDraw\"</script>");
      return;
    }
    // response -> client
    await gateway.disconnect();
    
  } catch(error){
    res.write(`<script>alert("error occured")</script>`)
    console.log(`error occured - ${error} `)
    res.write("<script>window.location=\"../deleteDraw\"</script>");
    return;
  }
  fs.readFile(path.join(__dirname, "views/deleteComplete.html"), "utf-8", (err,data)=>{
    console.log("readfile success")
    var replaceData = data.
    replace(/@@drawname@@/g, drawname).
    replace(/@@did@@/g, did);
    res.writeHead(200, {'Content-type':'text/html'});
    res.write(replaceData);
    res.end();
  })
  console.log(`Your draw has been deleted`)
});

// 5. 서버시작
app.listen(PORT, HOST);
console.log(`Running on http://${HOST}:${PORT}`);

app.post("/runningDraw", async(req,res)=>{
  const drawname = req.body.drawname;
  const did = req.body.did;

  try{
    const walletPath = path.join(process.cwd(), "wallet");
    const wallet = await Wallets.newFileSystemWallet(walletPath);
    console.log(`Wallet path: ${walletPath}`);
    const identity = await wallet.get(did);

    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: did, discovery: { enabled: true, asLocalhost: true } });
    const network = await gateway.getNetwork("infinity");
    const contract = network.getContract("fortuneInfinity");

    // Allquery
    var allquery = await contract.evaluateTransaction("AllDrawQuery");
    allquery = JSON.parse(allquery)
    var drawUsers = selectedDraw(allquery, drawname);
    var makerInfo
    for (i=0;i<drawUsers.length;i++){
      if (drawUsers[i].Value.maker == true){
        makerInfo = drawUsers[i];
        break;
      }
    }
    var winner = findWinner(makerInfo, drawUsers);
    winner.Value.maker = true
    console.log("winner is :")
    console.log(winner)
    await contract.submitTransaction("CreateDraw",
    winner.key+"!", winner.Value.drawname, winner.Value.did, winner.Value.randnum, winner.Value.timestamp, winner.Value.maker)
    console.log("Transaction has been submitted")
    await gateway.disconnect();

  }catch(error){
    res.write(`<script>alert("error occured")</script>`)
    console.log(`error occured - ${error} `)
    res.write("<script>window.location=\"../confirmDraw\"</script>");
    return;
  }
  res.write(`<script>alert("running complete!")</script>`)
  console.log(`running draw success`)
  res.write("<script>window.location=\"../main\"</script>");
  res.end();
})

// user 생성 함수
async function userCreate(wallet, ca, did){
  // Check to see if we've already enrolled the admin user.
  const adminIdentity = await wallet.get("admin");
  if (!adminIdentity) {
    console.log(
        'An identity for the admin user "admin" does not exist in the wallet'
    );
    return;
  }

  // Check to see if we've already enrolled the user.
  const userIdentity = await wallet.get(did);
  if (!userIdentity) {
    console.log(
        `Start creating user ${did} !`
    );

    // build a user object for authenticating with the CA
    const provider = wallet.getProviderRegistry().getProvider(adminIdentity.type);
    const adminUser = await provider.getUserContext(adminIdentity, "admin");

    const secret = await ca.register(
      {
        affiliation: "org1.department1",
        enrollmentID: did,
        role: "client",
      },
      adminUser
    );
    const enrollment = await ca.enroll({
      enrollmentID: did,
      enrollmentSecret: secret,
    });
    const x509Identity = {
      credentials: {
        certificate: enrollment.certificate,
        privateKey: enrollment.key.toBytes(),
      },
      mspId: "Org1MSP",
      type: "X.509",
    };
    await wallet.put(did, x509Identity);
    console.log('Successfully registered and enrolled user did and imported it into the wallet');
  }
}
function selectedDraw(allquery, drawname) {
  var drawUser =[];

  for (i=0;i<allquery.length;i++){
    if (allquery[i].Value.drawname == drawname){
      drawUser.push(allquery[i])
    }
  }
  return drawUser;
}
function findWinner(maker, drawUsers) {
  var sameScoreUsers;
  var makeridx = 0;
  var findidx = 0;

  drawUsers.sort(function(a,b){
    var arand = a.Value.randnum, brand = b.Value.randnum;
    if (arand==brand){
      return a.Value.timestamp - b.Value.timestamp
    }
    return arand-brand;
  });

  for (var i=0;i<drawUsers.length;i++){
    diffval = drawUsers[i].Value.randnum - maker.Value.randnum
    drawUsers[i].Value.randnum = diffval;
    if (drawUsers[i] == maker){
      makeridx = i
    }
  }
  console.log(makeridx, drawUsers)
  if (makeridx == 0){
    findidx = makeridx+1
    sameScoreUsers = drawUsers[findidx]
  }else if(makeridx==drawUsers.length-1){
    findidx = makeridx-1
    var i
    findrandnum = drawUsers[findidx].Value.randnum
    for (i=findidx;i>=0;i--){
      if (drawUsers[i].Value.randnum != findrandnum){
        break;
      }
    }
    sameScoreUsers = drawUsers[i+1]
  }else{
    if (Math.abs(drawUsers[makeridx-1].Value.randnum) > Math.abs(drawUsers[makeridx+1].Value.randnum)){
      findidx = makeridx+1
      sameScoreUsers.push(drawUsers[findidx])
    }else if (Math.abs(drawUsers[makeridx-1].Value.randnum) < Math.abs(drawUsers[makeridx+1].Value.randnum)){
      findidx = makeridx-1
      findrandnum = drawUsers[findidx].Value.randnum
      for (i=findidx;i>=0;i--){
        if (drawUsers[i].Value.randnum != findrandnum){
          break;
        }
      }
      sameScoreUsers = drawUsers[i+1]
    }
  }
  return sameScoreUsers;
}

