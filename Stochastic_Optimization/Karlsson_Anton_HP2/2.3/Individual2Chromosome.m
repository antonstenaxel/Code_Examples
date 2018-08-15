function chromosome = Individual2Chromosome(individual)

hiddenFlatten = reshape(individual.hiddenWeights,1,[]);
outputFlatten = reshape(individual.outputWeights,1,[]);

chromosome = horzcat(hiddenFlatten,outputFlatten);
end
