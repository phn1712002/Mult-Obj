%%
% Người sáng tạo        : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com
% Tài liệu tham khảo    :
% - MOPSO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% - MOGWO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/55979-multi-objective-grey-wolf-optimizer-mogwo
%       By Seyedali Mirjalili
% Tất cả nguyên lý dựa trên Single objective Optimization kết hợp 2 thành phần:
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
%% MOTLB
function eva_curve = MOSA(Fobj,is_maximization_or_minization,nVar,Lb,Ub,nSol,MaxIt,MaxSubIt,T0,alpha,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy chim
Sol=CreateEmptyParticle(nSol);
Sol=Initialization(Sol, nVar, Ub, Lb, Fobj);

% Khởi tạo kho lưu trữ để lưu các giải pháp
Sol=DetermineDomination(Sol);
Archive=GetNonDominatedParticles(Sol);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% Intialize Temp.
T = T0;

% MOTLB bắt đầu vòng lặp
for it = 1:MaxIt
    
    for subit = 1:MaxSubIt

        newSol = CreateEmptyParticle(nSol);

        for index=1:nSol
            newSol(index).Position = CreateNeighbor(Sol(index).Position);
            newSol(index).Position = SimpleBounds(newSol(index).Position, Lb, Ub);
            newSol(index).Cost = Fobj(newSol(index).Position);
    
            if Dominates(newSol(index), Sol(index)) % If NEWSOL is better than SOL
                Sol(index) = newSol(index);
            else % If NEWSOL is NOT better than SOL
    
                DELTA = (newSol(index).Cost - Sol(index).Cost) / Sol(index).Cost;
    
                P = exp(-DELTA / T);
    
                if rand <= P
                    Sol(index) = newSol(index);
                end
            end
        end
        

    end
    % Update Temp.
    T = alpha * T;

    % Add
    [Sol,Archive,G] = AddNewSolToArchive(Sol,Archive,Archive_size,G,nGrid,alphaF,gammaF);

    % Plot
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    plotChart(Sol, Archive, nCost, 50, is_maximization_or_minization);
    % Callbacks
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Sol)',GetCosts(Sol)');
        eva_curve = [eva_curve; eva_value];
    end

end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end




