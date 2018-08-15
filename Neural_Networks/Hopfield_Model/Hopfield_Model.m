p=[1, 20, 40, 60, 80, 100, 120, 140, 160, 180, 200, 220, 240, 260, 280, 300, 320, 340, 360, 380, 400];
N=200;
pdivN=p./N;
compError=zeros(length(p),1);

simpError=zeros(length(p),1);

for i=1:length(p)
    compError(i)=PError_comp(p(i),N);
    simpError(i)=PError_2(p(i),N);

end

plot(pdivN,compError,'-o',pdivN,simpError)
grid on
xlabel('p/N')
ylabel('P_{Error}')
legend('Computed Error','Theoretical error')

set(gca,'FontSize',20)


