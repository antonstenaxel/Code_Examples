clf
clear all;
clc

populationSize = 40;
initialRange = [-5,5];

deltaT = 1;
alpha = 1;
maxSpeed = 0.1;
inertiaMax = 1.6;
inertiaMin = 0.4;
inertiaDecayFactor = 0.99;

socialFactor = 2;
cognitiveFactor = 2;

nRuns = 20;
nIterations = 5e2;

minimumPositions = zeros(nRuns,2);

for run = 1:nRuns
  inertiaWeight = inertiaMax;
  
  population = InitializePopulation(populationSize,initialRange,deltaT,alpha);
  swarmMinimum = inf;
  swarmBestPosition = [];
 
  for iteration = 1: nIterations
    
    for k=1:populationSize
      Particle = population(k);
      x=Particle.position(1);
      y=Particle.position(2);
      particleFunctionValue = ObjectiveFunction(x,y);
      
      if(particleFunctionValue < swarmMinimum)
        swarmMinimum=particleFunctionValue;
        swarmBestPosition = Particle.position;
      end
      
      if( particleFunctionValue < Particle.particleMinimum)
        Particle.particleMinimum = particleFunctionValue;
        Particle.bestPosition = Particle.position;
      end
      population(k) = Particle;
    end
    
    for iParticle = 1:populationSize
      Particle = population(iParticle);
      
      term1 = rand*(Particle.bestPosition - Particle.position);
      term2 = rand*(swarmBestPosition - Particle.position);
      
      updatedVelocity = inertiaWeight * Particle.velocity +...
        cognitiveFactor/deltaT*term1+...
        socialFactor/deltaT*term2;
      
      speed = norm(updatedVelocity);
      
      if( speed > maxSpeed)
        updatedVelocity = updatedVelocity* maxSpeed/speed ;
      end
      
      Particle.velocity = updatedVelocity;
      Particle.position = Particle.position + Particle.velocity;
      
      population(iParticle) = Particle;
    end
    
    if(inertiaWeight >= inertiaMin)
      inertiaWeight = inertiaWeight*inertiaDecayFactor;
    end
    
  end
    fprintf('%d/%d runs complete\n',run,nRuns);
    minimumPositions(run,:) = swarmBestPosition;
end

VisualizeOutput(minimumPositions);
