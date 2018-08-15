function points = generatePoints(nDatapoints) 

points = zeros(2,nDatapoints);
count = 1;
while(count < nDatapoints)  
  
  point = rand(2,1);
  if(point(1) <0.5)
    points(:,count) = point;
    count = count +1;
  elseif(point(2) > 0.5)
    points(:,count) = point;
    count = count +1;
  end
  
end


end
