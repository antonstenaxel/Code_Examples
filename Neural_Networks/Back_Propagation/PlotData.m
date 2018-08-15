hold on
for j = 1: 200
  if(validationData(j,3) == 1)
    plot(validationData(j,1),validationData(j,2),'ko','MarkerFaceColor','k')
  else
    plot(validationData(j,1),validationData(j,2),'ko')
  end
end
hold off
axis auto
grid on
%%
W=[15.6086   12.2313   12.0646   17.1674];
w =[
  0.5251   -3.7849
  3.7265    0.6613
  0.9245    3.4844
  -3.3983    0.3594]
t= [
  -3.0309
  -2.9766
  -3.0392
  -2.4742
  ]

%%

w=[-3.2696    0.3722
    0.8486    3.3728
    3.8099    0.6492
    0.4543   -3.6663];
t= [ -2.4492
   -2.8704
   -2.9798
   -2.9242];
 
 T=  24.9073;
 W=[16.8388   11.8314   12.0324   15.5149];
%%

%%
hTnorm = smooth(H_train(1,:)/300,10000);
hVnorm = smooth(H_val(1,:)/200,10000);

%%
clf
timeSteps = 1:1e6;
subplot(1,2,1)
plot(timeSteps,hTnorm,'k--',timeSteps,hVnorm,'k-');
legend('Training data','Validation data');
title('Panel A')
xlabel('Timesteps')
ylabel('Normalized energy')
grid on
axis([0 1e6 0 1]);
set(gca,'FontSize',18)

subplot(1,2,2)
hold on
for j = 1: 300
  if(trainingData(j,3) == 1)
    plot(trainingData(j,1),trainingData(j,2),'ko','MarkerFaceColor','k')
  else
    plot(trainingData(j,1),trainingData(j,2),'ko')
  end
end


x=linspace(-3,3);
for i = 1: 4
  y=t(i)/w(i,2)-w(i,1)/w(i,2)*x;
  plot(x,y,'k--')
end

hold off
axis([-2 2 -2 2]);
xlabel('\xi_1');
ylabel('\xi_2');
title('Panel B');

grid on

set(gca,'FontSize',18)

