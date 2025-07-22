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
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization  
%% MODOA
function eva_curve = MODOA (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,P,Q,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy 
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);
VarSize = [1 nVar];
beta1 = -2 + 4 * rand(); 
beta2 = -1 + 2 * rand();
naIni = 2; % minimum number of dingoes that will attack
naEnd = Pop_num / naIni; % maximum number of dingoes that will attack
na = round(naIni + (naEnd - naIni) * rand()); % number of dingoes that will attack, used in Attack.m Section 2.2.1: Group attack

% Khởi tạo kho lưu trữ
Pops=DetermineDomination(Pops);
Archive=GetNonDominatedParticles(Pops);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MODOA bắt đầu
for it=1:MaxIt
    [Pops,~] = SortPops(Pops, Archive, betaF);
    Best = Pops(1);
    Worts = Pops(end);
    survival = SurvivalRate(Pops, Best, Worts); % Section 2.2.4 Dingoes'survival rates
    for r = 1:Pop_num
        sumatory = 0;
        if rand() < P % If Hunting?
            sumatory = Attack(Pop_num, na, GetPosition(Pops)', r); % Section 2.2.1, Strategy 1: Part of Eq.2

            if rand() < Q % If group attack?
                Pops(r).Position = beta1 * sumatory - Best.Position; % Strategy 1: Eq.2
            else %  Persecution
                r1 = round(1 + (Pop_num - 1) * rand()); %
                Pops(r).Position = Best.Position + beta1 * (exp(beta2)) * ((Pops(r1).Position - Pops(r).Position)); % Section 2.2.2, Strategy 2:  Eq.3
            end

        else % Scavenger
            r1 = round(1 + (Pop_num - 1) * rand());
            Pops(r).Position = (exp(beta2) * Pops(r1).Position - ((-1) ^ getBinary()) * Pops(r).Position) / 2; % Section 2.2.3, Strategy 3: Eq.4
        end

        if mean(survival(r)) <= 0.3 % Section 2.2.4, Algorithm 3 - Survival procedure
            band = 1;
            while band
                r1 = round(1 + (Pop_num - 1) * rand());
                r2 = round(1 + (Pop_num - 1) * rand());

                if r1 ~= r2
                    band = 0;
                end
            end
            Pops(r).Position = Best.Position + (Pops(r1).Position - ((-1) ^ getBinary()) * Pops(r2).Position) / 2; % Section 2.2.4, Strategy 4: Eq.6
        end
        % Return back the search agents that go beyond the boundaries of the search space .
        Pops(r).Position = SimpleBounds(Pops(r).Position,lb,ub);
        % Evaluate new solutions
        Pops(r).Cost = fobj(Pops(r).Position);
        % Lưu lại các cá voi có phù hợp vào kho lưu trữ
        [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
        plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    end
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Pops)',GetCosts(Pops)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
