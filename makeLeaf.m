function makeLeaf(IndexNode, Depth)
% generate the leaf node
global Node

% Calculate some attribute values of the leaf node
Node(IndexNode).node=IndexNode;      
Node(IndexNode).depth=Depth;               
end

