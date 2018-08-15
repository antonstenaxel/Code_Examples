function alpha = GetSlopeAngle(x, iSlope, iDataSet)

if (iDataSet == 1)                                  % Training
  
  switch(iSlope)
    case 1
      alpha = 4 + sin(x/100) + cos(sqrt(2)*x/50);
    case 2
      alpha = 5 + sin(sqrt(x))/100 + 2*cos(sqrt(2)*x/50);
    case 3
      alpha = 6 - 4*sin(x/500)^2 - cos(sqrt(2)*x/300);
    case 4
      alpha =  3 -1.5*sin(x/100 - cos(sqrt(2)*x/50));
    case 5
      alpha = 5 + sin(x/20) + cos(sqrt(2)*x/50);
    case 6
      alpha = 6 - sin(x/100) + cos(sqrt(2)*x/50);
    case 7
      alpha = 5 + sin(x/250) + cos(sqrt(5)*x/50);
    case 8
      alpha = 5 - sin(sqrt(10)*x/70) + cos(sqrt(2));
    case 9
      alpha = 4 + sin(sqrt(2)*x/100) + cos(sqrt(2)*x/50);
    case 10
      alpha = 5 + 2*sin(x/50) + cos(sqrt(2))/(x+100);
  end
  
  
elseif (iDataSet == 2)                            % Validation
  switch(iSlope)
    case 1
      alpha = 4 + sin(x/100) *exp( cos(sqrt(2)*x/50)); 
    case 2
      alpha = 3 + (sin(x/300) - cos(sqrt(7)*x/100))*exp(-x/1000);
    case 3
      alpha = 4 - (sin(sqrt(x)/300) - exp(cos(sqrt(7)*x/100)));
    case 4
      alpha = 3 - sin(x/100) - cos(sqrt(7)*x/50);
    case 5
      alpha = 4  + sin(x/70) + cos(sqrt(7)*x/100);
  end
  
  
elseif (iDataSet == 3)                           % Test
  
  switch(iSlope)
    case 1
      alpha = abs(2 - 2*sin(x/100) + cos(sqrt(3)*x/50));
    case 2
      alpha = 4 - sin(x/100) + 2*cos(sqrt(3)*x/200);
    case 3
      alpha = 3 + 2*sin(x/50)^2 + cos(sqrt(3)*x/50);
    case 4
      alpha = 2 + exp(sin(x/50)) + 0.5*cos(sqrt(3)*x/20 );
    case 5
      alpha = 5 + sin(x/50+pi/2) + cos(sqrt(5)*x/50);
  end
  
end
