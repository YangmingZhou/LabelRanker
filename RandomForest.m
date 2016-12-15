%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Random forest for label ranking (RF-LR)                                                                                                                                                                %
% Written by Yangming Zhou (yangming@info.univ-angers.fr and zhou.yangming@yahoo.com), 15 August 2015                                                                                                               %                                                                                                                                  %
% Results are derived by five repetitions of a ten folds cross-validation                                                                                                                        %
% Adjustable Parameters: 
% 1.maximum depth of the tree (MaxDepth)
% 2.number of the trees (NumTrees)
% To handle data set with complete rankings and incomplete rankings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initializing Phase
clc;
clear;
close all;
%rng('default');     % Fix random seed

fprintf('Strart initializing...\n')
global Node 
global MaxDepth;
global DirectoryTrees;
global DirectoryResults;
global NumLabels;
global NumClasses;
global NumTrees;
global MissingProbability;

MissingProbability=0.6;                  % Probability to delete a label
NumRepetitions = 5;                      % Number of repetitions
NumFolds=10;                               % Number of folds of cross validation
NumTrees=50 ;                              % Number of decision trees in the random forest
MaxDepth =8;                                % Maximum depth of the decidion tree
DirectoryTrees='RandomTrees';        % Directory to store the random trees.
DirectoryResults='Results.06';          % Directory to store the experimental results
DirectoryData='./data';                % Data directory
DataFlag=0;                                   % Indicate RealWorldData(1) or SemiSyntheticData(0)
IndexDataset=9;                             % Index of current dataset
IndicateTime=datestr(now, 30);

AverageKendallTau=zeros(NumFolds, NumRepetitions);
AverageSpearmanRho=zeros(NumFolds, NumRepetitions);
AverageWeightedSigma=zeros(NumFolds, NumRepetitions);

if ~exist(DirectoryTrees, 'dir')       
    mkdir(DirectoryTrees);
end

if ~exist(DirectoryResults, 'dir')
    mkdir(DirectoryResults);
end

% Load the data
fprintf('Strart loading the specificed dataset...\n')
loadDatasetInfo(DataFlag, DirectoryData);
load ('DatasetInfo.mat');                                                              % Statistical information related to each dataset
NumDatasets=length(DatasetInfo);                                               % Total number of datasets
NumLabels=DatasetInfo(IndexDataset).numLabels;                        % Number of class labels;
NumFeatures=DatasetInfo(IndexDataset).numFeatures;                  % Number of the features;
NameDataset=DatasetInfo(IndexDataset).nameDataset;                  % Name of the selected dataset
fprintf('Current dataset is %s\n', NameDataset);

if DataFlag==1
    dataset=textread(NameDataset,'','delimiter',',');
elseif DataFlag==0
    dataset=xlsread(strcat(DirectoryData, '/', NameDataset));
else
    fprintf('DataFlag is wrong!');
end

% Check the given information is correct or not?
[NumInstances, TotalNumAttributes]=size(dataset);
if NumInstances~=DatasetInfo(IndexDataset).numInstances
    error('Number of instances is not consistent with the given value.');
end

if TotalNumAttributes~=NumLabels+NumFeatures
    error('Number of features or number of labels is not consistent with the given value.');
end

%% Preprocessing Phase
fprintf('Dividing the original dataset.\n');
datasetFeatures=dataset(:, 1:NumFeatures);                                       % Feature vector
datasetRankings=dataset(:, (NumFeatures+1):TotalNumAttributes);      % Label ranking

% Use each distinct ranking as a class
[UniqueRankings, ~, datasetClassLabel]=unique(datasetRankings, 'rows');
NumClasses=size(UniqueRankings, 1);
datasetLabels=zeros(NumInstances, NumClasses);                  % A vector to indicate the class information of each observation
for IndexInstance=1:NumInstances
    datasetLabels(IndexInstance, datasetClassLabel(IndexInstance))=1;
end

