function x = DecodeChromosome(chromosome,numberOfVariables, variableRange)

nGenes = size(chromosome,2);
nGenesPerVariable = nGenes/numberOfVariables;

x = zeros(numberOfVariables,1);
iGene = 1;
for iVariable = 1:numberOfVariables
  for i = 1 : nGenesPerVariable
    x(iVariable) = x(iVariable) + chromosome(iGene)*2^(-i);
    iGene = iGene+1;
  end
  x(iVariable) = -variableRange + ...
    2*variableRange/(1-2^(-nGenesPerVariable))*x(iVariable);
end


end
