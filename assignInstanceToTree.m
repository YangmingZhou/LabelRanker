function assignInstanceToTree(trainingFeatures, IndexTree)
% Parse the random trees

global Node
global DirectoryTrees;

load([DirectoryTrees, '/tree', int2str(IndexTree), '.mat']);

% Add a domain for each node, to indicate training instances located in this leaf nodes.
for Index=1:length(Node)
    Node(Index).domain=[];
end

NumTrainInstances=size(trainingFeatures, 1);   % Number of training instances

for IndexTrainInstance=1:NumTrainInstances
    [IndexLeafNode, Neighbours]=parseTree(Node, trainingFeatures(IndexTrainInstance, :)); % Find the leaf node for each training instance
    Node(IndexLeafNode).domain=[Neighbours IndexTrainInstance];
end

save([DirectoryTrees, '/tree', int2str(IndexTree), '.mat'], 'Node');

end