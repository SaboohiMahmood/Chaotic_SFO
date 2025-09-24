
% Developer: Saboohi Mahmood
% Contact Info: saboohinaeem@gmail.com
% Updated on 21 Feb 2023
% It is the original SFO algorithm. when using it. 

function out = BasicSFO(problem, params, sf, s, GlobalBest)

    %% Problem Definiton
    CostFunction = problem.CostFunction;  % Cost Function
    nVar = problem.nVar;        % Number of Unknown (Decision) Variables
    VarMin = problem.VarMin;	% Lower Bound of Decision Variables
    VarMax = problem.VarMax;    % Upper Bound of Decision Variables
    FuncMin = problem.min;
    VarSize = [1 nVar]; 
    
   %% Parameters of SFO
    MaxIt = params.MaxIt;           % Maximum Number of Iterations/Genartions
    sfPop = params.sfPop;           % Sailfish Population Size (Swarm Size)
    sPop = sfPop / params.PP;            % pp = 0.3
    A = params.A;                   % A=4
    epsilon = params.epsilon;       % epsilon = 0.001
    ShowIterInfo = params.ShowIterInfo;    % The Flag for Showing Iteration Information
   
    %% Main Loop of SFO

    % Array to Hold Best Cost Value on Each Iteration
    BestCosts = zeros(MaxIt, 1);

    % sN is decreased in each iteration, Sardine population=sN=sPop
    sN = sPop;

    for it=1:MaxIt
	% Initial value of PD ... Eq 8
        PD = 1 - (sfPop / double(sfPop+sN));              
        
	% update Sailfish, first loop in algo
        for i=1:sfPop
            lambda = (2 * unifrnd(0, 1) * PD) - PD;     % Lambda based on PD . Eq 7
            
	    % Update Sailfish position based on Eq. 6
            sf(i).Position = GlobalBest.sf.Position - lambda.* ( (unifrnd(0,1).* ...
                ((GlobalBest.sf.Position + GlobalBest.s.Position) / 2) - sf(i).Position) ) ;
            
	    % Apply Limits
            sf(i).Position = max(sf(i).Position, VarMin);
            sf(i).Position = min(sf(i).Position, VarMax);

            % Evaluation of Cost for SF
            sf(i).Cost = CostFunction(sf(i).Position);
        end
        
        AP = A * (1 - (2 * it * epsilon));   %Attack power

        if AP < 0.5
            % find alpha beta and update selected sardine  
            alpha = ceil(sN * AP);
            beta = ceil(nVar * AP); 

            selected_alpha = randperm(sN,alpha);        %randomly select number of alpha sardines
            selected_beta = randperm(nVar,beta);        %randomly select number of variables within each sardine
            r = unifrnd(0,1);
            % update selected sardine 
            for k=1:length(selected_alpha)
                for l=1:length(selected_beta)
                        s(selected_alpha(k)).Position(selected_beta(l)) = ...
                            (r.* (GlobalBest.sf.Position(selected_beta(l)) - ... 
                            s(selected_alpha(k)).Position(selected_beta(l)) + AP)); 
                end
            end     
        else 

            % else when AP>=0.5, update all sardine 
            for j=1:sN
                s(j).Position = (unifrnd(0,1).* (GlobalBest.sf.Position - s(j).Position + AP)); 
            end     
        end 
        
        % update cost of all sardine 
        for j=1:sN
                % Apply Limits
                s(j).Position = max(s(j).Position, VarMin);
                s(j).Position = min(s(j).Position, VarMax);
            
                %update cost of each sardine 
                s(j).Cost = CostFunction(s(j).Position);
        end
        
        if sN>0     % sN => number of sardines
        index = 1;  % for sardine index
        for i=1:sfPop  
            if index > sN    % all sardines might have hunted already
                 break;
            end
                % if a corresponding Sardine has higher fitness then replace with sf
                if s(index).Cost < sf(i).Cost
                    sf(i) = s(index);
                    s(index).Position = [];         %remove hunted sardine from sPop
                    s(index).Cost = 0;
                    s(index)=[];
                    sN = sN-1;   %one sardine removed so decrease sardine population by one
                    break;       %one is hunted so break the loop
                end
            index = index +1;
        end % end for 
        end %end if 
        
        
        %Update Best Sardine
        for i=1:sN
            if s(i).Cost < GlobalBest.s.Cost 
                GlobalBest.s = s(i);
            end
        end               
        
        %Update Best Sailfish
        for i=1:sfPop
            if sf(i).Cost < GlobalBest.sf.Cost 
                GlobalBest.sf = sf(i);
            end
        end
        
        % Store the Best Sailfish into Best Cost Value
        BestCosts(it) = GlobalBest.sf.Cost;
        
        % Display Iteration Information
        if ShowIterInfo
            disp(['Iteration ' num2str(it) ' sN: ' num2str(sN) ': Global Best=' num2str(GlobalBest.sf.Cost) ': AP=' num2str(AP)]);
        end
        
        if GlobalBest.sf.Cost-FuncMin == 0.0 
            BestCosts(it:MaxIt) = GlobalBest.sf.Cost;
            break;
        end 
    end
   
    out = BestCosts;              %output parameter   
end