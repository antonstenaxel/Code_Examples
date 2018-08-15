function fitness = EvaluateIndividual(x)

subFactor1 = (x(1)+x(2)+1)^2;
subFactor2 = 19-14*x(1)+3*x(1)^2-14*x(2)+6*x(1)*x(2)+3*x(2)^2;
factor1 = 1+subFactor1*subFactor2;

subFactor3 = (2*x(1)-3*x(2))^2;
subFactor4 = 18-32*x(1)+12*x(1)^2+48*x(2)-36*x(1)*x(2)+27*x(2)^2;
factor2 = 30+subFactor3*subFactor4;

objectiveFunctionValue = factor1*factor2;
fitness=1/objectiveFunctionValue;

end
