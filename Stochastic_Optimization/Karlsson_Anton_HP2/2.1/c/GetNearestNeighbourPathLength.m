function nearestNeighbourPathLength = GetNearestNeighbourPathLength(cityLocations)

numberOfCities = size(cityLocations,1);
eligibleCities = 1:numberOfCities;
nearestNeighbourPath = zeros(1,numberOfCities);
iStartCity = randi(numberOfCities);

nearestNeighbourPath(1) = iStartCity;
eligibleCities(iStartCity) = [];

for i = 2:numberOfCities
  iCurrentCity = nearestNeighbourPath(i-1);
  minDist = inf;
  numberOfEligibleCities = size(eligibleCities,2);
  
  for j = 1: numberOfEligibleCities
    iNextCity = eligibleCities(j);
    
    city1 = cityLocations(iCurrentCity,:);
    city2 = cityLocations(iNextCity,:);
    distance =  norm(city2-city1);
    
    if( distance < minDist)
      minDist = distance;
      iClosestCity = j;
    end
    
  end
  
  nearestNeighbourPath(i) = eligibleCities(iClosestCity);
  eligibleCities(iClosestCity) = [];
end

nearestNeighbourPathLength = GetPathLength(nearestNeighbourPath,cityLocations);
end
