function visibility = GetVisibility(cityLocation)

numberOfCities = size(cityLocation,1);
cityDistances = zeros(numberOfCities);

for row = 1 : numberOfCities
  for col =  row : numberOfCities
    
    city1 = cityLocation(row,:);
    city2 = cityLocation(col,:);
    
    distance = norm(city1 - city2);
    
    cityDistances(row,col) = distance;
    cityDistances(col,row) = distance;
  end
end

tempMatrix = cityDistances + diag(ones(1,numberOfCities));
visibility = 1./tempMatrix;

end 