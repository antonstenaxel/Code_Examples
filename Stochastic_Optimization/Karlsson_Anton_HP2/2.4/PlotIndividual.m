function PlotIndividual(Individual,data,allRegisters,curvePlot)

chromosome = Individual.Chromosome;
nDatapoints = size(data,1);

xValues = data(:,1);
yValues = data(:,2);
yHatValues = zeros(nDatapoints,1);

for i=1:nDatapoints
  x= xValues(i);
  allRegisters(1)=x;
  yHatValues(i) = DecodeChromosome(chromosome,allRegisters);
  
end

plot(xValues,yValues,'ko',xValues,yHatValues,'k','MarkerEdgeColor',[0.5,0.5,0.5]);
grid on
legend('Data','Fitted function','Location','southeast');
axis([-5,5,-1.5,1.5])
set(gca,'FontSize',20);

end
