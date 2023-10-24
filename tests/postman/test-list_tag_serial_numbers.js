pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

const jsonData = pm.response.json();
pm.test("returns the right tag serial numbers", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["04C6", "1734024", "20169187","A69-1602-30050", "1290765", "21293183", "JS031725", "A17665"
]);
  });
