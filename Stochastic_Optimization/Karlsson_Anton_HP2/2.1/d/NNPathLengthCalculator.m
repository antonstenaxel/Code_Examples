
cityLocation = LoadCityLocations();
numberOfCities = size(cityLocation,1);
eligableCities = 1:numberOfCities;
path = zeros(1,numberOfCities);
iStartCity = randi(numberOfCities);

path(1) = iStartCity;
eligableCities(iStartCity) = [];

for i = 2:numberOfCities
  iCurrentCity = path(i-1);
  minDist = inf;
  
  for j = 1: size(eligableCities,2)
    iNextCity = eligableCities(j);
    
    city1 = cityLocation(iCurrentCity,:);
    city2 = cityLocation(iNextCity,:);
    distancetoCity =  norm(city2-city1);
    
    if( distancetoCity < minDist)
      minDist = distancetoCity;
      iClosestCity = j;
    end
    
  end
  path(i) = eligableCities(iClosestCity);
  eligableCities(iClosestCity) = [];
end
nearestNeighbourPathLength = GetPathLength(path,cityLocation);

fprintf('Nearest Neighbour path length is %.3f \n',nearestNeighbourPathLength);


