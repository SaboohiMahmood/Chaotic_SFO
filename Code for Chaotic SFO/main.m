
% Developer: Saboohi Mahmood
% Contact Info: saboohinaeem@gmail.com
% Latest version used to 500 iterations with 25 runs
% Impact of popular chaotic maps Research paper

clc;
clear;
close all;

%% Parameters of PSO

params.MaxIt = 500;     % Maximum Number of Iterations
params.sfPop = 30;      % Sailfish Population, pp = 0.1
params.A = 4.0;             % AP decreases from A to 0
params.epsilon = 0.001;          % for 100000, 10000, 1000 iterations
                                 % --> 0.000005, 0.00005, 0.0005
                                 % 2000 --> 0.00025
params.PP = 0.3;                 % percentage population
params.ShowIterInfo = false;     % Flag for Showing Iteration Informatin

%% Calling SFO

%Basic SFO with Chaotic population (10 maps)
col = 'A';
colNo = 1;
filename = 'ChaoticSFO_results.xlsx';

for map=1:10
col = 'A';       %it is used for storing into Excel, you may remove if not saving
colNo = 1;       %it is used for storing into Excel, you may remove if not saving

for f=1:23

    [lb,ub,dim,fobj,min] = Get_Functions_details(strcat('F',int2str(colNo)));
    problem.CostFunction = fobj;                % Cost Function
    problem.nVar = dim;                         % Number of Unknown (Decision) Variables
    problem.VarMin =  lb;                       % Lower Bound of Decision Variables
    problem.VarMax =  ub;                       % Upper Bound of Decision Variables
    problem.min =  min;                       % min value of F

    z = zeros(500,25);		%Store values for 500 iterations and 25 runs
    savetime = zeros(1,25);	%Runtime of each run  
    
    for i=1:25
        
        tic
        [sf, s, GlobalBest] = initSFOchaos(problem, params,map);   
        sfo_out = BasicSFO(problem, params, sf, s, GlobalBest);
        savetime(:,i) = toc;
        z(:,i) = sfo_out;
    end

%Save into Excel    
writematrix(z,filename,'Sheet',strcat(strcat(strcat('F',int2str(colNo)),'_SFO'),strcat('_M',int2str(map))) );
writematrix(savetime,filename,'Sheet',strcat('Runtime_SFO',strcat('_M',int2str(map))),'Range',strcat('A',int2str(colNo)));
     
    colNo=colNo+1;
end  %end f 
end  % end map