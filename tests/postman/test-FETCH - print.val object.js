pm.test("Status code is 201", function () {
    pm.response.to.have.status(200);
  });

pm.test("Response time is less than 3s", function () {
    pm.expect(pm.response.responseTime).to.be.below(3000);
  });
