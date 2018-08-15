function foundationBrakeforce = ComputeFoundationBrakeForce(mass,...
  pedalPressure,brakeTemperature)

maxBrakeTemperature = 750;
g=9.82; 
tresholdTemperature = maxBrakeTemperature - 100;

foundationBrakeforce = mass*g/20 * pedalPressure;

if(brakeTemperature >=  tresholdTemperature)
  overHeatingFactor = exp(-(brakeTemperature-tresholdTemperature)/100);
  foundationBrakeforce = foundationBrakeforce * overHeatingFactor;
end

end
