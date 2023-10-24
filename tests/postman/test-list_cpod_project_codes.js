pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

const jsonData = pm.response.json();
pm.test("returns the right cpod project codes", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members([
    "Apelafico_acoustics",
    "Apelafico_underwater",
    "cpod-lifewatch",
    "cpod-od-natuur",
    "PAM-Borssele",
    "PelFish",
    "PhD_Parcerisas",
    "SEAWave",
    "SMGMIT",
    "STRAITS_PAM",
    "VLIZ-MRC-AMUC-001",
    "VLIZ-MRC-AMUC-002",
    "WaveHub"
]);
  });