% Five repetitions of a ten fold cross-validation
for IndexRepetition=1:NumRepetitions
    % Stratified sampling with replacement
    Indices=crossvalind('Kfold', datasetClassLabel, NumFolds); 
    % Ten fold cross-validation
    for IndexFold=1:NumFolds 
        TestFold=(Indices == IndexFold);
        % Generate new training data by sampling with replacement
        [trainingFeatures, trainingLabels, trainingRankings, testingFeatures, testingLabels, testingRankings]=divideDataset(datasetFeatures, datasetLabels, datasetRankings, TestFold);

        %% Training Phase
        fprintf('Strart generating trees...\n')
        for IndexTree=1:NumTrees
            Node=struct('node', [], 'depth', [], 'isLeaf', [], 'dimension', [], 'threshold', [], 'entropy', []); % Define a structure to store the information of each node.
            IndexNode=1;
            Depth=1;
            IsLeafNode='false';
            %UnsplitTrainingFeatures=trainingFeatures(:, :, IndexTree); % Unsplit features
            %growTree(UnsplitTrainingFeatures, trainingFeatures(:, :, IndexTree), trainingLabels(:, :, IndexTree), IndexNode, Depth, IsLeafNode); % Build the i-th tree.
            generateTree(trainingFeatures(:, :, IndexTree), trainingLabels(:, :, IndexTree), IndexNode, Depth, IsLeafNode); % Build the i-th tree.
            save([DirectoryTrees, '/tree', int2str(IndexTree), '.mat'], 'Node'); % Store the builded trees.
            fprintf('Finished tree %d/%d.\n', IndexTree, NumTrees);
        end

        %% Parsing Phase
        fprintf('Strart parsing random trees...\n')
        for IndexTree=1:NumTrees
            assignInstanceToTree(trainingFeatures(:, :, IndexTree), IndexTree)
            % displayTree(IndexTree); % Display the overall random tree
            fprintf('Finish parsing tree %d/%d.\n', IndexTree, NumTrees);
        end
 
        %% Predicting Phase
        fprintf('Strart predicting...\n');
        NumTrainInstances=size(trainingRankings(:, :, 1), 1);
        NumTestInstances=size(testingFeatures, 1);                              % Number of testing instances
        PredictedRanking=zeros(NumTestInstances, NumLabels);           % Predicted ranking of each testing instance
        KendallTau=zeros(NumTestInstances, 1);
        SpearmanRho=zeros(NumTestInstances, 1);
        WeightSigma=zeros(NumTestInstances, 1);
           
        % Aggregate strategy: consider each tree individually
        for IndexTestInstance=1:NumTestInstances
            NeighboringRankings=zeros(NumTrees, NumLabels);  % Store the decision results of each tree
            for IndexTree=1:NumTrees
                load([DirectoryTrees, '/tree', int2str(IndexTree), '.mat']);     % Load the tree
                IndexLeafNode = findLeafNode(Node, testingFeatures(IndexTestInstance, :));  % Leaf node at the tree
                Neighbors=Node(IndexLeafNode).domain;                        % Neighbors in this tree
                NeighboringRanks=zeros(length(Neighbors), size(trainingRankings(:, :, IndexTree), 2));
                    
                % Find all neighboring ranking in this tree
                for IndexNeighbor=1:length(Neighbors)
                    NeighboringRanks(IndexNeighbor, :)=trainingRankings(Neighbors(IndexNeighbor), :, IndexTree);
                end
                % Aggregate all neighboring rankings of the tree into a ranking
                if size(NeighboringRanks, 1)>0
                    NeighboringRankings(IndexTree, :)=aggregateIncompleteRankings(NeighboringRanks);
                end
            end
            
            % Aggregate the resulting rankings of each tree into a predicted ranking
            PredictedRanking(IndexTestInstance, :)=aggregateCompleteRankings(NeighboringRankings);
            % Compare the predicted ranking with the actual true ranking
            KendallTau(IndexTestInstance)=corr(PredictedRanking(IndexTestInstance, :)', testingRankings(IndexTestInstance, :)', 'type' , 'Kendall');
            SpearmanRho(IndexTestInstance)=corr(PredictedRanking(IndexTestInstance, :)', testingRankings(IndexTestInstance, :)', 'type' , 'Spearman');
            WeightSigma(IndexTestInstance)=wcorr(PredictedRanking(IndexTestInstance, :)', testingRankings(IndexTestInstance, :)');
            fprintf('Finish testing instances %d/%d.\n', IndexTestInstance, NumTestInstances);
        end
        
        % Calculate the average Kendall's tau over all testing instances
        SumKendallTau=sum(KendallTau);
        AverageKendallTau(IndexFold, IndexRepetition)=SumKendallTau/NumTestInstances;
        
        % Calculate the average Spearman's rho over all testing instances
        SumSpearmanRho=sum(SpearmanRho);
        AverageSpearmanRho(IndexFold, IndexRepetition)=SumSpearmanRho/NumTestInstances;
        
        % Calculate the average Weight's sigma over all testing instances
        SumWeightSigma=sum(WeightSigma);
        AverageWeightedSigma(IndexFold, IndexRepetition)=SumWeightSigma/NumTestInstances;
        
        fprintf('Task Completed: %d repetitions and %d folds.\n', IndexRepetition, IndexFold);
    end
end

% Store results in terms of Kendall's tau and Sperman's rho respectively
ResultFileName=[DirectoryResults, '/KendallTau.', IndicateTime, '.', NameDataset];
save(ResultFileName, 'AverageKendallTau', '-ascii', '-tabs');

ResultFileName=[DirectoryResults, '/SpearmanRho.', IndicateTime, '.', NameDataset];
save(ResultFileName, 'AverageSpearmanRho', '-ascii', '-tabs');

ResultFileName=[DirectoryResults, '/WeightSigma.', IndicateTime, '.', NameDataset];
save(ResultFileName, 'AverageWeightedSigma', '-ascii', '-tabs');
% Average results on five repetitions of a ten fold cross-validation
FinalKendallTau=sum(sum(AverageKendallTau))/NumFolds/NumRepetitions;
FinalSpearmanRho=sum(sum(AverageSpearmanRho))/NumFolds/NumRepetitions;
FinalWeightSigma=sum(sum(AverageWeightedSigma))/NumFolds/NumRepetitions;
fprintf('Results on dataset: %s are Kendalltau=%.3f, Spearmanrho=%.3f and Weightsigma=%.3f.\n', NameDataset, FinalKendallTau, FinalSpearmanRho, FinalWeightSigma);

 
 
 