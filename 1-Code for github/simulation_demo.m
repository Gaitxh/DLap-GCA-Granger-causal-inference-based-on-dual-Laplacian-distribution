clc;clear all;close all;
addpath(genpath(pwd))
Experience_Time = 50;
Method_flag = [1,2,3,4,5];
Noise_Fre = [.003];
Noise_Intensity = [3];
Noise_Channel = [1 2 3 4 5];
Length_X = 1000;
[Value, Loc] = sort([length(Noise_Fre) length(Noise_Intensity) length(Noise_Channel)],'descend');
method_flag = {'Fre','Intensity','Channel'};
NLAGS = 3;
load('simu_data');
for Noise_S_i = 1:1:max(Value)
    sim.NF = Noise_Fre(min(Noise_S_i,length(Noise_Fre)));
    sim.NI = Noise_Intensity(min(Noise_S_i,length(Noise_Intensity)));
    sim.NC = Noise_Channel(min(Noise_S_i,length(Noise_Channel)));
    for Cycle_ii=1:Experience_Time
        sim.X = data.iniX{1, Noise_S_i}(:,:,Cycle_ii);
        sim.noise_X = data.noiseX{1, Noise_S_i}(:,:,Cycle_ii);
        tic
        for flag_ii = 1:1:length(Method_flag)
            
            ret = Net_Esitmate(sim,Method_flag(flag_ii),NLAGS);
            res.net_err{Noise_S_i}(Cycle_ii,flag_ii) = ret.sumnet_err;
            res.siminet_err{Noise_S_i}(Cycle_ii,flag_ii) = ret.siminet_err;
            res.wei_err{Noise_S_i}(Cycle_ii,flag_ii) = ret.wei_err;
            res.iniGC{Noise_S_i,flag_ii}(:,:,Cycle_ii) = ret.Ini_GC;
            res.estiGC{Noise_S_i,flag_ii}(:,:,Cycle_ii) = ret.esti_GC;
            
        end
        T = toc;
        fprintf([method_flag{Loc(1)},' Noise Time:%d, Cycle Time %d, Spend Time: %.2f s\n'],...
            Noise_S_i,Cycle_ii,T);
    end
    
    %% caluclate the mean and std value
    res.mean_net_err(Noise_S_i,:)     = mean(res.net_err{Noise_S_i});
    res.mean_siminet_err(Noise_S_i,:) = mean(res.siminet_err{Noise_S_i});
    res.mean_wei_err(Noise_S_i,:)     = mean(res.wei_err{Noise_S_i});
    
    res.std_net_err(Noise_S_i,:)      = std(res.net_err{Noise_S_i});
    res.std_siminet_err(Noise_S_i,:)  = std(res.siminet_err{Noise_S_i});
    res.std_wei_err(Noise_S_i,:)      = std(res.wei_err{Noise_S_i});
end
fprintf('++++++++++++++++++++++++++++++++++++++Index1  coefficient bias(CB)+++++++++++++++++++++++++++++\n');
fprintf('          LS     Gau-GCA  Lap-GCA GLap-GCA DLap-GCA\n');
for Noise_S_i = 1:1:max(Value)
    fprintf('CB :');
    for flag_ii = 1:1:length(Method_flag)
        fprintf('     %.2f',res.mean_wei_err(Noise_S_i,flag_ii));
    end
    fprintf('  under the noise %s=%d influenced\n',method_flag{Loc(1)},Noise_Channel(Noise_S_i));
end
fprintf('coefficient bias(CB) lower is better!\n');
fprintf('\n');

fprintf('++++++++++++++++++++++++Index2  number of correctly recovered linkages(NCRL)+++++++++++++++++++++++++\n');

fprintf('            LS      Gau-GCA   Lap-GCA   GLap-GCA  DLap-GCA\n');
for Noise_S_i = 1:1:max(Value)
    fprintf('NCRL :');
    for flag_ii = 1:1:length(Method_flag)
        fprintf('     %.2f',res.mean_net_err(Noise_S_i,flag_ii));
    end
    fprintf('  under the noise %s=%d influenced\n',method_flag{Loc(1)},Noise_Channel(Noise_S_i));
end
fprintf('number of correctly recovered linkages(NCRL) higher is better!\n');