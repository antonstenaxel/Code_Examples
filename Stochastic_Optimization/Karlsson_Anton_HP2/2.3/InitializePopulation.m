function Population = InitializePopulation(populationSize,initialRange,...
  nHiddenNeurons,nInputNeurons,nOutputNeurons)

Population = [];
for i = 1 : populationSize
  
  hiddenWeights = rand(nInputNeurons+1,nHiddenNeurons ); %Including bias weights
  hiddenWeights = initialRange(1) + (initialRange(2)-initialRange(1))*hiddenWeights;
  
  outputWeights = rand(nHiddenNeurons +1 ,nOutputNeurons); %Including bias weights
  outputWeights = initialRange(1) + (initialRange(2)-initialRange(1))*outputWeights;
  
  Individual = struct('hiddenWeights',hiddenWeights,...
    'outputWeights',outputWeights);
  Population = [Population Individual];
end


end
