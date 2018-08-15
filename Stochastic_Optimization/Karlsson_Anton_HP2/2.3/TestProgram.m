clear all; clc; clf
data = load('bestIndividual.mat');
Individual = data.bestValidationIndividual;

iDataSet = 2;
iSlope = 1;

maxSpeed = 25;
minSpeed = 1;
maxSlopeAngle = 10;
maxBrakeTemperature = 750 ;
slopeLength = 1000;
deltaT = 0.1;
gearChangeCooldownTime = 2;

brakeTemperature = 500;
currentGear = 7;
speed = 20;
mass = 20000;

hiddenWeights = Individual.hiddenWeights;
outputWeights = Individual.outputWeights;

distanceTraveled = 0;
accumulatedSpeed = 0;
timeSinceLastGearchange = 0;
timeStep = 0;
pedalPressure = 0;
slopeAngle = GetSlopeAngle(distanceTraveled,iSlope,iDataSet);
gearSeries = zeros(1,1e3);
distanceSeries  = zeros(1,1e3);
slopeSeries  = zeros(1,1e3);
pedalSeries  = zeros(1,1e3);
speedSeries  = zeros(1,1e3);
tempSeries  = zeros(1,1e3);

while(distanceTraveled <= slopeLength)
  timeStep = timeStep +1;
  
  distanceSeries(timeStep) = distanceTraveled;
  gearSeries(timeStep) = currentGear;
  slopeSeries(timeStep) = slopeAngle;
  pedalSeries(timeStep) = pedalPressure;
  speedSeries(timeStep) = speed;
  tempSeries(timeStep) = brakeTemperature;
  
  slopeAngle = GetSlopeAngle(distanceTraveled,iSlope,iDataSet);
  
  accumulatedSpeed = accumulatedSpeed + speed;
  distanceTraveled = distanceTraveled + speed*deltaT;
  
  input = [speed / maxSpeed, slopeAngle/maxSlopeAngle, brakeTemperature/maxBrakeTemperature];
  output = FeedForwardNetwork(input,hiddenWeights,outputWeights);
  
  pedalPressure = output(1);
  desiredGearChange = output(2);
  
  timeSinceLastGearchange = timeSinceLastGearchange + deltaT;
  if(timeSinceLastGearchange > gearChangeCooldownTime)
    if (desiredGearChange < 0.3 && currentGear > 1)
      currentGear = currentGear -1;
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

subplot(5,1,1)
plot(distanceSeries(1:timeStep),slopeSeries(1:timeStep));
title('Slope');
axis([0,1000,0,10]);
grid on 

subplot(5,1,2)
plot(distanceSeries(1:timeStep),pedalSeries(1:timeStep));
title('PedalPressure')
axis([0,1000,0,1])
grid on 

subplot(5,1,3)
plot(distanceSeries(1:timeStep),gearSeries(1:timeStep));
title('Gear');
axis([0,1000,1,10])
yticks([1,5,10])
grid on 

subplot(5,1,4)
plot(distanceSeries(1:timeStep),speedSeries(1:timeStep));
title('Speed')
axis([0,1000,1,25])
grid on 

subplot(5,1,5);
plot(distanceSeries(1:timeStep),tempSeries(1:timeStep));
title('Brake temperature');
axis([0,1000,0,750])
yticks([0,250,500,750])
grid on 

