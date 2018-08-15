function VisualizeOutput(minimumPositions)



%Code below used to format output
[~,uniqueIndices] = unique(minimumPositions(:,1));
nMinimaFound = size(uniqueIndices,1);
xPositions = minimumPositions(uniqueIndices,1);
yPositions = minimumPositions(uniqueIndices,2);

hold on
x=linspace(-5,5);
y=linspace(-5,5);

[X, Y] = meshgrid(x,y);
Z=log(0.01+ObjectiveFunction(X,Y));
figure(1)

contour(X,Y,Z,10);
title('Found minima');
set(gca,'FontSize',20);
axis([-5,5,-5,5]);
axis equal;
xlabel('x');
ylabel('y');
xticks(-5:2:5);
yticks(-5:2:5);
grid on
drawnow;
for run= 1: nMinimaFound
  plot(xPositions(run) ,yPositions(run) ,'kx','MarkerSize',30);
end
hold off

fprintf('\n%d Minima found! \n',nMinimaFound)
for i = 1:nMinimaFound
  x = xPositions(i);
  y = yPositions(i);
  value = ObjectiveFunction(x,y);
fprintf('Minmum value of %.6f found at (%.6f,%.6f)^T\n',value,x,y)  
end


end
