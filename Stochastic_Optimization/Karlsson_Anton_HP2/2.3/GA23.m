clear all; clc; clf;

populationSize = 30;
numberOfInputNeurons = 3;
numberOfHiddenNeurons = 10;
numberOfOutputNeurons = 2;
initialRange = [-10,10];
tournamentParameter=0.75;
tournamentSize=5;
crossoverProbability = 0.8;
numberOfGenes = (numberOfInputNeurons+1)*numberOfHiddenNeurons +...
  (numberOfHiddenNeurons+1)*numberOfOutputNeurons;
maxMutationRate = 20/numberOfGenes;
minMutationRate = 1/numberOfGenes;
mutationProbabilityDecay = 0.98;
mutationProbability = maxMutationRate;
creepRate = 1;
numberOfGenerations = 50;

Population = InitializePopulation(populationSize,initialRange,...
  numberOfHiddenNeurons,numberOfInputNeurons,numberOfOutputNeurons);

maximumTrainingFitness = -1;
maximumValidationFitness = -1;

trainingFitness = zeros(1,numberOfGenerations);
validationFitness = zeros(1,numberOfGenerations);
generationFitnessValues = zeros(populationSize,1);

sb1 = subplot(2,1,1);
trainingFitnessPlot = plot(1:numberOfGenerations,trainingFitness,'k');
axis([1,numberOfGenerations,0,100]);
grid on
title('Training set fitness');
sb2 = subplot(2,1,2);
validationFitnessPlot = plot(1:numberOfGenerations,validationFitness,'k');
axis([1,numberOfGenerations,0,100]);
grid on
title('Validation set fitness');

for generation = 1 : numberOfGenerations
  
  iDataset = 1;
  for i=1:populationSize
    Individual = Population(i);
    generationFitnessValues(i) = EvaluateIndividual(Individual,iDataset);
    
    if(generationFitnessValues(i) > maximumTrainingFitness)
      maximumTrainingFitness = generationFitnessValues(i);
      BestIndividual = Individual;
      fprintf('New optimum found in generation %d: \n  -Best training fitness: %.2f \n  -Best validation fitness: %.2f\n',...
        generation, maximumTrainingFitness,maximumValidationFitness);
    end
    
  end
  trainingFitness(generation)=maximumTrainingFitness;
  
  iDataset = 2;
  validationFitness(generation) = EvaluateIndividual(BestIndividual,iDataset);
  if(validationFitness(generation) > maximumValidationFitness)
    BestValidationIndividual = BestIndividual;
    maximumValidationFitness = validationFitness(generation);
  end
  
  TempPopulation = Population;
  mutationProbability = mutationProbability * mutationProbabilityDecay;
  if(mutationProbability < minMutationRate)
    mutationProbability = minMutationRate;
  end
  
  for i = 1 : 2: populationSize
    i1 = TournamentSelect(generationFitnessValues,tournamentParameter,tournamentSize);
    i2 = TournamentSelect(generationFitnessValues,tournamentParameter,tournamentSize);
    
    chromosome1 = Individual2Chromosome(Population(i1));
    chromosome2 = Individual2Chromosome(Population(i2));
    
    if( rand < crossoverProbability )
      newChromosomePair = Cross(chromosome1,chromosome2);
      newChromosome1 = newChromosomePair(1,:);
      newChromosome2 = newChromosomePair(2,:);
    else
      newChromosome1 = chromosome1;
      newChromosome2 = chromosome2;
    end
    
    mutatedChromosome1 = Mutate(newChromosome1,mutationProbability,creepRate);
    mutatedChromosome2 = Mutate(newChromosome2,mutationProbability,creepRate);
    
    NewIndividual1 = Chromosome2Individual(mutatedChromosome1,...
      numberOfInputNeurons,numberOfHiddenNeurons,numberOfOutputNeurons);
    NewIndividual2 = Chromosome2Individual(mutatedChromosome2,...
      numberOfInputNeurons,numberOfHiddenNeurons,numberOfOutputNeurons);
    
    TempPopulation(i) = NewIndividual1;
    TempPopulation(i+1) = NewIndividual2;
  end
  TempPopulation(1) = BestIndividual;
  Population = TempPopulation;
  
  if(mod(generation,2) == 0)
    trainingFitnessPlot.set('YData',trainingFitness);
    validationFitnessPlot.set('YData',validationFitness);
    drawnow;
  end
    
end

iDataset = 1;
trainingFitness =  EvaluateIndividual(BestValidationIndividual,iDataset);

iDataset = 3;
testFitness =  EvaluateIndividual(BestValidationIndividual,iDataset);

fprintf('\nTraining complete, for individual with best validation fitness: \n  -Training set fitness: %.2f \n  -Validation set fitenss: %.2f \n  -Test set fitness: %.2f\n',trainingFitness,validationFitness(generation-1),testFitness);
