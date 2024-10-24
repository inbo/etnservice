pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });

const jsonData = pm.response.json();
pm.test("returns the right acoustic tag ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["A69-1008-210","A69-1105-72","A69-1303-328","A69-1303-0709","A69-1303-3966","A69-1303-4095","A69-1303-4120","A69-1303-4194","A69-1303-4591","A69-1303-6478","A69-1303-6997","A69-1303-9363","A69-1303-9509","A69-1303-12067","A69-1303-12644","A69-1303-26461","A69-1303-33684","A69-1601-2719","A69-1601-9609","A69-1601-38746","A69-1602-3082","A69-1602-13167","A69-1602-13427","A69-1602-13430","A69-1602-13493","A69-1602-20523","A69-1602-20572","A69-1602-24986","A69-1602-25135","A69-9001-62964","A69-9006-1852","A69-9006-4742","A69-9007-2438","A180-1702-48915","A180-1702-51826","OPI-494","OPI-640","OPI-748","R64K-108","R64K-0691","R64K-0701","R64K-0738","R64K-1094","R64K-4167","R64K-5037","R64K-9396","R64K-41143"]);
  });

  pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

