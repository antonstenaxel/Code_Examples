function population = InitializePopulation(populationSize,numberOfCities)
population = zeros(populationSize, numberOfCities);

for i = 1:populationSize
  population(i,:) = randperm(numberOfCities);
end
