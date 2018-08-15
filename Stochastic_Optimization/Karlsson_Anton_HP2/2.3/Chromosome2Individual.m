function individual = Chromosome2Individual(chromosome, nInputNeurons,...
  nHiddenNeurons,nOutputNeurons)

nHiddenWeights = (nInputNeurons+1) * nHiddenNeurons;

hiddenWeightGenes = chromosome(1:nHiddenWeights);
outputWeightGenes = chromosome(nHiddenWeights+1 : end);

hiddenWeights = reshape(hiddenWeightGenes,nInputNeurons+1,nHiddenNeurons);
outputWeights = reshape(outputWeightGenes, nHiddenNeurons+1,nOutputNeurons);

individual = struct('hiddenWeights',  hiddenWeights,...
                    'outputWeights', outputWeights);
end
