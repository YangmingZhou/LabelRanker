function [IndexLeafNode, Neighbours] = parseTree(Node, FeatureVector)
%PARSE_TREES
Index=1;

while ~strcmp(Node(Index).isLeaf, 'true')
    if FeatureVector(Node(Index).dimension)<=Node(Index).threshold               
        Index=Index*2;       
    else
        Index=Index*2+1;
    end
end

IndexLeafNode=Index;
Neighbours=Node(Index).domain;

end