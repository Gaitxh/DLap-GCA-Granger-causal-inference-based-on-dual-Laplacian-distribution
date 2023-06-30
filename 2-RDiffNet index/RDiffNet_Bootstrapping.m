function [mean_index,std_index] = RDiffNet_Bootstrapping(Net_type1,Net_type2,Loc)
%% Input
%%Net_type1 is a matrix with N*N*M (Specifically refers to the network matrix obtained under brain task 1),
%%Net_type1 is a matrix with N*N*M (Specifically refers to the network matrix obtained under brain task 1),
%%N is the node number, M is the total number of tries.
%%Loc is the Cartesian coordinate system of the selected electrodes;
%%--example:
% Loc = [0.32,0.24;0.68,0.24;0.30,0.37;0.70,0.37;0.29,0.50;0.71,0.50;0.18,0.50;
%     0.82,0.50;0.30,0.63;0.70,0.63;0.32,0.76;0.68,0.76;0.37,0.98;0.63,0.98;0.50,0.50];
% corresponding to the electrodes "F3 F4 FC3 FC4 C3 C4 C5 C6 CP3 CP4 P3 P4 O1 O2 CZ" respectively.
%% Output
%%mean_index is the mean value of the indice;
%%std_index is the std value of the indice;
%% Attention
% the final result will fluctuate cause the network pairs are randomly
% matched, Because the network pairs are randomly matched, the final result will fluctuate.
% Of course, our subsequent improvement provided a stable scheme, that is, 
% traversed all network pairs between categories and within categories, 
% and finally accepted "the mean value of inter-category/the mean value of
% intra-category" as the final result.please reffer to the code which name
% as "RDiffNet_Stable_version"
for repeat_i = 1:size(Net_type1,3)*size(Net_type2,3)
    %%Within the category 类内
    type_loc = randperm(2);
    if type_loc(1) == 1
        Net_ana = Net_type1;
    else
        Net_ana = Net_type2;
    end
    loc1 = randperm(size(Net_ana,3));loc2 = randperm(size(Net_ana,3));
    whincategory = SimiNet_Reals(Net_ana(:,:,loc1(1)),Net_ana(:,:,loc2(1)),Loc);
    
    %%inter the category 类间
    clearvars -except repeat_i whincategory index Net_type1 Net_type2 Loc
    loc1 = randperm(size(Net_type1,3));loc2 = randperm(size(Net_type2,3));
    intercategory = SimiNet_Reals(Net_type1(:,:,loc1(1)),Net_type2(:,:,loc2(1)),Loc);
    
    index(repeat_i) = intercategory/whincategory;
    repeat_i
end
mean_index = mean(index);
std_index = std(index);
end


function NSI = SimiNet_Reals(Net_1,Net_2,Loc,Redius)
% Input
% Net_1 :network 1. The target net.
% Net_2 :network 2. The origin net.
% Redius:judgement of the radius
% Loc   : the location of nodes
% Ratio :the ratio for each node and denote the delete value for node deletion
% Output
% NSI   :network similarity indicators
% this function is designed to estimate the similarity between two
% networks. and reffer to the paper <SimiNet: a Novel Method for Quantifying Brain Network Similarity>

nvar = size(Net_1,1);
angle = (2*pi)/nvar;
%% generete the location for nodes automatically
if nargin<3
    X = zeros(nvar,1); Y = zeros(nvar,1);
    for i=1:nvar
        X(i) = cos(angle*(i-1));
        Y(i) = sin(angle*(i-1));
    end
    X_loc = X'; Y_loc = Y';
    Loc = [X_loc;Y_loc]';
end
for l_i = 1:size(Loc,1)
    for l_j = l_i+1:size(Loc,1)
        Dis(l_i,l_j) = norm(Loc(l_i,:)-Loc(l_j,:));
    end
end

%% generate the radius automatically
if nargin<4
    reshape_dis = reshape(Dis,[],1);
    reshape_dis(find(reshape_dis==0)) = [];
    Redius = mean(reshape_dis);
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
NSI = (1+d);

end