function gradientValue = Gradient(x,penaltyParameter)

g=@(x) x(1)^2+x(2)^2-1; % Constraint function

gradientTerm1 = 2*(x(1)-1);
gradientTerm2 = 4*(x(2)-2);

penaltyTerm1 = 4*penaltyParameter*(x(1)^2+x(2)^2-1)*x(1);
penaltyTerm2 = 4*penaltyParameter*(x(1)^2+x(2)^2-1)*x(2);

if( g(x) <= 0)
  gradientValue=[gradientTerm1; gradientTerm2];
else
  gradientValue = [ gradientTerm1 + penaltyTerm1 ;...
    gradientTerm2 + penaltyTerm2];
end

end
