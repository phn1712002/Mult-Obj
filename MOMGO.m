%%
% Người chỉnh sửa       : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 

% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
%% MOMGO
function eva_curve = MOMGO(fobj,is_maximization_or_minization,nVar,lb,ub,SearchX_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo một bầy sói
X=CreateEmptyParticle(SearchX_num);
X=Initialization(X, nVar, ub, lb, fobj);

% Khởi tạo kho lưu trữ
X=DetermineDomination(X);
Archive=GetNonDominatedParticles(X);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

Best = SelectLeader(Archive,betaF);
% MOMGO bắt đầu
for it=1:MaxIt
    
    for i = 1:SearchX_num
        RandomSolution = randperm(SearchX_num, ceil(SearchX_num / 3));
        allPos = GetPosition(X)';
        value_mean = mean(allPos(RandomSolution,:));
        M = X(randi([(ceil(SearchX_num / 3)), SearchX_num])).Position * floor(rand) + value_mean .* ceil(rand);

        % Calculate the vector of coefficients
        a2 = -1 + it * ((-1) / MaxIt);
        u = randn(1, nVar);
        v = randn(1, nVar);

        cofi(1, :) = rand(1, nVar);
        cofi(2, :) = (a2 + 1) + rand;
        cofi(3, :) = a2 .* randn(1, nVar);
        cofi(4, :) = u .* v .^ 2 .* cos((rand * 2) * u);

        A = randn(1, nVar) .* exp(2 - it * (2 / MaxIt));
        D = (abs(X(i).Position) + abs(Best.Position)) * (2 * rand - 1);

        % Update the location
        numLoc = 4;
        Xnew=CreateEmptyParticle(numLoc);
        
        Xnew(1).Position = (ub - lb) * rand + lb;
        Xnew(1).Position = SimpleBounds(Xnew(1).Position, lb, ub);

        Xnew(2).Position = Best.Position - abs((randi(2) * M - randi(2) * X(i).Position) .* A) .* cofi(randi(4), :);
        Xnew(2).Position = SimpleBounds(Xnew(2).Position, lb, ub);

        Xnew(3).Position = (M + cofi(randi(4), :)) + (randi(2) * Best.Position - randi(2) .* X(randi(SearchX_num)).Position) .* cofi(randi(4), :);
        Xnew(3).Position = SimpleBounds(Xnew(3).Position, lb, ub);

        Xnew(4).Position = (X(i).Position - D) + (randi(2) * Best.Position - randi(2) * M) .* cofi(randi(4), :);
        Xnew(4).Position = SimpleBounds(Xnew(4).Position, lb, ub);
        for m=1:numLoc
            Xnew(m).Cost = fobj(X(m).Position);
        end
        
        % Adding new gazelles to the herd
        X = [X; Xnew];
        [X,Archive,G] = AddNewSolToArchive(X,Archive,Archive_size,G,nGrid,alphaF,gammaF);
        [X, ~] = SortPops(X,Archive,betaF);
        Best = X(1);
        plotChart(X, Archive, nCost, 50, is_maximization_or_minization);
    end

    % Update herd
    X = X(1:SearchX_num);

    % Xuất kết quả
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(X)',GetCosts(X)');
        eva_curve = [eva_curve; eva_value];
    end

end
    OutResults(Archive, is_maximization_or_minization);
end


