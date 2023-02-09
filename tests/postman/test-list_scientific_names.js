pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right animal ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["Dactylopterus volitans","Galeocerdo cuvier","Salmo trutta","Alosa fallax","Palinurus elephas","Torpedo torpedo","Solea senegalensis","Symphodus melops","Mobula tarapacana","Pollachius pollachius","Carcharhinus albimarginatus","Caranx ignobilis","Raja asterias","Salvelinus alpinus","Argyrosomus regius","Diplodus vulgaris","Balistes capriscus","Petromyzon marinus","Pomatomus saltatrix","Anguilla angulla","Pagellus bogaraveo","Galeorhinus galeus","Pseudocaranx dentex","Hexanchus griseus","Carcharhinus leucas","Diplodus sargus","Salmo t. trutta","Anguilla anguilla","Sphyraena barracuda","Sphyraena viridensis","Nebrius ferrugineus","Rostroraja alba","Chelon ramada","Limanda limanda","Seriola dumerili ","Salmo salar","Scyliorhinus stellaris","Scyllarides latus","Oncorhynchus mykiss","Seriola rivoliana","Sander lucioperca","Test testium","Labrus bergylta","Coryphaena hippurus"," Salmo trutta","Thunnus thynnus","Scyliorhinus canicula","Built-in","Dentex dentex","Mustelus sp."]);
  });

pm.test("Response time is less than 3s", function () {
    pm.expect(pm.response.responseTime).to.be.below(3000);
  });
