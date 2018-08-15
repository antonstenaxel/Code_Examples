function iSelected = TournamentSelect(fitnessValues, pTournament, tournamentSize)

fitnessValues = fitnessValues';
populationSize = size(fitnessValues,2);
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
