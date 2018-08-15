function mutatedChromosome = Mutate(chromosome, mutationProbability,creepRate)

    nGenes = size(chromosome,2);
    mutatedChromosome = chromosome;
    
    for i = 1:nGenes
        if(rand < mutationProbability)
          geneChange  = creepRate*randn;
          mutatedChromosome(i) = mutatedChromosome(i) + geneChange;
        end
    end
    
end
