function value = ObjectiveFunction(x,y)
term1 = (x.^2+y-11).^2;
term2 = (x+y.^2-7).^2;

value = term1 + term2;

end
