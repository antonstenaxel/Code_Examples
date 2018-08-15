function output = FeedForwardNetwork(input,hiddenWeights,outputWeights)

input = [1 input]; %Include bias term

localField = input*hiddenWeights;
hiddenOutput = SquashingFunction(localField);
hiddenOutput = [1 hiddenOutput];

outputLocalField = hiddenOutput*outputWeights;
output = SquashingFunction(outputLocalField);

end
