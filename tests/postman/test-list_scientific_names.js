pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right scientific names", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["Octopus vulgaris","Sander lucioperca","Salmo trutta trutta Linnaeus","Esox lucius","Palinurus elephas","Acipenser oxyrinchus","Solea senegalensis","Cetorhinus maximus","Rostroraja alba","Rutilus rutilus","Muraena helena","Galeorhinus galeus","Cyprinus carpio","Scophthalmus maximus","Lampetra fluviatilis"]);
  });

pm.test("Response time is less than 3s", function () {
    pm.expect(pm.response.responseTime).to.be.below(3000);
  });

