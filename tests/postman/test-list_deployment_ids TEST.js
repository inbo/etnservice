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
      pm.expect(jsonData).to.include.members(["54672", "28703", "26058", "10009", "8770", "27578", "4788", "6214", "56698", "1716", "65055", "55006", "3240", "1543", "12836"]);
  });
