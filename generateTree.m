function generateTree(TrainingFeatures, TrainingLabels, IndexNode, Depth, IsLeafNode)
% GENERATETREE.m to build the whole tree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT Paremeters:
%   TrainingFeatures: Feature vectors
%   TrainingLabels: Class label of the original data
%   IndexNode: Index of the current node
%   Depth: Depth of the current node
%   IsLeafNode: A flag to indicate a leaf node
% OUTPUT: A decision tree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Node
global MaxDepth;

if strcmp(IsLeafNode, 'true')               % A leaf node
    Node(IndexNode).isLeaf='true';   
    makeLeaf(IndexNode, Depth);
else
    Node(IndexNode).isLeaf='false';     % Not a leaf node
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
    NumFeatures=size(TrainingFeatures, 2);                   % Number of unsplited features
    NumSelectedFeatures=floor(log2(NumFeatures))+1;  % Number of features select at random for each decision split
    RandIndex=randperm(NumFeatures);                        % Generate some random numbers for each available features
    FeatureDims=RandIndex(1:NumSelectedFeatures);     % Dimension of each selected feature in original feature vector
    
    % Store the split threshold and entropy of each selected feature
    EntropySplit=zeros(NumSelectedFeatures, 1);
    Threshold=zeros(NumSelectedFeatures,1);
    
    % Calculate the entropy and best threshold for each selected feature
    for i=1:NumSelectedFeatures
        [EntropySplit(i), Threshold(i)]=selectThreshold(TrainingFeatures(:, FeatureDims(i)), TrainingLabels);
    end
    
    % Find the split feature with minimum entropy
    [~, IndexFeature]=min(EntropySplit);
    
    % Calculate the Node(i).dimension
    Node(IndexNode).dimension=FeatureDims(IndexFeature);
    
    % Calculate the Node(i).threshold
    Node(IndexNode).threshold=Threshold(IndexFeature); 
    
    % Split the dataset based on the chosen split feature and its threshold
    IndexLeftNode= TrainingFeatures(:, FeatureDims(IndexFeature))<Threshold(IndexFeature);
    IndexRightNode=find(TrainingFeatures(:, FeatureDims(IndexFeature))>=Threshold(IndexFeature));
    
    % Find the instances belong to left node
    LeftTrainingFeatures=TrainingFeatures(IndexLeftNode, :);
    LeftTrainingLabels=TrainingLabels(IndexLeftNode, :);

    % Grow of the left child node
    LeftNum=sum(LeftTrainingLabels, 1);
    LeftIndex=find(LeftNum~=0);   % Number of class of the instances in current node
    
    if Depth < MaxDepth && length(LeftIndex)>1 % Left child node is not a leaf node
        IsLeafNode='false';
        generateTree(LeftTrainingFeatures, LeftTrainingLabels, IndexNode*2, Depth+1, IsLeafNode);
    else     % Left child node is a leaf node
        IsLeafNode='true';
        generateTree(LeftTrainingFeatures, LeftTrainingLabels, IndexNode*2, Depth+1, IsLeafNode);
    end
    
    % Find the instances belong to right node
    RightTrainingFeatures=TrainingFeatures(IndexRightNode, :);
    RightTrainingLabels=TrainingLabels(IndexRightNode, :);
    
    % Grow of the right child node
    RightNum=sum(RightTrainingLabels, 1);
    RightIndex=find(RightNum~=0);
    
    if Depth < MaxDepth && length(RightIndex)>1    % Right child node is not a leaf node
        IsLeafNode='false';
        generateTree(RightTrainingFeatures, RightTrainingLabels, IndexNode*2+1, Depth+1, IsLeafNode);
    else     % Right child node is a leaf node
        IsLeafNode='true';
        generateTree(RightTrainingFeatures, RightTrainingLabels, IndexNode*2+1, Depth+1, IsLeafNode);
    end 
end
end

