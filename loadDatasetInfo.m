function loadDatasetInfo(DataFlag, DataDirectory)
% Dataset Statistical Information
% Writen by Yangming Zhou, 17 July 2015

% Indicate RealWorldData or SemiSyntheticData
if DataFlag==1
    DataType='RealWorldData';
    file=dir(strcat(DataDirectory,'/*.csv'));
else
    DataType='SemiSyntheticData';
    file=dir(strcat(DataDirectory,'/*.xls'));
end

if strcmp(DataType, 'RealWorldData')==1 % Realworld data
    fprintf('Putting the realworld datasets in the current directory!\n')
    NumInstances=[2465, 2465, 2465, 2465, 2465];
    NumFeatures=[24, 24, 24, 24, 24];
    NumLabels=[4, 7, 4, 6, 11];
elseif strcmp(DataType, 'SemiSyntheticData')==1 % Semisynthetic data
    fprintf('Putting the semi-synthetic datasets in the current directory!\n')
    NumInstances=[841, 252, 20640, 8192, 16599, 40768, 214, 506, 150, 10992, 2310, 950, 846, 528, 178, 194];
    NumFeatures=[70, 7, 4, 6, 9, 9, 9, 6, 4, 16, 18, 5, 18, 10, 13, 16];
    NumLabels=[4, 7, 4, 5, 9, 5, 6, 6, 3, 10, 7, 5, 4, 11, 3, 16]; 
else
    fprintf('Given data type is wrong!');
end

NameDataset={file.name}';
NumDatasets=length(NameDataset);    % Number of data sets

% Define a structure to store the statistical information of each dataset
DatasetInfo=struct('typeDataset', [], 'nameDataset', [], 'numInstances', [], 'numFeatures', [], 'numLabels', []);
for index=1:NumDatasets
    DatasetInfo(index).typeDataset=DataType;                       % Type of the dataset
    DatasetInfo(index).nameDataset=NameDataset{index};     % Name of the dataset
    DatasetInfo(index).numInstances=NumInstances(index);   % Number of instances
    DatasetInfo(index).numFeatures=NumFeatures(index);     % Number of features
    DatasetInfo(index).numLabels=NumLabels(index);           % Number of labels
end
save('DatasetInfo.mat','DatasetInfo');
end
