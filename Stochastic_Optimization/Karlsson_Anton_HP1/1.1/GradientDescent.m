function stationaryPoint = GradientDescent(xStart,penaltyParameter, stepLength,treshold)

maxNumberOfIterations = 1e5;
iterationCount = 0;
x= xStart;
gradientModulusExceedsTreshold = true;

while(gradientModulusExceedsTreshold)
  gradientValue = Gradient(x,penaltyParameter);
  gradientModulus = norm(gradientValue);
  
  if(gradientModulus < treshold)
    gradientModulusExceedsTreshold= false;
  elseif(iterationCount > maxNumberOfIterations )
    disp("Max number of iterations reached, gradient descent terminated");
    fprintf('Last value of gradient modulus: %.3f \n',gradientModulus);
    fprintf('Last value of x is (x_1,x_2)=(%.3f,%.3f) \n',x(1),x(2));
    stationaryPoint = [NaN; NaN];
    return
  else
    x=x-stepLength*gradientValue;
  end
  iterationCount = iterationCount+1;
end

stationaryPoint = x;
end
