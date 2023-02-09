pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right animal ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["GARD5","ABDN Bay-4","PLANIER_EST","IMFSTP019","R1-0m-Sonotronics","101 CORVO","F36","84-PONTA-CEDROS-FUNDO","bpns-HD17","C2","OM 3","LOM28","D1.11","SN_E12_C","I27","2021-O53","O32","Vossemeer","PTN_#78","LOM 37","IMFSTP035","CoastNet_PTN_Tejo_071","Pedra do Leao","NB028","ngOudm","gn-14","VB14","F22","SB45","Ler15","IM11","HVALPSUND5","FSUS","APPA E","L5","PREVOST_MER","Sound6","FRASERBURGH12","r02","s-12","Nene25","76 127 w                                                    ","gm_2017_13","Rt2","SB14","113582","R 15","NB014","MR 23","G4"]);
  });

pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });
