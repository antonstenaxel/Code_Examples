function pathLength = GetPathLength(path,cityLocation)

numberOfCities = size(cityLocation,1);
completePath = horzcat(path,path(1));

pathLength = 0;
for i= 1: numberOfCities
  
  iCurrentCity = completePath(i);
  iNextCity = completePath( i+1);
  
  currentCityLocation = cityLocation(iCurrentCity,:);
  nextCityLocation = cityLocation(iNextCity,:);
  
  distance = norm(nextCityLocation-currentCityLocation);
  pathLength = pathLength + distance;
  
end

end
