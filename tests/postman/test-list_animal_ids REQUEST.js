pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

responsePaths = pm.response.text();
savedData = responsePaths.split("\n")[0];
pm.collectionVariables.set("savedData", savedData);
 
pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

