function classification = RunNetwork(weights1, weights2, threshold, inputPattern)
    
    k = length(weights1);
    beta = 1/2;
    gActivation = zeros(k, 1);

    for j = 1:k
        numerator = exp( - norm(inputPattern' - weights1(:,j))^2/2);
        gActivation(j) = numerator;
    end

    gActivation = gActivation/sum(gActivation);


    localFieldOutput = gActivation' * weights2 - threshold;

    g = @(b) tanh(beta*b);

    classification = g(localFieldOutput);



end