%%
% Người sáng tạo        : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com
% Tài liệu tham khảo    :
%
% - Multi-Objective Artificial Bee Colony Algorithm (PDF)
%       https://www.mdpi.com/2227-7390/9/24/3187
%       By Nien-Che Yang
% - MOPSO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% - MOGWO (Code)
%       https://www.mathworks.com/matlabcentral/fileexchange/55979-multi-objective-grey-wolf-optimizer-mogwo
%       By Seyedali Mirjalili
% Tất cả nguyên lý dựa trên Single objective Optimization kết hợp 2 thành phần:
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) được dựa
% trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
%% MOABC
function eva_curve = MOABC(Fobj,is_maximization_or_minization,nVar,Lb,Ub,Foods_num,LimitTrial,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)


% Khởi tạo khu vực thức ăn của bầy ong
Foods=CreateEmptyParticle(Foods_num);
Foods=Initialization(Foods, nVar, Ub, Lb, Fobj);

% Khởi tạo kho lưu trữ để lưu các giải pháp
Foods=DetermineDomination(Foods);
Archive=GetNonDominatedParticles(Foods);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOABC bắt đầu vòng lặp
for it = 1:MaxIt
    Bee = Foods;
    % Ong thợ tìm kiếm nguồn thức ăn
    LeaderBee=SelectLeader(Archive,betaF);
    for i = 1:Foods_num
        Bee(i).Position = Foods(i).Position+rand.*(LeaderBee.Position-Foods(i).Position);
        Bee(i).Position = max(Bee(i).Position,Lb);
        Bee(i).Position = min(Bee(i).Position,Ub);
        Bee(i).Cost=Fobj(Bee(i).Position);
        Bee(i).Best.Position=Bee(i).Position;
        Bee(i).Best.Cost=Bee(i).Cost;
    end
    
    % Ong quan sát lưu các nguồn thức ăn tốt nhất
    Foods = Bee;
    [Foods,Archive,G] = AddNewSolToArchive(Foods,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    for i = 1:Foods_num
        if Foods(i).Dominated == 1
            Foods(i).TrialFood = Foods(i).TrialFood + 1;
        else
            Foods(i).TrialFood = Foods(i).TrialFood - 1;
        end
        
        % Ong trinh sát tìm kiếm nguồn thức ăn mới cho ong thợ
        if Foods(i).TrialFood >= LimitTrial
            Foods(i).Position=Lb+(Ub-Lb)*rand();
            Foods(i).Position = max(Foods(i).Position,Lb);
            Foods(i).Position = min(Foods(i).Position,Ub);
            Foods(i).Cost=Fobj(Foods(i).Position);
            Foods(i).Best.Position=Foods(i).Position;
            Foods(i).Best.Cost=Foods(i).Cost;
            Foods(i).TrialFood = 0;
        end
    end
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    plotChart(Foods, Archive, nCost, 50, is_maximization_or_minization);
    
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Foods)',GetCosts(Foods)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
