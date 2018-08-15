function Population = InitializePopulation(populationSize,minChromosomeLength,...
  maxChromosomeLength,operatorInterval,destinationInterval,operandInterval);

Population = [];
for i = 1:populationSize
  chromosomeLength = minChromosomeLength + fix(rand*(maxChromosomeLength-minChromosomeLength+1));
  chromosomeLength = 4*fix(chromosomeLength/4);
  
  tmpChromosome = randi([0,1],chromosomeLength,1);
  
  %Mutating w/ prob. 1 is equal to randomly setting values.
  tmpChromosome = Mutate(tmpChromosome,1,operatorInterval,...
    destinationInterval,operandInterval);
  
  TmpIndividual = struct('Chromosome',tmpChromosome);
  Population = [Population TmpIndividual];
end