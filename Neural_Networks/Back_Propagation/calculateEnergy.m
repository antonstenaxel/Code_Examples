function H= calculateEnergy(data,w,W,t,T,g)
H=0;
for i=1:size(data,1)
  
  input = data(i,1:2)';
  correctOutput = data(i,3);
  
  %Feed forward
  hiddenLocalField = w*input-t;
  V = g(hiddenLocalField);
  
  outputLocalField = W*V - T;
  output =g(outputLocalField);
  H=H+0.5*(correctOutput-output)^2;
end
end
