function iNextEligibleCity = GetNextCity(eligibleCities,iCurrentCity,selectionMatrix)
numberOfEligibleCities = size(eligibleCities,2);

selectionArray = selectionMatrix(eligibleCities,iCurrentCity);
normalizingTerm = sum(selectionArray);
probabilityArray = selectionArray / normalizingTerm;


r = rand;
accumulatedProbability = 0;
for i = 1 : numberOfEligibleCities
  accumulatedProbability = accumulatedProbability + probabilityArray(i);
  if(r <= accumulatedProbability)
    iNextEligibleCity = i;
    return;
  end
end

end
