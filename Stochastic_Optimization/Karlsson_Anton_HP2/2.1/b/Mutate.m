function mutatedChromosome = Mutate(chromosome, mutationProbability)

numberOfGenes = size(chromosome,2);
mutatedChromosome = chromosome;

for iGene=1:numberOfGenes
  if(rand < mutationProbability)
    iSwapGene = randi(numberOfGenes);
    mutatedChromosome([iGene iSwapGene]) = mutatedChromosome([iSwapGene iGene]);
  end
end

end
