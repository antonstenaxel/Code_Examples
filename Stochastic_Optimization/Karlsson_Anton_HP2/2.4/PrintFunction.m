function PrintFunction(chromosome,allRegisters)

allRegisters = sym(allRegisters);
syms x;

allRegisters(1) = x;
func = DecodeChromosome(chromosome,allRegisters);
str = simplifyFraction(func,'Expand',true);
disp(str);

end
