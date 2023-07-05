clc;clear all;close all;
addpath(genpath(pwd))
Experience_Time = 50;

Method_flag = [1,2,3,4,5]; % selected the calculation methods which would run in parallel
%Method_flag=[1],least square (LS), the most traditional algorithm within L2-norm space
%Method_flag=[2],Gau-GCA, which assumed that coefficients and noise both follow Gaussian distribution
%Method_flag=[3],Lap-GCA, which assumed that coefficients follow laplace and noise follow
%Gaussian distribution, this method achieved sparse estimation of
%coefficients but cannot suppress noise.
%Method_flag=[4],GLap-GCA, which assumed that coefficients follow Gaussian and noise follow
%laplace distribution, this method realized the noise suppression effect
%Method_flag=[5],DLap-GCA, which assumed that coefficients and noise both follow Laplace
%distribution,this method would achieved the best performance on network
%estimation.

Noise_Fre       = [.003];% fixed the value of noise frequency as 0.3%
Noise_Intensity = [3];% fixed the value of noise intensity as 3
Noise_Channel   = [1 2 3 4 5];% discuss the influence of outliers on the number of channels
NLAGS = 3; % model order
load('simu_data');% Load the stored simu data
for Noise_S_i = 1:1:5
    for Cycle_ii=1:Experience_Time
        sim.X       = data.iniX{1, Noise_S_i}(:,:,Cycle_ii);
        sim.noise_X = data.noiseX{1, Noise_S_i}(:,:,Cycle_ii);
        tic
        for flag_ii = 1:1:length(Method_flag)
            % calculate causal networks and return network consistency error 
            % and network similarity results by methods
            ret = Net_Esitmate(sim,Method_flag(flag_ii),NLAGS);
            
            % save the relevant results
            res.net_err{Noise_S_i}(Cycle_ii,flag_ii)     = ret.sumnet_err;
            res.siminet_err{Noise_S_i}(Cycle_ii,flag_ii) = ret.siminet_err;
            res.wei_err{Noise_S_i}(Cycle_ii,flag_ii)     = ret.wei_err;
            res.iniGC{Noise_S_i,flag_ii}(:,:,Cycle_ii)   = ret.Ini_GC;
            res.estiGC{Noise_S_i,flag_ii}(:,:,Cycle_ii)  = ret.esti_GC;
        end
        T = toc;
        fprintf(['Channel Noise Time:%d, Cycle Time %d, Spend Time: %.2f s\n'],...
            Noise_S_i,Cycle_ii,T);
    end
    res.mean_net_err(Noise_S_i,:)     = mean(res.net_err{Noise_S_i});
    res.mean_siminet_err(Noise_S_i,:) = mean(res.siminet_err{Noise_S_i});
    res.mean_wei_err(Noise_S_i,:)     = mean(res.wei_err{Noise_S_i});
end
fprintf('++++++++++++++++++++++++++++++++++++++Index1  coefficient bias(CB)+++++++++++++++++++++++++++++\n');
fprintf('          LS     Gau-GCA  Lap-GCA GLap-GCA DLap-GCA\n');
for Noise_S_i = 1:1:5
    fprintf('CB :');
    for flag_ii = 1:1:length(Method_flag)
        fprintf('     %.2f',res.mean_wei_err(Noise_S_i,flag_ii));
    end
    fprintf('  under the noise Channel=%d influenced\n',Noise_Channel(Noise_S_i));
end
fprintf('coefficient bias(CB) lower is better!\n');
fprintf('\n');

fprintf('++++++++++++++++++++++++Index2  number of correctly recovered linkages(NCRL)+++++++++++++++++++++++++\n');

fprintf('            LS      Gau-GCA   Lap-GCA   GLap-GCA  DLap-GCA\n');
for Noise_S_i = 1:1:5
    fprintf('NCRL :');
    for flag_ii = 1:1:length(Method_flag)
        fprintf('     %.2f',res.mean_net_err(Noise_S_i,flag_ii));
    end
    fprintf('  under the noise Channel=%d influenced\n',Noise_Channel(Noise_S_i));
end
fprintf('number of correctly recovered linkages(NCRL) higher is better!\n');
