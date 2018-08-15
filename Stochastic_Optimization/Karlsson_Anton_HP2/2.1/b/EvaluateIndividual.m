function fitness = EvaluateIndividual(chromosome,cityLocation)

pathLength = GetPathLength(chromosome,cityLocation);
fitness = 1/pathLength;

end
