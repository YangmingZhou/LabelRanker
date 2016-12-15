function growTree(UnsplitTrainingFeatures, TrainingFeatures, TrainingLabels, IndexNode, Depth, IsLeafNode)
% build the whole tree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT Paremeters:
%   UnsplitTrainingFeatures: Features vectors where the split features have been deleted
%   TrainingFeatures: original data
%   TrainingLabels: Class label of the original data
%   IndexNode: Index of the current node
%   Depth: Depth of the current node
%   IsLeafNode: A flag to indicate a leaf node
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Node

if strcmp(IsLeafNode, 'true')                                                                % A leaf node
    Node(IndexNode).isLeaf='true';   
    makeLeaf(IndexNode, Depth);
else
    Node(IndexNode).isLeaf='false';                                                      % Not a leaf node
    Node(IndexNode).node=IndexNode;                                          
    Node(IndexNode).depth=Depth;                                                   
    
    %Calculate Node(i).entropy
    p=sum(TrainingLabels, 1);                                                           
    p=p/sum(p);                                                                               
    systemEntropy=zeros(size(p));
    IndexClass=find(p~=0);
    systemEntropy(IndexClass)=p(IndexClass).*log2(p(IndexClass));       
    systemEntropy=-sum(systemEntropy);                                           
    Node(IndexNode).entropy=systemEntropy;  
       
    % Choose a feature and find its optimal threshold value to make a split
    NumUnsplitFeatures=size(UnsplitTrainingFeatures, 2);  % Number of unsplited features
    if NumUnsplitFeatures==1                              % Only one featuere is available
        ChosenFeature=UnsplitTrainingFeatures;
        [~, ChosenThreshold]=selectThreshold(UnsplitTrainingFeatures, TrainingLabels);
        IndexMinEntropySplit=1;
    else if NumUnsplitFeatures>1
        % Store threshold and gain ratio of each possible split features
        EntropySplit=zeros(NumUnsplitFeatures, 1);
        Threshold=zeros(NumUnsplitFeatures, 1);
    
        % Find out the optimal threshold for each upsplit feature
        for IndexUnsplitFeature=1:NumUnsplitFeatures 
            [EntropySplit(IndexUnsplitFeature), Threshold(IndexUnsplitFeature)]=selectThreshold(UnsplitTrainingFeatures(:, IndexUnsplitFeature), TrainingLabels);
        end
        [~, IndexMinEntropySplit]=min(EntropySplit);                        % Unsplit feature with maximum gain ratio        
        ChosenFeature=UnsplitTrainingFeatures(:,IndexMinEntropySplit);   % Chosen unsplit feature
        ChosenThreshold=Threshold(IndexMinEntropySplit);                 % Optimal threshold for the chosen unsplit feature
        end
    end
    
    % Calculate the Node(i).dimension, i.e.,  the place of the chosen feature in its original feature vector
    for IndexDimension=1:size(TrainingFeatures, 2)
        if all(ChosenFeature==TrainingFeatures(:, IndexDimension))==1
            Node(IndexNode).dimension=IndexDimension;     %, i.e.,  Index of feaure in feature vector
            break;
        end
    end
    
    % Calculate the Node(i).threshold
    Node(IndexNode).threshold = ChosenThreshold;  
    
    % Split the dataset at current node based on chosen feature and its optimal threshold value
    NumLeftSub=0;
    NumRightSub=0;
    IndexLeftSub=[];
    IndexRightSub=[];
    
    for IndexInstance=1:length(ChosenFeature)
        if ChosenFeature(IndexInstance)<ChosenThreshold
            NumLeftSub=NumLeftSub+1;
            IndexLeftSub(NumLeftSub)=IndexInstance;
        else
            NumRightSub=NumRightSub+1;
            IndexRightSub(NumRightSub)=IndexInstance;
        end
    end
    
    % Delete the splited feature from feature vector
    if NumUnsplitFeatures>=1
        UnsplitTrainingFeatures(:, IndexMinEntropySplit)=[]; 
    end
    
    % Find the instances belong to left node
    LeftUnsplitTrainingFeatures=zeros(length(IndexLeftSub), size(UnsplitTrainingFeatures, 2));
    LeftTrainingFeatures=zeros(length(IndexLeftSub), size(TrainingFeatures, 2));
    LeftTrainingLabels=zeros(length(IndexLeftSub), size(TrainingLabels, 2));
    
    for m=1:length(IndexLeftSub)
        LeftTrainingFeatures(m, :)=TrainingFeatures(IndexLeftSub(m), :);
        LeftUnsplitTrainingFeatures(m, :)=UnsplitTrainingFeatures(IndexLeftSub(m), :);
        LeftTrainingLabels(m, :)=TrainingLabels(IndexLeftSub(m), :);
    end
    
    % Grow of the left child node
    LeftNum=sum(LeftTrainingLabels, 1);
    LeftIndex=find(LeftNum~=0);                                    % Number of class of the instances in current node
    
    if length(LeftIndex)>1 && NumUnsplitFeatures > 1      % Left child node is not a leaf node
        IsLeafNode='false';
        growTree(LeftUnsplitTrainingFeatures, LeftTrainingFeatures, LeftTrainingLabels, IndexNode*2, Depth+1, IsLeafNode);
    else                                                                          % Left child node is a leaf node
        IsLeafNode='true';
        growTree(LeftUnsplitTrainingFeatures, LeftTrainingFeatures, LeftTrainingLabels, IndexNode*2, Depth+1, IsLeafNode);
    end
    
    % Find the instances belong to right node
    RightUnsplitTrainingFeatures=zeros(length(IndexRightSub), size(UnsplitTrainingFeatures,2));
    RightTrainingFeatures=zeros(length(IndexRightSub), size(TrainingFeatures,2));   
    RightTrainingLabels=zeros(length(IndexRightSub), size(TrainingLabels,2));
    
    for n=1:length(IndexRightSub)
        RightTrainingFeatures(n, :)=TrainingFeatures(IndexRightSub(n), :);
        RightUnsplitTrainingFeatures(n, :)=UnsplitTrainingFeatures(IndexRightSub(n), :);
        RightTrainingLabels(n, :)=TrainingLabels(IndexRightSub(n), :);
    end
    
    % Grow of the right child node
    RightNum=sum(RightTrainingLabels, 1);
    RightIndex=find(RightNum~=0);
    
    if length(RightIndex)>1 && NumUnsplitFeatures > 1      % Right child node is not a leaf node
        IsLeafNode='false';
        growTree(RightUnsplitTrainingFeatures, RightTrainingFeatures, RightTrainingLabels, IndexNode*2+1, Depth+1, IsLeafNode);
    else                                                                            % Right child node is a leaf node
        IsLeafNode='true';
        growTree(RightUnsplitTrainingFeatures, RightTrainingFeatures, RightTrainingLabels, IndexNode*2+1, Depth+1, IsLeafNode);
    end 
end
end

