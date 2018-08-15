% Load data
clear all;
load('training_set.mat');
load('validation_set.mat');

trainingData(:,1:2) = (trainingData(:,1:2)-mean(trainingData(:,1:2)))./std(trainingData(:,1:2));
validationData(:,1:2) = (validationData(:,1:2)-mean(validationData(:,1:2)))./std(validationData(:,1:2));

%% Train Network

numberOfRuns = 1e6;
numberOfExperiments = 10;

visualize = false;
nInputs = 2;
nHidden = 4;
nOutputs = 1;
learningRate = 0.02;
beta = 0.5;

initWeightRange = 0.2;
initTreshRange = 1;
g=@(x) tanh(beta*x);
gPrim=@(x) beta*(1-tanh(beta*x).^2);
%%
numberOfTrainingPoints = size(trainingData,1);
numberOfValidationPoints = size(validationData,1);
timeSteps = 1:numberOfRuns;
trainingClassificationError = zeros(1,numberOfExperiments);
validationClassificationError = zeros(1,numberOfExperiments);

for experiment = 1:numberOfExperiments
  w = initWeightRange-2*initWeightRange*rand(nHidden,nInputs);
  W = initWeightRange-2*initWeightRange*rand(nOutputs,nHidden);
  t = initTreshRange-2*initTreshRange*rand(nHidden,1);
  T = initTreshRange-2*initTreshRange*rand(nOutputs,1);
  
  % Plot
  if(visualize)
    hold on
    H_train=zeros(numberOfExperiments,numberOfRuns);
    H_val = zeros(numberOfExperiments,numberOfRuns);
    trainErrorPlot = plot(timeSteps,H_train);
    valErrorPlot = plot(timeSteps,H_val);
    axis([0,numberOfRuns,0,1]);
    ylabel('H');
    xlabel('TimeStep');
    legend('Training Energy','Validation Energy');
    hold off
  end
  
  for timeStep  = timeSteps
    r= randi(numberOfTrainingPoints);
    input = trainingData(r,1:2)';
    correctOutput = trainingData(r,3);
    
    %Feed forward
    hiddenLocalField = w*input-t;
    V = g(hiddenLocalField);
    
    outputLocalField = W*V - T;
    output =g(outputLocalField);
    
    %Backpropagation
    deltaOutput = (correctOutput - output).*gPrim(outputLocalField);
    delta_T = -learningRate*deltaOutput;
    delta_W = -delta_T.*V';
    
    deltaHidden = deltaOutput*gPrim(hiddenLocalField);
    delta_t =-learningRate*deltaHidden;
    delta_w = -delta_t*input';
    
    W = W + delta_W;
    w = w + delta_w;
    t = t+ delta_t;
    T = T+delta_T;
    
    H_train(experiment,timeStep) = calculateEnergy(trainingData,w,W,t,T,g);
    H_val(experiment,timeStep) = calculateEnergy(validationData,w,W,t,T,g);
    
    if(visualize)
      trainErrorPlot.set('YData',H_train/300);
      valErrorPlot.set('YData',H_val/200);
      drawnow;
    end
  end
  trainingClassificationError(experiment) = calculateClassificationError(trainingData,w,W,t,T,g);
  validationClassificationError(experiment) = calculateClassificationError(validationData,w,W,t,T,g);
end

save('W.mat','W');
save('w.mat','w');
save('t.mat','t');
save('T.mat','T');
save('H_train.mat','H_train');
save('H_val.mat', 'H_val');
save('trainingClassificationError.mat','trainingClassificationError');
save('validationClassificationError.mat','validationClassificationError');


%%
clf
hold on
k=10;
plot(timeSteps,H_train(k,:)/300,timeSteps,H_val(k,:)/200);
legend('Training set', 'Validation set');
hold off
%%
input = [1.144;1.482];

hiddenLocalField = w*input-t;
V = g(hiddenLocalField);

outputLocalField = W*V - T;
output = sign(g(outputLocalField));

fprintf('(%2.2f,%2.2f) -> %d \n',input(1),input(2),output)