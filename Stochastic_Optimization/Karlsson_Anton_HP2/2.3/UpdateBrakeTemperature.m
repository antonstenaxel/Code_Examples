function updatedBrakeTemperature = UpdateBrakeTemperature(...
  currentBrakeTemperature,pedalPressure,deltaT)

C_h = 40;
tau = 30;
ambientTemperature = 283;

relativeBrakeTemperature = currentBrakeTemperature - ambientTemperature;

if(pedalPressure < 0.01)
  deltaRelativeBrakeTemperature = - relativeBrakeTemperature / tau;
else
  deltaRelativeBrakeTemperature =  C_h * pedalPressure;
end

updatedRelaviveBrakeTemperature = relativeBrakeTemperature + ...
  deltaRelativeBrakeTemperature*deltaT;

updatedBrakeTemperature = ambientTemperature + updatedRelaviveBrakeTemperature;

if(updatedBrakeTemperature < ambientTemperature)
  updatedBrakeTemperature = ambientTemperature;
end


end
