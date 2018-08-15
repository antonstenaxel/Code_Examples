function StochasticHopfieldModel(N,p)

numberOfPatterns=p;
noiseParameter = 2;

numberOfUpdates = 1e6;
numberOfCurves = 20;
batchSize = numberOfUpdates/1e3;
mvaSize = 100;
numberOfRuns = numberOfUpdates / batchSize;

timeSteps = 1:numberOfRuns;

set(gca,'FontSize',18);
fig = figure(1);

axis([0 numberOfRuns,-0.1,1.1]);

xlabel(sprintf('Number of batches á %d timesteps',batchSize));
ylabel(sprintf('mva(%d) of m_1',mvaSize));
title(sprintf('%d runs with p=%d and N=%d',numberOfCurves,numberOfPatterns,N))
yticks(0:0.2:1.1);
grid on;

orderParameters = zeros(numberOfCurves,numberOfRuns);
mva = zeros(numberOfCurves,numberOfRuns);
hold on
for indexOfCurve = 1:numberOfCurves
  
  pl = plot(timeSteps,mva(indexOfCurve,:)); 
  
  patterns=2*round(rand(N,numberOfPatterns))-1; % Create random patterns
  weights=1/N*((patterns*patterns')-numberOfPatterns*eye(N));% Hebbs rule
  updatedStates = patterns(:,1); % Pattern to be fed to network
  
  for timeStep=timeSteps
    
    batch = zeros(1,batchSize);
    
    for j = 1 : batchSize
      % Pick random bit
      r = randi(N);
      % Compute local field
      localField = weights(r,:)*updatedStates;
      % Compute g(b)
      g=1/(1+exp(-2*localField*noiseParameter));
      % Update with prob g(b)
      updatedStates(r)= 2*floor((rand < g))-1;
      % Compute order parameter
      batch(j) =  1/N*sum(updatedStates .* patterns(:,1));
    end
    
    orderParameters(indexOfCurve,timeStep) = mean(batch);
    
    if(timeStep > mvaSize)
      mva(indexOfCurve,timeStep) = mean(orderParameters(indexOfCurve,timeStep-mvaSize:timeStep));
    else
      mva(indexOfCurve,timeStep) = mean(orderParameters(indexOfCurve,1:timeStep));
    end
    
    % Plot
      set(pl,'YData',mva(indexOfCurve,:));
  drawnow;
  end
  
  set(pl,'YData',mva(indexOfCurve,:));
  drawnow;

end


hold off

end





