function Data = DataPrepossed(Data)

Data = cca_detrend(Data); 
Data = cca_rm_temporalmean(Data); 
% Data = cca_diff(Data);
end

