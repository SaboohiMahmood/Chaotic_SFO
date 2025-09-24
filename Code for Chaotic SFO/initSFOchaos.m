function [sf, s, GlobalBest] = initSFOchaos(problem, params, cNum1)

    %% Problem Definiton
    
    CostFunction = problem.CostFunction;  % Cost Function
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables
    VarMin = problem.VarMin;	% Lower Bound of Decision Variables
    VarMax = problem.VarMax;    % Upper Bound of Decision Variables

    %% Parameters of SFO

    sfPop = params.sfPop;           % Population Size (Swarm Size)
    sPop = sfPop / params.PP;            % pp = 0.06
    
%% Initialization
    % The Sardine Position and cost
    empty_sardine.Position = [];
    empty_sardine.Cost = [];
    % Sailfish population and cost
    empty_sf.Position = [];
    empty_sf.Cost = [];
    
    % Create Population Array
    sf = repmat(empty_sf, sfPop, 1);             % sailfish population 
    s = repmat(empty_sardine, sPop, 1);          % sardine population 

    % Initialize Global Best
    GlobalBest.sf.Cost = inf;
    GlobalBest.s.Cost = inf;

    cNum = chaos(cNum1,0.7,nVar*sfPop);        % chaotic number, for logistic map initial value is 0.7  
%     plot(cNum);
    % Initialize Sailfish population 
    for i=1:sfPop

        for j = 1:nVar
            % Generate Random Solution
            sf(i).Position(j) = VarMin + cNum(((i-1)*nVar)+j) * (VarMax - VarMin);
        end 
        % Evaluation of Cost function
        sf(i).Cost = CostFunction(sf(i).Position);
                           
        % Update Global Best
        if sf(i).Cost < GlobalBest.sf.Cost
                GlobalBest.sf = sf(i);
         end

    end

    cNum3 = chaos(cNum1,0.7,nVar*sPop);        % chaotic number 
    
    % Initialize Sardine population 
    for i=1:sPop
        
         for j = 1:nVar
            % Generate Random Solution
            s(i).Position(j) = VarMin + cNum3(((i-1)*nVar)+j) * (VarMax - VarMin);
         end
        % Evaluation
        s(i).Cost = CostFunction(s(i).Position);

        % Update Global Best
        if s(i).Cost < GlobalBest.s.Cost
            GlobalBest.s = s(i);
        end
    end
    