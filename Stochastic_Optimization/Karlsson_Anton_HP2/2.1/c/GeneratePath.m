function path = GeneratePath(pheromoneLevel, visibility, alpha, beta)
numberOfCities = size(visibility,1);
eligibleCities = 1 : numberOfCities;
path = zeros(1,numberOfCities);

selectionMatrix = pheromoneLevel.^alpha.*visibility.^beta;

iCurrentCity = randi(numberOfCities);
path(1) = iCurrentCity;
eligibleCities(iCurrentCity) = [];
numberOfEligibleCitiesLeft = numberOfCities - 1;

iPath = 2;

while(numberOfEligibleCitiesLeft > 1)
  
  iNextEligibleCity = GetNextCity(eligibleCities,iCurrentCity,selectionMatrix);
  
  path(iPath) = eligibleCities(iNextEligibleCity);
  iCurrentCity = eligibleCities(iNextEligibleCity);
  eligibleCities(iNextEligibleCity) = [];
  
  numberOfEligibleCitiesLeft = numberOfEligibleCitiesLeft - 1 ;
  iPath = iPath + 1;
  
end

path(numberOfCities) = eligibleCities(1);

end

