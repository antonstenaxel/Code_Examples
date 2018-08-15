%% Load data

data3 = load('data3.txt');

inputPatterns = data3(:,2:3);
inputClassification = data3(:,1);

%% Main

k = 10; % number of Gaussian neurons
eta = 0.02;

nPatterns = length(data3);
numberOfRuns = 20;
classificationError = zeros(1,20);
bestWeights1 = zeros(2,4);
bestWeights2 = zeros(2,4);
bestThreshold = 0;
minClassificationError = inf;

for iRuns = 1:numberOfRuns
  weights1 = -1 + 2*rand(2,k); % 2x4 weight
  
  numberOfUpdates = 10^5;
  
  for i = 1: numberOfUpdates
    
    gActivation = zeros(k, 1);
    chosenInputIndex = randi(length(inputPatterns));
    
    chosenInputPattern = inputPatterns(chosenInputIndex, :);
    
    for j = 1:k
      numerator = exp( - norm(chosenInputPattern' - weights1(:,j))^2/2);
      gActivation(j) = numerator;
    end
    
    gActivation = gActivation/sum(gActivation);
    
    [maxValue, maxIndex] = max(gActivation);
    
    % Update weights
    
    deltaWeights = eta*(chosenInputPattern' - weights1(:,maxIndex));
    
    weights1(:, maxIndex) = weights1(:, maxIndex) + deltaWeights;
  end
  
  weights2 = -1 + 2*rand(k,1);
  threshold = -1 + 2*rand(1);
  beta = 1/2;
  eta = 0.1;
  numberOfSteps = 3000;
  
  for i = 1:numberOfSteps
    gActivation = zeros(k, 1);
    chosenInputIndex = randi(length(inputPatterns));
    
    chosenClassification = inputClassification(chosenInputIndex);
    chosenInputPattern = inputPatterns(chosenInputIndex, :);
    
    for j = 1:k
      numerator = exp( - norm(chosenInputPattern' - weights1(:,j))^2/2);
      gActivation(j) = numerator;
    end
    
    gActivation = gActivation/sum(gActivation);
    
    localFieldOutput = gActivation' * weights2 - threshold;
    
    g = @(b) tanh(beta*b);
    g_prime = @(b) beta*sech(beta*b)^2;
    
    output = g(localFieldOutput);
    
    deltaError = (chosenClassification-output) * g_prime(localFieldOutput);
    
    deltaThreshold = -eta*deltaError;
    deltaWeights = - deltaThreshold * gActivation;
    
    weights2 = weights2 + deltaWeights;
    threshold = threshold + deltaThreshold;
    
  end
  
  for n = 1 : nPatterns
    classification = RunNetwork(weights1, weights2, threshold, inputPatterns(n,:));
    classificationError(iRuns) = classificationError(iRuns) + ...
      (1/(2*nPatterns)) * abs(inputClassification(n) - sign(classification));
  end
  
  if classificationError(iRuns) < minClassificationError
    minClassificationError = classificationError(iRuns);
    bestWeights1 = weights1;
    bestWeights2 = weights2;
    bestThreshold = threshold;
  end
  
end

min(classificationError)
%%
figure(1)
plot((1:numberOfRuns), classificationError)
%%
clf
interval1 = -15:0.1:25;
interval2 = -10:0.1:15;
[X,Y] = meshgrid(interval1,interval2);
figure(1)
hold on
k=1;
ii = 0;
jj = 0;

for i = interval1
  ii = ii+1;
  for j = interval2
    jj= jj+1;
    classification = RunNetwork(bestWeights1, bestWeights2, bestThreshold, [i, j]);
    c(ii,jj) = classification;
    %if (classification > 0)
     % plot(i,j,'r.')
    %else
     % plot(i,j,'b.')
    %end
  end
   jj=0;
end

%%

clf
hold on
contourf(X,Y,c',100,'LineStyle','none')
colormap(gray)
caxis([-5,5])
color = 0.95;
for i = 1 : 2000
  
  if(inputClassification(i) < 0 )
    plot(inputPatterns(i,1),inputPatterns(i,2),'ko','MarkerEdgeColor',[color color color])
  else
    plot(inputPatterns(i,1),inputPatterns(i,2),'ko','MarkerEdgeColor',[color color color],'MarkerFaceColor',[color color color])
    
  end
  
end



plot(bestWeights1(1,:),bestWeights1(2,:),'kx','MarkerSize',30,'LineWidth',5)

%contour(X,Y,c',[0,0],'k','LineWidth',4)

grid on
hold off

axis equal
axis ([-15,25,-10,15])


%%
figure(2) 
im = image(c','CDataMapping','scaled')
colorbar
im.AlphaData = 0.5;
contour(X,Y,c',[0,0],'k','LineWidth',4)

%%
plot(inputPatterns(:,1),inputPatterns(:,2),'o')
