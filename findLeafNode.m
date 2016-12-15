function IndexLeafNode = findLeafNode(Node, TestingFeature)
% Find the leaf node in the tree for the testing instance

IndexNode=1;

while ~strcmp(Node(IndexNode).isLeaf, 'true')
    if TestingFeature(Node(IndexNode).dimension)<=Node(IndexNode).threshold               
        IndexNode=IndexNode*2;       
    else
        IndexNode=IndexNode*2+1;
    end
end

IndexLeafNode=IndexNode;

end