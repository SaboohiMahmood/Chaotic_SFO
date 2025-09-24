function [sf, s, GlobalBest] = initSFO(problem, params)

    %% Problem Definiton
    
    CostFunction = problem.CostFunction;  % Cost Function
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables
    VarSize = [1 nVar];         % Matrix Size of Decision Variables
    VarMin = problem.VarMin;	% Lower Bound of Decision Variables
    VarMax = problem.VarMax;    % Upper Bound of Decision Variables

    %% Parameters of SFO

    sfPop = params.sfPop;           % Population Size (Swarm Size)
    sPop = int32(sfPop / params.PP);            % pp = 0.06

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

    % Initialize Sailfish population, Random Solution is generated in Basic SFO 
    for i=1:sfPop
        % Generate Random Solution
        sf(i).Position = rand(VarSize).*(VarMax-VarMin)+VarMin;
%         sf(i).Position = unifrnd(VarMin, VarMax, VarSize);
        % Evaluation of Cost function
        sf(i).Cost = CostFunction(sf(i).Position);
                           
        % Update Global Best
        if sf(i).Cost < GlobalBest.sf.Cost
                GlobalBest.sf = sf(i);
        end
    end

    % Initialize Sardine population 
    for i=1:sPop
     % Generate Random Solution
        s(i).Position = rand(VarSize).*(VarMax-VarMin)+VarMin;
        % Evaluation
        s(i).Cost = CostFunction(s(i).Position);

        % Update Global Best
        if s(i).Cost < GlobalBest.s.Cost
            GlobalBest.s = s(i);
        end

    end
    