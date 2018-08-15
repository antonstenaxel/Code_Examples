function population = InitializePopulation(populationSize, numberOfGenes)
population = zeros(populationSize, numberOfGenes);

for iIndividual = 1:populationSize
  for iGene=1:numberOfGenes
    r=rand;
    if(r<0.5)
      population(iIndividual,iGene)=0;
    else
      population(iIndividual,iGene)=1;
    end
  end
end

end
