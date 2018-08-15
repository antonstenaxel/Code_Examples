clear all; clf; clc;

populationSize = 100;
crossoverProbability = 0.8;
mutationParameter = 5; %Pmut = mutationParameter/chromosomeLength
tournamentSelectionParameter = 0.75;
tournamentSize = 2;
nElitismCopies = 2;
penaltyLength = 400; %At what length the chromosomes are penalized by length
nGenerations = 1e5;
constants = [-1 1 2 3];
errorTreshold = 0.01;

minInitialChromosomeLength = 200;
maxInitialChromosomeLength = 400;

nOperators = 4;
nRegisters = 4;
nConstants = size(constants,2);

allRegisters = zeros(1,nRegisters+nConstants);
allRegisters(nRegisters+1:end)=constants;

operatorInterval = [1,nOperators];
destinationInterval = [1,nRegisters];
operandInterval = [1,nRegisters+nConstants];

Population = InitializePopulation(populationSize,minInitialChromosomeLength,...
  maxInitialChromosomeLength,operatorInterval,destinationInterval,operandInterval);

fitnessValues = zeros(populationSize,1);
maximumFitness = 0;
generation = 0;
data = LoadFunctionData;
fitnessTreshold = 1/errorTreshold;

while(maximumFitness < fitnessTreshold)
  generation = generation + 1; 
  
  for i= 1 : populationSize %Evaluate
    chromosome = Population(i).Chromosome;
    fitnessValues(i)=EvaluateIndividual(chromosome,data,allRegisters,penaltyLength);
    if(fitnessValues(i)>maximumFitness)
      maximumFitness = fitnessValues(i);
      iBestIndividual = i;
    end
  end
  
  TempPopulation = Population;
  
  for i = 1:2:populationSize %Select
    i1= TournamentSelect(fitnessValues, tournamentSelectionParameter,tournamentSize);
    i2= TournamentSelect(fitnessValues, tournamentSelectionParameter,tournamentSize);
    chromosome1 = Population(i1).Chromosome;
    chromosome2 = Population(i2).Chromosome;
    
    if(rand < crossoverProbability) %Crossover
      NewChromosomePair = Cross(chromosome1,chromosome2);
      TempPopulation(i).Chromosome = NewChromosomePair(1).Chromosome;
      TempPopulation(i+1).Chromosome = NewChromosomePair(2).Chromosome;
    else
      TempPopulation(i).Chromosome = chromosome1;
      TempPopulation(i+1).Chromosome = chromosome2;
    end
  end
  
  for i=1:populationSize %Mutation
    originalChromosome = TempPopulation(i).Chromosome;
    originalChromosomeLength = size(originalChromosome,1);
    mutationProbability = mutationParameter/originalChromosomeLength;
    
    mutatedChromosome = Mutate(originalChromosome, mutationProbability,...
      operatorInterval,destinationInterval,operandInterval);
    TempPopulation(i).Chromosome = mutatedChromosome;
  end
  
  BestIndividual = Population(iBestIndividual);
  TempPopulation = InsertBestIndividual(TempPopulation,BestIndividual,nElitismCopies);
  Population = TempPopulation;
  iBestIndividual = 1;
  
  if(mod(generation,50)==0)
    figure(1);
    PlotIndividual(Population(iBestIndividual),data,allRegisters);
    titleStr = sprintf('Best fit in generation %d \n Total Error : %.3e',generation,1/maximumFitness);
    title(titleStr);
    drawnow;
  end
  
end

fprintf('Fitting complete\nTotal error: %.3e\nBest function found :\n',1/maximumFitness)
PrintFunction(BestIndividual.Chromosome,allRegisters);