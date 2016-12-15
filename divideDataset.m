function [NTrainingFeatures, NTrainingLabels, NTrainingRankings, TestingFeatures, TestingLabels, TestingRankings]=divideDataset(DatasetFeatures, DatasetLabels, DatasetRankings, IndexTestFold)
%Divide the original dataset into training dataset and testing dataset
global NumTrees;
global NumLabels;
global NumClasses;
IsSampleReplace='true'; % a flag to indicate sample with replacement

% One fold for testing the model
TestingFeatures=DatasetFeatures(IndexTestFold,:);
TestingLabels=DatasetLabels(IndexTestFold,:);
TestingRankings=DatasetRankings(IndexTestFold,:);

% Remaining K-1 folds for training the model
IndexTrainFold=~IndexTestFold;
TrainingFeatures=DatasetFeatures(IndexTrainFold,:);
TrainingLabels=DatasetLabels(IndexTrainFold,:);
TrainingRankings=DatasetRankings(IndexTrainFold,:);
    
% For training dataset, sample with replacement to get NumTrees new training datasets
NumTrainInstances=size(TrainingFeatures, 1);
NumFeatures=size(DatasetFeatures, 2); 

% Generate a training dataset for each tree
NTrainingFeatures=zeros(NumTrainInstances, NumFeatures, NumTrees);
NTrainingLabels=zeros(NumTrainInstances, NumClasses, NumTrees);
NTrainingRankings=zeros(NumTrainInstances, NumLabels, NumTrees);

for IndexTree=1:NumTrees
    
    Index=randsample(NumTrainInstances, NumTrainInstances, IsSampleReplace);
    NTrainingFeatures(:, :, IndexTree)=TrainingFeatures(Index, :);
    NTrainingLabels(:, :, IndexTree)=TrainingLabels(Index, :);
    NTrainingRankings(:, :, IndexTree)=TrainingRankings(Index, :);
    
end
end