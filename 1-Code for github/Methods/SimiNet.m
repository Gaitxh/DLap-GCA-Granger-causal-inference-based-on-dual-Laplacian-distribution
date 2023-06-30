function NSI = SimiNet(Net_1,Net_2,Redius)
% Input
% Net_1 :network 1. The target net.
% Net_2 :network 2. The origin net.

% Ratio :the ratio for each node and denote the delete value for node deletion
% Output
% NSI   :network similarity indicators
% this function is designed to estimate the similarity between two
% networks. and reffer to the paper <SimiNet: a Novel Method for Quantifying Brain Network Similarity>

nvar = size(Net_1,1);
angle = (2*pi)/nvar;
X = zeros(nvar,1); Y = zeros(nvar,1);
for i=1:nvar
    X(i) = cos(angle*(i-1));
    Y(i) = sin(angle*(i-1));
end
X_loc = X'; Y_loc = Y';
Loc = [X_loc;Y_loc]';
for l_i = 1:length(X_loc)
    for l_j = l_i+1:length(X_loc)
        Dis(l_i,l_j) = norm(Loc(l_i,:)-Loc(l_j,:));
    end
end
if nargin<3
    Redius = 1.5;
end
%% nodes property difference(node shifting, node insertion, node deletion)
%Step-1 Node substitution
%B-i: Common nodes
%% judge the common nodes and remind nodes
Loca_1 = find((sum(Net_1,1) + sum(Net_1,2)')~=0);%% estimate nodes
Loca_2 = find((sum(Net_2,1) + sum(Net_2,2)')~=0);%% target nodes
ND = 0;ED = 0;
count_dele = 0;count_shift = 0;
node_shift_rec = [];nodedele_rec = [];
if isempty(Loca_1) ~= 1 && isempty(Loca_2) ~= 1
    Diff_node_est = setdiff(Loca_1,Loca_2);%% calculate the common nodes
    if isempty(Diff_node_est) ~= 1 %% if the common nodes are all then turn to B-ii
        %%B-ii shifting
        %%calculate the distance between node and target nodes set
        for node_ii = 1:length(Diff_node_est)
            for node_jj = 1:length(Loca_2)
                Distance_node(node_ii,node_jj) = norm(Loc(Diff_node_est(node_ii),:)-Loc(Loca_2(node_jj),:),2);
            end
            %judge the radius between node and target nodes set
            node_shifting = find(Distance_node(node_ii,:)<Redius);
            if isnan(node_shifting) ~= 1
                min_dis = min(Distance_node(node_ii,node_shifting));
                ND = ND + min_dis;
                count_shift = count_shift+1;
                node_shift_rec(count_shift) = Loca_2(find(Distance_node(node_ii,:)==min_dis,1,'first'));
            else
                %%save the esti nodes that bigger than radius of target node set
                count_dele = count_dele+1;
                nodedele_rec(count_dele) = Diff_node_est(node_ii);
            end
        end
        %% Step-2 node insertion
        Diff_node_tar = setdiff(Loca_2,Loca_1);
        diff_inser = setdiff(Diff_node_tar,node_shift_rec);
        ND = ND + Redius*length(diff_inser);
        
        %% Step-3 node deletion
        ND = ND + Redius*count_dele;
        
    else
        %% Step-2 node insertion
        Diff_node_tar = setdiff(Loca_2,Loca_1);
        ND = ND + Redius*length(Diff_node_tar);
        
        %% Step-3 node deletion
        ND = ND + Redius*count_dele;
    end
else
    %% Step-2 node insertion
    ND= ND + Redius*length(Loca_2);
end
%% Step-4 edge-distance
ED = ED + sum(sum(abs(Net_1-Net_2)));
d = ND+ED;
NSI = 1/(1+d);

end