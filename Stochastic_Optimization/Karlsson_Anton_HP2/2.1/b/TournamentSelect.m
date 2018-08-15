function iSelected = TournamentSelect(fitnessValues, pTournament, tournamentSize)

populationSize = size(fitnessValues,1);

iSelectedIndividuals = randi(populationSize,tournamentSize,1);
selectedFitnessValues = fitnessValues (iSelectedIndividuals);
[~, index] = sort(selectedFitnessValues);
iSortedSelectedIndividuals= iSelectedIndividuals(index);

numberOfContestantsLeft = tournamentSize;
for i=1:tournamentSize

  r=rand;  
  if(r<pTournament || numberOfContestantsLeft == 1)
    iSelected = iSortedSelectedIndividuals(end);
    return;
  else
    iSortedSelectedIndividuals(end) = [];
    numberOfContestantsLeft = numberOfContestantsLeft - 1;
  end
  
end
end
