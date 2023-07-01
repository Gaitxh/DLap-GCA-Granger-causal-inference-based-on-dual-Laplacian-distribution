# DLap-GCA-Granger-causal-inference-based-on-dual-Laplacian-distribution
  this is a open-access code for DLap-GCA, which detailed description could be reffered to the paper "Granger causal inference based on dual Laplacian distribution and its application to MI- BCI classification"
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  This is an application example of simulation experiments, discussing the impact of outliers on coefficient errors and the consistency of network estimation under varying channel numbers. It is worth noting that most algorithms in this study require the initiation of parallel computing to accelerate computations. The initialization of parallel execution incurs a certain amount of time. If the execution is not initiated from the beginning, as long as the computer is not frozen or the MATLAB display shows it is busy, there is no need to pay attention to it.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


  It is worth noting that the "SimiNet.m" function in this code serves as the implementation of network similarity estimation. You can click on it to view the specific inputs and outputs. However, in this case, it is used for simulation experiments. If you wish to extend it to real experiments for your research paper, you can easily apply slight modifications. We also provide two improved versions: "RDiffNet_Bootstrapping.m" and "RDiffNet_Stableversion.m".

"RDiffNet_Bootstrapping.m" is based on a randomization method for calculating metrics. Each time, it requires inputs of two network pairs. Due to its random nature, there is a certain degree of uncertainty in the metrics.

  On the other hand, "RDiffNet_Stableversion.m" matches any two network pairs from two categories and calculates the corresponding results by iterating through all possible combinations. This version of the code provides greater stability.
  
  There is no doubt that the RDiffNet indicator is based on the paper "SimiNet: a novel method for quantifying brain network similarity", if you want to use it, you need to cite the relevant literature,

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  If you endorse or cite the corresponding conclusions or methods from our article, please cite the paper "Granger causal inference based on dual Laplacian distribution and its application to MI-BCI classification" or any other relevant work as supporting evidence. We would greatly appreciate it.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

attention! if you have any question, I am anticipant receiving your letter, please contact the email:pyli@cqupt.edu.cn or gaitxh@foxmail.com.

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

2023/07/01 00：13

  Not only that, but we've also developed a robust approach to EEG data preprocessing," In "https://github.com/Gaitxh/FCCJIA-An-adaptive-joint-CCA-ICA-method-for-ocular-artifact-removal provides a fast and robust eye electric artifact removal techniques.
  
  In the "https://github.com/Gaitxh/ATICA-An-Adaptive-EOG-Removal-Method-Based-on-Local-Density-" is also a kind of robust eye electric artifact removal techniques, It also provides a threshold calculation strategy. 
  
  Furthermore, we have developed a causal network estimation algorithm based on the Student's t-distribution, which has been applied to emotion research. You can refer to the following link for more details and access the corresponding code support: https://github.com/Gaitxh/GS-GCA-A-novel-robust-Student-s-t-based-Granger-causality-for-EEG-based-brain-network-analysis. I hope these works can help you.
