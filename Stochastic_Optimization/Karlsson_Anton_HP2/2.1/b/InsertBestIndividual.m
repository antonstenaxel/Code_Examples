function modifiedPopulation = InsertBestIndividual(population,bestIndividual,numberOfCopiesToBeInserted)

modifiedPopulation = population;

for i = 1:numberOfCopiesToBeInserted
  modifiedPopulation(i,:) = bestIndividual;
end

end
