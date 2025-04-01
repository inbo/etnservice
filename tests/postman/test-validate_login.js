pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Response time is less than 15s", function () {
    pm.expect(pm.response.responseTime).to.be.below(15000);
});
pm.test("Response is exactly [true]", function () {
    pm.expect(pm.response.json()).to.eql([true]);
});
