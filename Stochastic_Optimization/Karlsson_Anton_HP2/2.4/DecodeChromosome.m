function value = DecodeChromosome(chromosome,allRegisters)

cMax = 1e15;
nGenes = size(chromosome,1);

for i = 1 : 4 : nGenes
  iOperator = chromosome(i);
  iDestination = chromosome(i+1);
  iOperand1 = chromosome(i+2);
  iOperand2 = chromosome(i+3);
  
  operand1 = allRegisters(iOperand1);
  operand2 = allRegisters(iOperand2);
  
  switch iOperator
    case 1
      allRegisters(iDestination) = operand1 + operand2;
    case 2
      allRegisters(iDestination) = operand1 - operand2;
    case 3
      allRegisters(iDestination) = operand1 * operand2;
    case 4
      if(operand2 == 0)
        allRegisters(iDestination) = cMax;
      else
        allRegisters(iDestination) = operand1 / operand2;
      end
  end
end

value = allRegisters(1);

end
