function newChromosomePair = Cross(chromosome1, chromosome2)

nGenes1 = size(chromosome1,1);
nGenes2 = size(chromosome2,1); 

nInstructions1 = nGenes1 /4;
nInstructions2 = nGenes2 /4;

crossoverPoints1 = 4*randi([1,nInstructions1-2],1,2); %Does not include extremes
crossoverPoints1 = sort(crossoverPoints1);
crossoverPoints2 = 4*randi([1,nInstructions2-2],1,2); %Does not include extremes
crossoverPoints2 = sort(crossoverPoints2);

chromosome1Segment1 = chromosome1(1:crossoverPoints1(1));
chromosome1Segment2 = chromosome1(crossoverPoints1(1)+1:crossoverPoints1(2));
chromosome1Segment3 = chromosome1(crossoverPoints1(2)+1:end);

chromosome2Segment1 = chromosome2(1:crossoverPoints2(1));
chromosome2Segment2 = chromosome2(crossoverPoints2(1)+1:crossoverPoints2(2));
chromosome2Segment3 = chromosome2(crossoverPoints2(2)+1:end);


newChromosome1 = [chromosome1Segment1; chromosome2Segment2; chromosome1Segment3];
newChromosome2 = [chromosome2Segment1; chromosome1Segment2; chromosome2Segment3];

newChromosomePair(1) = struct('Chromosome',newChromosome1);
newChromosomePair(2) = struct('Chromosome',newChromosome2);

end
