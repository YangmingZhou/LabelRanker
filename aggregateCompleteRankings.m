function PredictedRanking=aggregateCompleteRankings(NeighboringRankings)
% Aggregate the rankings located at a leaf node to generate a predicted ranking by Borda Count
% for complete ranking

global NumLabels;
NumRankings=size(NeighboringRankings, 1);

% Make a vote to each class label
Constant=(NumLabels+1)*ones(NumRankings, NumLabels);
ScoreLables=Constant-NeighboringRankings;

SumScoreLabels=sum(ScoreLables, 1);
PredictedRanking=zeros(1, NumLabels);

% Obtain a ranking of the labels according their votes
for IndexLabel=1:NumLabels
    [~, MaxIndex]=max(SumScoreLabels);
    PredictedRanking(MaxIndex)=IndexLabel;
    SumScoreLabels(MaxIndex)=0;
end

end