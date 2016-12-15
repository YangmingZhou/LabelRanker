function neighbours_of_test_instance=findNeighbours(DirectoryTrees, testingInstance, newTrainingLabels, NumTrees)
% Find the nearest neighbours of testing instance

neighbours_of_test_instance=[];
temp_start=1;
for IndexTree=1:NumTrees
    load([DirectoryTrees,'/tree',int2str(IndexTree), '.mat']);                      % load k-th tree.
    IndexNode = findLeafNode(Node, testing_instance );                        % the corresponding leaf node at k-th tree.
    num_of_neighbours_leaf_node=size(Node(IndexNode).domain, 2);    % number of instances at the leaf node.
    temp_index=Node(IndexNode).domain;
    
    for i_index=1:num_of_neighbours_leaf_node
        neighbours_of_test_instance((temp_start+i_index-1), :)=new_training_labels(temp_index(i_index),:,IndexTree);
        temp_start=size(neighbours_of_test_instance,2)+1;
    end
end
end