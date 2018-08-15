function gravityForce = ComputeGravityForce(mass,slopeAngleInDegrees)
g=9.82; 
gravityForce = mass*g*sin(pi/180*slopeAngleInDegrees);
end
