function PredictedRanking=aggregateIncompleteRankings(NeighboringRankings)
% Aggregate the rankings located at a leaf node to generate a predicted ranking by Borda Count
% for incomplete ranking

global NumLabels;
global MissingProbability;    % Probability to delete a label

NumRankings=size(NeighboringRankings, 1); % Number of neighbors in current tree
ScoreLabels=zeros(1, NumLabels);
for IndexRanking=1:NumRankings
    
    IncompleteRanking=[];
    RandVector=rand(1,NumLabels);
    MissingIndex=RandVector<MissingProbability;
    NumMissingLabels=sum(MissingIndex); % Number of missing labels
    
    % Delte the missing labels
    for IndexLabel=1:NumLabels
        if MissingIndex(IndexLabel)==0
            IncompleteRanking=[IncompleteRanking NeighboringRankings(IndexRanking, IndexLabel)];
        end
    end
    NumRemainingLabels=length(IncompleteRanking); % Number of remaining labels
    if (NumRemainingLabels+NumMissingLabels)~=NumLabels
        exit('Error occurs in aggregateIncompleteRankings');
    end
    ARanking=sort(IncompleteRanking); % Resort the ranking in a ascending order
    
    % Vote for each label
    for IndexLabel=1:NumLabels
        if MissingIndex(IndexLabel)==1 % Missing label
            ScoreLabels(IndexLabel)=ScoreLabels(IndexLabel)+(NumLabels+1)/2;
        else % Remaining label
            IndexRank=find(ARanking==NeighboringRankings(IndexRanking, IndexLabel));
            ScoreLabels(IndexLabel)=ScoreLabels(IndexLabel)+(NumRemainingLabels+1-IndexRank)*(NumLabels+1)/(NumRemainingLabels+1);
        end
    end
end

% Obtain a ranking of the labels according their votes in a descend order
PredictedRanking=zeros(1, NumLabels);
for IndexLabel=1:NumLabels
    [~, MaxIndex]=max(ScoreLabels);
    PredictedRanking(MaxIndex)=IndexLabel;
    ScoreLabels(MaxIndex)=0;
end

end