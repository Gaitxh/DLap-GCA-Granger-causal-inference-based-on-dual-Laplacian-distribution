 function ret= Net_Esitmate(sim,flag,NLAGS)
 
Ini_X = sim.X;
Noise_X = sim.noise_X;

Ini_GC = [0,0,0,0,0;1,0,1,0,0;1,1,0,0,0;1,0,0,0,1;0,0,0,1,0];
GCAIni_GC = Ini_GC;
Ini_GC(isnan(Ini_GC)) = 0;Ini_GC(Ini_GC>0) = 1; 

ret = GrangerNet_Estimate(Noise_X,flag,NLAGS);
Noise_GC = ret.GC2;
GCANoise_GC = Noise_GC;
Noise_GC(isnan(Noise_GC)) = 0;Noise_GC(Noise_GC>0) = 1; 

Sum_Net_Error = GC_change(Ini_GC,Noise_GC);% 格兰杰因果改变量
siminet_error = SimiNet(Ini_GC,Noise_GC);
wei_error = WeiErrcal(Noise_X,NLAGS,flag);

ret.sumnet_err = Sum_Net_Error;
ret.siminet_err = siminet_error;
ret.wei_err = wei_error;
ret.Ini_GC = Ini_GC;
ret.esti_GC = ret.PR;
end