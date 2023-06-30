function ret = GrangerNet_Estimate(Data,flag,NLAGS)

switch flag
    case 1
        ret = LS_granger_regress(Data,NLAGS,1);%%least square
        ret = sparse_Grangercausality(ret);
    case 2
        ret = GauGau_granger_regress(Data,NLAGS,1);%% gaussian+gaussian Gau-GCA
        ret = sparse_Grangercausality(ret);
    case 3
        ret = LapGau_granger_regress(Data,NLAGS,1);%% gaussian+gaussian Lap-GCA
        ret = sparse_Grangercausality(ret);
    case 4
        ret = GauLap_granger_regress(Data,NLAGS,1);%% gaussian+Laplacian GLap-GCA
        ret = sparse_Grangercausality(ret);
    case 5
        ret = DLap_granger_regress(Data,NLAGS,1);%% laplacian+Laplacian DLap-GCA
        ret = sparse_Grangercausality(ret);
end

end

function ret = sparse_Grangercausality(ret)
[PR,~] = cca_findsignificance(ret,0.05,2);
GC = ret.gc;
GC2 = GC.*PR;
ret.PR = PR;
ret.GC2 = GC2;
end
