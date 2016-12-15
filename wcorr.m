function wcof=wcorr(PredictedRanking, TrueRanking)
% WCORR.m for calculating the weighted rank correlation coefficient
% INPUT Parameters:
%   PredictedRanking: predicted ranking
%   TrueRanking: true ranking
% OUTPUT: a weighted rank correlation between these two rankings
LengthRank=length(TrueRanking);                          % Number of different labels
NumPairsLabel=LengthRank*(LengthRank-1)/2;      % Number of pairs of labels
Weight=NumPairsLabel;                                         % Lagest weight
TRMatrix=zeros(LengthRank, LengthRank);             % A pairwise labels matrix for true ranking
PRMatrix=zeros(LengthRank, LengthRank);             % A pairwise labels matrix for predicted ranking
WeightMatrix=zeros(LengthRank, LengthRank);      % A weight matrix for each label pair

for i=1:LengthRank
    for j=i+1:LengthRank
        TRMatrix(TrueRanking(i), TrueRanking(j))=1;
        PRMatrix(PredictedRanking(i), PredictedRanking(j))=1;
        WeightMatrix(TrueRanking(i), TrueRanking(j))=Weight;
        WeightMatrix(TrueRanking(j), TrueRanking(i))=Weight;
        Weight=Weight-1;
    end
end

% Compare these two matrices
DifMatrix=(TRMatrix-PRMatrix);

% The sum of the weights of all discordant label pairs
TotalWeightsDiscordant=0;
for m=1:LengthRank
    for n=m+1:LengthRank
        if DifMatrix(m, n)~=0
            TotalWeightsDiscordant=TotalWeightsDiscordant+WeightMatrix(m,n);
        end
    end
end

% Calculate the weighted rank correlation coefficient
wcof=1-4*TotalWeightsDiscordant/NumPairsLabel/(NumPairsLabel+1);
end
