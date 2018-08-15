function deltaPheromoneLevel = ComputeDeltaPheromoneLevels(pathCollection,...
  pathLengthCollection)

numberOfCities = size(pathCollection,2);
numberOfAnts = size(pathCollection,1);
deltaPheromoneLevel = zeros(numberOfCities);
completePathCollection = horzcat(pathCollection, pathCollection(:,1));

for k = 1 : numberOfAnts
  for i = 1: numberOfCities
    iStartCity = completePathCollection(k,i);
    iNextCity = completePathCollection(k,i+1);
    deltaPheromoneLevel(iStartCity,iNextCity) = ...
      deltaPheromoneLevel(iStartCity,iNextCity) + 1/pathLengthCollection(k);
  end
end

end

