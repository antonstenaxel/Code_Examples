clear all;clf; clc;

cityLocations = LoadCityLocations();
numberOfCities = size(cityLocations,1);

tspFigure = InitializeTspPlot(cityLocations,[0 20 0 20]); 
connection = InitializeConnections(cityLocations); 

populationSize = 100;
population = InitializePopulation(populationSize,numberOfCities);
numberOfGenerations = 1e4;
mutationProbability = 5/numberOfCities;
tournamentSelectionParameter = 0.75;
tournamentSize = 2;
numberOfElitismCopies=1;

fitnessValues = zeros(populationSize,1);
maximumFitness = 0;

for generation = 1:numberOfGenerations
  for i = 1 : populationSize
    fitnessValues(i) = EvaluateIndividual(population(i,:),cityLocations);
    
    if(fitnessValues(i) > maximumFitness)
      maximumFitness = fitnessValues(i);
      iBestIndividual = i;
      bestPath = population(iBestIndividual,:);
      
      fprintf('Minimum Pathlength: %.3f \n', GetPathLength(bestPath,cityLocations));
      PlotPath(connection,cityLocations,bestPath);
      drawnow;
    end
  end
  
  tempPopulation = population;
  
  for i = 1:2:populationSize
    i1= TournamentSelect(fitnessValues, tournamentSelectionParameter,tournamentSize);
    i2= TournamentSelect(fitnessValues, tournamentSelectionParameter,tournamentSize);
    
    chromosome1 = population(i1,:);
    chromosome2 = population(i2,:);
    
    mutatedChromosome1 = Mutate(chromosome1,mutationProbability);
    mutatedChromosome2 = Mutate(chromosome2,mutationProbability);
    
    tempPopulation(i,:) = mutatedChromosome1;
    tempPopulation(i+1,:) = mutatedChromosome2;
    
  end
  
  bestIndividual = population(iBestIndividual,:);
  tempPopulation = InsertBestIndividual(tempPopulation,bestIndividual,...
    numberOfElitismCopies);
  
  population = tempPopulation;
  iBestIndividual = 1;
  
  if(mod(generation,500) == 0 )
   fprintf('Gen: %d \n', generation);
  end
  
end
