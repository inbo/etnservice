pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });
  
const jsonData = pm.response.json();
pm.test("returns the right animal ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members([226,227,238,18075,20353,22677,60575,6527]);
  });
  
pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

