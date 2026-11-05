pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

pm.test("Response time is less than 30s", function () {
    pm.expect(pm.response.responseTime).to.be.below(30000);
  });

pm.test("Response body contains the expected fields for the created record", function () {
    const responseData = pm.response.json();
    
    pm.expect(responseData).to.be.an('object');
    pm.expect(responseData).to.have.property('dwc_occurrence');
});

