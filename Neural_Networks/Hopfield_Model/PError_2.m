function error = PError_2(p,N)
alpha=p/N;
error = 0.5*(1-erf((1+alpha)/(sqrt(2*alpha))));
end
