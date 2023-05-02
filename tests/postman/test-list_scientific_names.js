pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right animal ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["Alosa fallax", "Anguilla anguilla", "Argyrosomus regius", "Balistes capriscus", "Built-in", "Caranx ignobilis", "Carcharhinus albimarginatus", "Carcharhinus leucas", "Chelon ramada", "Coryphaena hippurus", "Dactylopterus volitans", "Dentex dentex", "Diplodus sargus", "Diplodus vulgaris", "Galeocerdo cuvier", "Galeorhinus galeus", "Hexanchus griseus", "Labrus bergylta", "Limanda limanda", "Mobula tarapacana", "Mustelus sp.", "Nebrius ferrugineus", "Oncorhynchus mykiss", "Pagellus bogaraveo", "Palinurus elephas", "Petromyzon marinus", "Pollachius pollachius", "Pomatomus saltatrix", "Pseudocaranx dentex", "Raja asterias", "Rostroraja alba", "Salmo salar", "Salmo t. trutta", "Salmo trutta", "Salvelinus alpinus", "Sander lucioperca", "Scyliorhinus canicula", "Scyliorhinus stellaris", "Scyllarides latus", "Seriola dumerili", "Seriola rivoliana", "Solea senegalensis", "Sphyraena barracuda", "Sphyraena viridensis", "Symphodus melops", "Test testium", "Thunnus thynnus", "Torpedo torpedo"]);
  });

pm.test("Response time is less than 3s", function () {
    pm.expect(pm.response.responseTime).to.be.below(3000);
  });
