pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right animal project codes", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["amsterdam", "PhD_Goossens", "DAbecasis_PhD", "SPAWNSEIS", "CONNECT-MED", "SMOLTRACK-Skjern-2017", "Running_eel"]);
  });

pm.test("Response time is less than 5s", function () {
    pm.expect(pm.response.responseTime).to.be.below(5000);
  });

