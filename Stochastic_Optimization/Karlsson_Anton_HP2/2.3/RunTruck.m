function [distanceScore, speedScore] = RunTruck(individual,iSlope,iDataSet)

mass = 2e4;
maxSpeed = 25;
minSpeed = 1;
maxSlopeAngle = 10;
maxBrakeTemperature = 750 ;
slopeLength = 1000;
deltaT = 0.1;
gearChangeCooldownTime = 2;

hiddenWeights = individual.hiddenWeights;
outputWeights = individual.outputWeights;

speed = 20;
timeSinceLastGearchange = 0;
brakeTemperature = 500;
currentGear = 7;
distanceTraveled = 0;
accumulatedSpeed = 0;
timeStep = 0;


while(distanceTraveled <= slopeLength)
  
  timeStep = timeStep +1;
  accumulatedSpeed = accumulatedSpeed + speed;
  distanceTraveled = distanceTraveled + speed*deltaT;
  
  slopeAngle = GetSlopeAngle(distanceTraveled,iSlope,iDataSet);
  
  input = [speed / maxSpeed, slopeAngle/maxSlopeAngle, brakeTemperature/maxBrakeTemperature];
  output = FeedForwardNetwork(input,hiddenWeights,outputWeights);
  
  pedalPressure = output(1);
  desiredGearChange = output(2);
  
  timeSinceLastGearchange = timeSinceLastGearchange + deltaT;
  if(timeSinceLastGearchange > gearChangeCooldownTime)
    if (desiredGearChange < 0.3 && currentGear > 1)
      currentGear = currentGear - 1;
      timeSinceLastGearchange = 0;
    elseif( desiredGearChange > 0.7 && currentGear < 10)
      currentGear = currentGear + 1;
      timeSinceLastGearchange = 0;
    end
  end
  
  gravityForce = ComputeGravityForce(mass,slopeAngle);
  engineBrakeForce = ComputeEngineBrakeForce(currentGear);
  foundationBrakeForce = ComputeFoundationBrakeForce(mass,pedalPressure,brakeTemperature);
  
  speed = UpdateVelocity(gravityForce,foundationBrakeForce,...
    engineBrakeForce,mass,speed,deltaT);
  brakeTemperature = UpdateBrakeTemperature(brakeTemperature,pedalPressure,deltaT);
  
  exceedsMaxSpeed = speed > maxSpeed;
  deceedsMinSpeed = speed < minSpeed;
  exceedsMaxBrakeTemperature = brakeTemperature > maxBrakeTemperature;
  
  if(exceedsMaxSpeed || deceedsMinSpeed || exceedsMaxBrakeTemperature)
    break
  end
  
end

averageSpeed = accumulatedSpeed / timeStep;

if(distanceTraveled >= slopeLength )
  distanceScore = 1;
else
  distanceScore = distanceTraveled/slopeLength;
end

speedScore = averageSpeed/maxSpeed;

end
