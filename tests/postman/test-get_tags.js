pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

pm.test("Response time is less than 10s", function () {
    pm.expect(pm.response.responseTime).to.be.below(10000);
  });
