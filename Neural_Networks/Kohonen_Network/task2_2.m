

clf 

numberOfDataPoints = 401;
eta = 1e-3;
numberOfUpdates = 2e4;


w1 = -1 + 2*rand(1,2);
modWeight1 = zeros(1,numberOfUpdates);
for i = 1:numberOfUpdates
  modWeight1(i) = norm(w1);
  input = data(randi(numberOfDataPoints),:)';
  output = w1 * input;
  deltaW = eta*output*(input'-output*w1);
  w1 = w1 + deltaW;
end

subplot(2,2,1)
semilogx(1:numberOfUpdates,modWeight1,'k')
axis([1,numberOfUpdates,min(modWeight1)*0.8,max(modWeight1)*1.2])
grid on
subplot(2,2,2)
hold on
for i = 1 : 401
  plot(data(i,1),data(i,2),'ko')
end
axis([10.7487-2 10.7487+2 1.7495-2 1.7495+2])
x = linspace(8,13);
y = w1(2)/w1(1).*x;
plot(x,y,'k')
grid on

hold off


centeredData = data - repmat([mean(data(:, 1)), mean(data(:, 2))], length(data), 1);
weights2 = -1 + 2*rand(1,2);
modWeight2 = zeros(1,numberOfUpdates);
for i = 1:numberOfUpdates
  modWeight2(i) = norm(weights2);
  input = centeredData(randi(numberOfDataPoints),:)';
  output = weights2 * input;
  deltaW = eta*output*(input'-output*weights2);
  weights2 = weights2 + deltaW;
  
end

subplot(2,2,3)
semilogx(1:numberOfUpdates,modWeight2,'k')
axis([1,numberOfUpdates,min(modWeight2)*0.8,max(modWeight2)*1.2])

grid on

subplot(2,2,4)
hold on
for i = 1 : 401
  plot(centeredData(i,1),centeredData(i,2),'ko')
end
axis([-2,2,-2,2]);
x = linspace(-2,2);
y = weights2(2)/weights2(1).*x ;
plot(x,y,'k')
grid on
hold off

