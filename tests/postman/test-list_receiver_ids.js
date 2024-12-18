pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
  });
  
const jsonData = pm.response.json();
pm.test("returns the right receiver ids", () => {
      //array is not empty
      pm.expect(jsonData).to.not.be.empty;
      //ids include number of known values
      pm.expect(jsonData).to.include.members(["HR2-180K-100-LI-461548","TBR700-33","TBR700-001198","TBR700L-1360","TBR700R-1441","VR2-5528","VR2-5531","VR2-7333c","VR2AR-547670","VR2AR-551407","VR2TX-480264","VR2TX-480410","VR2TX-481233","VR2TX-481427","VR2TX-482289","VR2TX-482914","VR2TX-482923","VR2TX-482938","VR2TX-482979","VR2TX-482997","VR2TX-486358","VR2W-112220","VR2W-112364","VR2W-115447","VR2W-120448","VR2W-120630","VR2W-122356","VR2W-125463","VR2W-125699","VR2W-126196","VR2W-126317","VR2W-127562","VR2W-127720","VR2W-130679","VR2W-130998","VR2W-134016","VR2W-134234","VR2W-134359","VR2W-134524","VR2W-134532","VR2W-134861","VR2W-135353","VR2W-135649","VR2W-135804","VR2W-135891","VR2W-136585","VR2W-137075","WHS 3250D-MAP6001500101"]);
  });
  
pm.test("Response time is less than 3s", function () {
      pm.expect(pm.response.responseTime).to.be.below(3000);
  });

