pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });
   
pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

const jsonData = pm.response.json();
pm.test("returns the right deployment ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["35375", "33373", "14999", "38605", "15228", "59021", "48695", "39014", "48628", "1489", "39591", "29737", "1553", "49270", "39151"]);
  });
