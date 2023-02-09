pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });
  
  const jsonData = pm.response.json();
  pm.test("returns the right animal ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["GIBRALTRACK_pilot","FISHINTEL","LamYorOus18-20","SMUCC","2016_Diaccia_Botrona","2015_fint","2013_albertkanaal","Rijke_Noordzee","mepnsw","VMLSOCBS","ASMOP2","Top-Predator","2014_Nene","Noordzeekanaal","2015_phd_verhelst_eel","CESB","Fish_Mig_Wad_Sea","2015_phd_verhelst_cod","MIGRATOEBRE","RNP","SARTELZINGARO","VVV","SVNL-WS","MBA_Massmo","Skye","FISHOWF","RAS","MICHIMIT","V2LNR","PTN/PROTECT2012/whiteseabream","PLASTIBE","2015_Albertkanaal_VPS_Ham","SU.MO.ELASMO.Adriatic","2021_Gudena","BFTDK","OP-Test","amsterdam","BTN-DeepWater-IMEDEA","KBTN_FISH","2012_leopoldkanaal","SEMP","BlueCrab2022Algarve","Eel-source-to-sea","SwanseaSeaTroutAdult","kornwerderzand","2015_dijle","codnoise","CONNECT-MED","FISHGAL","2013_Foyle"]);
  });
  
  pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });