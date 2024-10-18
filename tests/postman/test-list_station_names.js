pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right station names", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["76 127 w                                                    ","84-PONTA-CEDROS-FUNDO","101 CORVO","ABDN Bay-4","APPA E","bpns-HD17","C2","CoastNet_PTN_Tejo_071","D1.11","F22","F36","FSUS","G4","GARD5","gm_2017_13","gn-14","HVALPSUND5","I27","IMFSTP019","IMFSTP035","L5","Ler15","LOM28","MR 23","NB014","NB028","Nene25","ngOudm","O32","OM 3","Pedra do Leao","PLANIER_EST","PREVOST_MER","PTN_#78","R 15","r02","Rt2","s-12","SB14","SN_E12_C","Sound6","VB14","Vossemeer"]);
  });

pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

