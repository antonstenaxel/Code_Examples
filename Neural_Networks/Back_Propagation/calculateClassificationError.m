function C = calculateClassificationError(data,w,W,t,T,g)
C=0;
numberOfPatterns = size(data,1);
for i=1:numberOfPatterns
  
  input = data(i,1:2)';
  correctOutput = data(i,3);
  
  %Feed forward
  hiddenLocalField = w*input-t;
  V = g(hiddenLocalField);
  
  outputLocalField = W*V - T;
  output =sign(g(outputLocalField));
  
  C=C+abs(correctOutput-output);
end
C=C/(2*numberOfPatterns);
end
