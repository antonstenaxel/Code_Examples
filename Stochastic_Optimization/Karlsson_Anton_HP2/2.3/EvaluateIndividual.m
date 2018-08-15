function fitnessValue = EvaluateIndividual(individual,iDataSet)

breakPenaltyFactor = 0;
meanFitnessFactor = 0.5;
worstFitnessFactor = 0.5;

switch(iDataSet)
  case 1
    numberOfSlopes = 10;
  case 2
    numberOfSlopes = 5;
  case 3
    numberOfSlopes = 5;
end

fitnessValues = zeros(1,numberOfSlopes);
for iSlope= 1 : numberOfSlopes
  [distanceScore, speedScore] = RunTruck(individual,iSlope,iDataSet);
  fitnessValues(iSlope) = distanceScore * speedScore * 100;
  
  if(distanceScore < 0.95)
    fitnessValues(iSlope) = fitnessValues(iSlope) * breakPenaltyFactor;
  end
  
end

fitnessValue = worstFitnessFactor * min(fitnessValues) + ...
  meanFitnessFactor * mean(fitnessValues);

end
