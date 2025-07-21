%%
% Người sáng tạo        : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization  
%% MOPDO
function eva_curve = MOPDO(fobj,is_maximization_or_minization,nVar,lb,ub,X_num,rho,epsPD,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy 
X=CreateEmptyParticle(X_num);
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

% MOPDO bắt đầu
for it=1:MaxIt
    Best = SelectLeader(Archive, betaF);
    if mod(it, 2) == 0
        mu = -1;    
    else
        mu = 1;
    end
    
    DS = 1.5 * randn * (1 - it / MaxIt) ^ (2 * it / MaxIt) * mu; % Digging strength
    PE = 1.5 * (1 - it / MaxIt) ^ (2 * it / MaxIt) * mu; % Predator effect
    RL = Levym(X_num, nVar, 1.5); % Levy random number vector
    TPD = repmat(Best.Position, X_num, 1); %Top PD

    for i = 1:X_num
        for j = 1:nVar
            cpd = rand * ((TPD(i, j) - X(randi([1 X_num])).Position(j))) / ((TPD(i, j)) + eps);
            P = rho + (X(i).Position(j) - mean(X(i).Position)) / (TPD(i, j) * (ub(j) - lb(j)) + eps);
            eCB = Best.Position(j) .* P;

            if (it < MaxIt / 4)
                X(i).Position(j) = Best.Position(j) - (eCB * epsPD - cpd * RL(i, j)) ;
            elseif (it < 2 * MaxIt / 4 && it >= MaxIt / 4)
                X(i).Position(j) = Best.Position(j) * X(randi([1 X_num])).Position(j) * DS * RL(i, j);
            elseif (it < 3 * MaxIt / 4 && it >= 2 * MaxIt / 4)
                X(i).Position(j) = Best.Position(j) * PE * rand;
            else
                X(i).Position(j) = Best.Position(j) - eCB * eps - cpd * rand;
            end
            
        end
        X(i).Position = SimpleBounds(X(i).Position, lb, ub);
        X(i).Cost = fobj(X(i).Position); 
    end

    % Lưu lại các cá voi có phù hợp vào kho lưu trữ
    [X,Archive,G] = AddNewSolToArchive(X,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    plotChart(X, Archive, nCost, 50, is_maximization_or_minization);
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(X)',GetCosts(X)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
