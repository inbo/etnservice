pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right station names", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["above-kaunas-2","below-kaunas-3","klaipeda-4","Rusne-3","klaipeda-3","klaipeda-2","Rusne-4","Rusne-2","below-kaunas-2","above-kaunas-4","Sound2","Sound5","Sound4","Sound1","Sound6","Sound7","Sound3","Sound8","11","4","5","10","2","8","7","9","3","St08","St02","St25","St04","St19","St16","St27","St22","St23","St28","U/S Wetherby Weir ","U/S Naburn weir lhb","U/S Crakehill gauging weir","U/S Cromwell","D/S Linton weir right bank","U/S Swale conf","D/S Boroughbridge Weir","Maunby or Morton Bridge","D/S Kirk Hammerton","18","16","15","14","LANAYE","KINKEMPOIS","ANHEE","FREYR","DINANT","NAMUR","KEIZERSVEERBRUG_LB","we-ak-5","MOOK"]);
  });

pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

