function displayTree(IndexTree)
% Display given random tree, specially the leaf nodes.
NameTree=['tree', int2str(IndexTree), '.mat'];
PathTree=['/home/yangming/Matlab2015a/bin/glnxa64/RFLRV3/RandomTrees/', NameTree];

load (PathTree);

NumNodes=size(Node, 2);    % Number of nodes in the tree
NumLeafNodes=0;               % Number of leaf nodes in the tree
NumInstances=0;                 % Number of training instances in the tree

for IndexNode=1:NumNodes
    if strcmp(Node(IndexNode).isLeaf, 'true')
        str1=['The node ', int2str(IndexNode), ' is a leaf node'];
        disp(str1);
        disp(Node(IndexNode));
        NumLeafNodes=NumLeafNodes+1;
        NumInstances=NumInstances+size(Node(IndexNode).domain, 2);
    end
end

str2=['There are ', int2str(NumNodes),' nodes and include ', int2str(NumLeafNodes), ' leaf nodes in the tree ', int2str(IndexTree)];
disp(str2);
str3=['There are ', int2str(NumInstances), ' training instances in total at leaf nodes'];
disp(str3);

end
