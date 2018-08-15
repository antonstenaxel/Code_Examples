function mutatedChromosome = Mutate(chromosome, mutationProbability,...
  operatorInterval,destinationRegisterInterval,operandInterval)

nGenes = size(chromosome,1);
mutatedChromosome = chromosome;

for iGene=1:4:nGenes
  

  if(rand<mutationProbability)
    mutatedChromosome(iGene) = randi(operatorInterval);
  end
  
  if(rand<mutationProbability)
    mutatedChromosome(iGene+1) = randi(destinationRegisterInterval);
  end
  
  if(rand<mutationProbability)
    mutatedChromosome(iGene+2) = randi(operandInterval);
  end
  
  if(rand<mutationProbability)  
    mutatedChromosome(iGene+3) = randi(operandInterval);
  end
  
end

end
