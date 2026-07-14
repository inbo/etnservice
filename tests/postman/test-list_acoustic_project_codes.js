pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });
  
const jsonData = pm.response.json();
pm.test("returns the right acoustic project codes", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["Mobula_IMAR","Sudle_IMPULS","SVNL-FISH-WATCH","Inforbiomares","BOOGMR","ws2","zeeschelde","LESPUR","ws3","RESBIO","ST08SWE","PTN-Silver-eel-Mondego","Jersey_Coastal","Deveron","KBTN","FISHINTEL","Siganid_Gulf_Aqaba","Danube_Sturgeons","VVV","Walloneel","V2LCASP","BOOPIRATA","2015_PhD_Gutmann_Roberts","OTN_UPLOAD","NTNU-Gaulosen","BTN-IMEDEA","Reelease","AZO","PhD_Marrocco","2017_Fremur","paintedcomber","none","ARAISOLA03","PhysFish","life4fish","GIBRALTRACK_pilot","Artevigo","V2LGOL","SWIMWAY_2021","PhD_Jeremy_Pastor","PTN/PROTECT2012","MIGRATOEBRE","MOPP","V2LNR","eemskanaal_III"]);
  });
  
pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

