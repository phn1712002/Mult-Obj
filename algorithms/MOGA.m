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
%% MOGA
function eva_curve = MOGA(fobj,is_maximization_or_minization,nVar,lb,ub,Pops_num,Num_Chr,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy cá voi
X=CreateEmptyParticle(Num_Chr);
X=Initialization(X, nVar, ub, lb, fobj);

% Khởi tạo
X=DetermineDomination(X);
Archive=GetNonDominatedParticles(X);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
nCost = size(GetCosts(X), 1);
eva_curve = [];
for IndexPop = 1:1:Pops_num

    if IndexPop ~= 1
        X=CreateEmptyParticle(Num_Chr);
        for i=1:Num_Chr
            X(i).Position=zeros(1,nVar);
            for j=1:nVar
                X(i).Position(1,j)=unifrnd(lb(j),ub(j),1);
                X(i).Cost=fobj(X(i).Position);
                X(i).Best.Position=X(i).Position;
                X(i).Best.Cost=X(i).Cost;
            end
        end
        X = [Archive;X];
        X = X(1:Num_Chr);
    end
    
    for IndexIter = 1:1:MaxIt
        % X Calcation
        if IndexIter ~= 1
            Leader = SelectLeader(Archive, betaF);
            for i=1:Num_Chr
                X(i).Cost=fobj(X(i).Position);
                X(i).Best.Position=Leader.Position;
                X(i).Best.Cost=Leader.Cost;
            end
        end
        
        % Selection 
        [X,Archive,G] = AddNewSolToArchive(X,Archive,Archive_size,G,nGrid,alphaF,gammaF);

        % Natural selection
        [~, Indexc] = SortPops(X, Archive, betaF);

        % Uniform crossover
        for IndexChr = 1:1:Num_Chr
            for IndexX = 1:1:nVar
                Coin = round(rand(1));
                IndexParent = randi(2);
                if(IndexChr ~= Indexc(1) && IndexChr ~= Indexc(2) && Coin == true)
                    X(IndexChr).Position(IndexX) = X(Indexc(IndexParent)).Position(IndexX);
                end
            end
        end

         % Mutation
        for IndexX = 1:1:nVar
            Coin = round(rand(1));
            if(Coin == true)
                X(Indexc(end)).Position(IndexX) = lb(IndexX) + (ub(IndexX) - lb(IndexX))*rand(1);
            end
        end

        disp(['It ' num2str(IndexIter) ' - Pop ' num2str(IndexPop) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
        plotChart(X, Archive, nCost, 50, is_maximization_or_minization);
    end
    % Lưu lại các cá voi có phù hợp vào kho lưu trữ
    % Callbacks
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(X)',GetCosts(X)');
        eva_curve = [eva_curve; eva_value];
    end
end

% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
