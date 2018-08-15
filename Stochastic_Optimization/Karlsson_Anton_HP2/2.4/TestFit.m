clc; clear all; clf;
data = LoadFunctionData();
nDatapoints = size(data,1);
xValues = data(:,1);
yValues = data(:,2);
yHatValues = zeros(nDatapoints,1);

for i=1:nDatapoints
  x= xValues(i);
  yHatValues(i) = HardCodedFunction(x);
end

squaredDifference = (yHatValues - yValues).^2;
error = sqrt(mean(squaredDifference));

fprintf('Total error: %.4e \n',error);

figure(2)
plot(xValues,yValues,'ko',xValues,yHatValues,'k','MarkerEdgeColor',[0.5,0.5,0.5]);
grid on
titleText = sprintf('Best function found \n Total error: %.3e',error);
title(titleText)
set(gca,'FontSize',20)
legend('Data points','Fitted function','Location','southeast')
