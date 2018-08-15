clear all ;
clf;
nDatapoints = 1000;
nOutputs = 100;
nInputs = 2;
sigma_0 = 100;
eta_0 = 0.1;
tau_sigma = 300;

dataPoints = generatePoints(nDatapoints);
weights = -1 + 2*rand(nOutputs,nInputs);

%Feed forward

nOrderingPhaseUpdates = 1e3;
nConvergingPhaseUpdates = 2e4;
    
   
for iteration =  1: nOrderingPhaseUpdates + nConvergingPhaseUpdates
  if(mod(iteration,500)==0)
    fprintf('Gen: %d \n',iteration);
  end
  iDatapoint = randi(nDatapoints);
  input = dataPoints(:,iDatapoint);
  output = weights*input;
  
  %Winning neuron
  
  difference = zeros(nOutputs,2);
  distance = zeros(nOutputs,1);
  
  for i = 1 : nOutputs
    difference(i,:) = input' - weights(i,:);
    distance(i) = norm(difference(i,:));
  end
  
  [~,i0] =  min(distance);
  
  if(iteration<nOrderingPhaseUpdates)
    eta = eta_0 * exp(-iteration/tau_sigma);
    sigma = sigma_0 * exp(-iteration/tau_sigma);
  else
    eta = 0.01;
    sigma = 0.9;
  end
  
  
  for i = 1 : nOutputs
    lambda = exp(-(i-i0)^2/(2*sigma^2));
    deltaW = eta * lambda*(difference(i,:));
    weights(i,:)  = weights(i,:) + deltaW;
  end
  
  
  if(iteration == nOrderingPhaseUpdates )
    subplot(1,3,1)
    hold on
    for i = 1 : nOutputs
      plot(weights(i,1),weights(i,2),'ko')
      title('Weights after ordering phase');
    end
    hold off
  end
  
end

subplot(1,3,2)
hold on
for i = 1 : nOutputs
  plot(weights(i,1),weights(i,2),'ko')
   title('Weights after convergence phase');
end
hold off

subplot(1,3,3)

hold on
for i = 1 : nDatapoints
  plot(dataPoints(1,i),dataPoints(2,i),'ko')
   title('Original distribution');
end
hold off

