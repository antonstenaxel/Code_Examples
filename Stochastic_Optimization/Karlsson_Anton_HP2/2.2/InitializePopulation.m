function population = InitializePopulation(populationSize,initialRange,deltaT,alpha)

population = [];
intervalLength = initialRange(2) -initialRange(1);
for i = 1 : populationSize
  
  position = initialRange(1) + rand(1,2)*intervalLength ;
  velocity = -0.5*intervalLength + rand(1,2)*intervalLength;
  velocity = alpha/deltaT*velocity;
  x=position(1);
  y=position(2);
  functionValue = ObjectiveFunction(x,y);
  
  Particle = struct('position',position,...
                    'velocity',velocity,...
                    'bestPosition', position,...
                    'particleMinimum', functionValue);
                  
  population = [population Particle];
end

end


