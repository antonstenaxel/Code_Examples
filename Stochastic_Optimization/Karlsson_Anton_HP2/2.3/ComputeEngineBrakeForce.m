function engineBrakeforce = ComputeEngineBrakeForce(gear)
C_b = 3000;
gearForces = C_b * [7,5,4,3,2.5,2,1.6,1.4,1.2 1];
engineBrakeforce = gearForces(gear);
end
