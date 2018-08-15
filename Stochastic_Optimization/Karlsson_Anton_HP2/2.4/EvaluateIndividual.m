function fitness = EvaluateIndividual(chromosome,data,allRegisters,penaltyLength)
nDatapoints = size(data,1);

xValues = data(:,1);
yValues = data(:,2);
yHatValues = zeros(nDatapoints,1);

for i=1:nDatapoints
  x= xValues(i);
  allRegisters(1)=x;
  yHatValues(i) = DecodeChromosome(chromosome,allRegisters);
end

squaredDifference = (yHatValues - yValues).^2;
error = sqrt(mean(squaredDifference));

chromosomeLength = size(chromosome,1);
if(chromosomeLength > penaltyLength)
  fitness = 1/error * (penaltyLength/chromosomeLength);
else
  fitness= 1/(error);
  
end
