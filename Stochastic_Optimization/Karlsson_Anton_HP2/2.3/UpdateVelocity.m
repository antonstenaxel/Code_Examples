function updatedVelocity = UpdateVelocity(gravityForce,foundationBrakeForce,...
  engineBrakeForce,mass,currentVelocity,deltaT)
    
    accumulatedForce = (gravityForce - foundationBrakeForce - engineBrakeForce);
    acceleration = accumulatedForce/mass;
    updatedVelocity = currentVelocity + deltaT*acceleration;

end
