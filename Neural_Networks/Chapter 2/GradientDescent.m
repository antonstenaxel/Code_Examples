%% Gradient descent

clc

f=@(x) x(1)^4+3*x(1)*x(2)-2*x(1)+2*x(2)^4;
fgrad=@(x) [4*x(1)^3+3*x(2)-2, 3*x(1)+8*x(2)];

noOfIterations=10;
startPoint=[2,2];

x=zeros(noOfIterations,2);
x(1,:)=startPoint;

for i = 2: noOfIterations
    Phi=@(eta) x(i-1,:)-eta*fgrad(x(i-1,:));
   
    eta=lineSearch(Phi,-100,100)
    x(i,:)=Phi(eta);
end




