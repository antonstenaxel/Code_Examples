gradientDescentStepLength = 0.0001;
treshold = 1e-6;
penaltyParametersToBeEvaluated = [1;10;100;1000];
numberOfPenaltyParameters = size(penaltyParametersToBeEvaluated,1);
xStart = [1;2];

stationaryPoints = zeros(2,numberOfPenaltyParameters);
for i = 1 : numberOfPenaltyParameters
  stationaryPoints(:,i)=GradientDescent(xStart,...
    penaltyParametersToBeEvaluated(i), gradientDescentStepLength,treshold);
end

x1=round(stationaryPoints(1,:)',3); %Round to three decimal places
x2=round(stationaryPoints(2,:)',3);

stationaryPointsTable = table(penaltyParametersToBeEvaluated,x1,x2);
stationaryPointsTable.Properties.VariableNames = {'mu' 'x1' 'x2'};

disp(stationaryPointsTable);





