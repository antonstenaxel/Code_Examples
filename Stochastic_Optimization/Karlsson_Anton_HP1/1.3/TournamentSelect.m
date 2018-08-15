function iSelected = TournamentSelect(fitnessValues, pTournament, tournamentSize)

populationSize = size(fitnessValues,1);
iSelectedIndividuals = randi(populationSize,tournamentSize,1);

for i=1:tournamentSize
  
  selectedFitnessValues = fitnessValues (iSelectedIndividuals);
  [~, iFittestContestant] = max(selectedFitnessValues);
  %iFittestContestant is index of selectedFitnessValues, not population
  
  r=rand;
  numberOfContestantsLeft=size(iSelectedIndividuals,1);
  
  if(r<pTournament || numberOfContestantsLeft == 1)
    iSelected = iSelectedIndividuals(iFittestContestant);
    return;
  else
    iSelectedIndividuals(iFittestContestant) = [];
  end
  
end
end
