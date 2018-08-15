function error = PError_comp(p,N)

numberOfBitsToBeEvaluated = 1e5;
numberOfFails = 0;
numberOfBitsEvaluated = 0;

while(true)
    
    patterns=2*round(rand(N,p))-1; % Create random patterns
    weights=1/N*(patterns*patterns');% Hebbs rule
    
    for i=1:p
        updatedStates = weights*patterns(:,i); % Update network once
        updatedStates = -1+2*(updatedStates>=0);
        fails = sum(patterns(:,i) ~= updatedStates); % How many bits failed?
        numberOfFails = numberOfFails+fails;
        
        numberOfBitsEvaluated = numberOfBitsEvaluated+N;
        
        if(numberOfBitsEvaluated >= numberOfBitsToBeEvaluated)
            error = numberOfFails/numberOfBitsEvaluated;
            return
        end
        
    end
    
end



