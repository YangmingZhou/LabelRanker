function [MinEntropySplit, OptimalThreshold]=selectThreshold(TrainingFeature, TrainingLabels)
% Find an optimal threshold that achieves the maximum information gain

NumInstanceFather=length(TrainingFeature);
NumBreakpoints=NumInstanceFather-1;
MinEntropySplit=999999;
PossibleThreshold=zeros(NumInstanceFather,1);
% Sort the feature values in ascending order
SortingTrainFeature=sort(TrainingFeature); 
OptimalThreshold=(SortingTrainFeature(1)+SortingTrainFeature(2))/2; 
for IndexPoint=1:NumBreakpoints
    PossibleThreshold(IndexPoint)=(SortingTrainFeature(IndexPoint)+SortingTrainFeature(IndexPoint+1))/2; 
    
    if (IndexPoint > 1 && PossibleThreshold(IndexPoint)~=PossibleThreshold(IndexPoint-1)) || (IndexPoint==1)
        IndexLeftChild=TrainingFeature<=PossibleThreshold(IndexPoint);
        IndexRightChild=TrainingFeature>PossibleThreshold(IndexPoint);
    
        % Calculate the entropy for the left node
        TrainingLabelLeft=(TrainingLabels(IndexLeftChild, :));
        pLeft=sum(TrainingLabelLeft, 1);
        NumInstanceLeft=sum(pLeft);                                         
        pLeft=pLeft/NumInstanceLeft;
        entropyLeft=zeros(size(pLeft));
        IndexL=find(pLeft~=0);
        entropyLeft(IndexL)=pLeft(IndexL).*log2(pLeft(IndexL));
        entropyLeft=-sum(entropyLeft);
        
        % Calculate the entropy for the right node
        TrainingLabelRight=(TrainingLabels(IndexRightChild, :));
        pRight=sum(TrainingLabelRight, 1);
        NumInstanceRight=sum(pRight);                                
        pRight=pRight/NumInstanceRight;    
        entropyRight=zeros(size(pRight));
        IndexR=find(pRight~=0);
        entropyRight(IndexR)=pRight(IndexR).*log2(pRight(IndexR));
        entropyRight=-sum(entropyRight);
        
        % Calculate the entropy after split
        PercentLeft=NumInstanceLeft/NumInstanceFather;
        entropySplit=PercentLeft*entropyLeft+(1-PercentLeft)*entropyRight;
    
        if entropySplit<MinEntropySplit
            MinEntropySplit=entropySplit;
            OptimalThreshold=PossibleThreshold(IndexPoint);
        end        
    end
        
end