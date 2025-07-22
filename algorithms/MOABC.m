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
%% MOABC
function callback_outputs = MOABC(fobj,is_maximization_or_minization,nVar,lb,ub,Foods_num,LimitTrial,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)


% Khởi tạo khu vực thức ăn của bầy ong
Foods=CreateEmptyParticle(Foods_num);
Foods=Initialization(Foods, nVar, ub, lb, fobj);

% Khởi tạo kho lưu trữ để lưu các giải pháp
Foods=DetermineDomination(Foods);
Archive=GetNonDominatedParticles(Foods);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
callback_outputs = [];
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
        Bee(i).Position = max(Bee(i).Position,lb);
        Bee(i).Position = min(Bee(i).Position,ub);
        Bee(i).Cost=fobj(Bee(i).Position);
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
            Foods(i).Position=lb+(ub-lb)*rand();
            Foods(i).Position = max(Foods(i).Position,lb);
            Foods(i).Position = min(Foods(i).Position,ub);
            Foods(i).Cost=fobj(Foods(i).Position);
            Foods(i).Best.Position=Foods(i).Position;
            Foods(i).Best.Cost=Foods(i).Cost;
            Foods(i).TrialFood = 0;
        end
    end
    
    % Vẽ đồ thị xuất thông tin
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    PlotChart(Foods, Archive, nCost, 50, is_maximization_or_minization);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Foods)',GetCosts(Foods)');
        callback_outputs = [callback_outputs; output_cb];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
