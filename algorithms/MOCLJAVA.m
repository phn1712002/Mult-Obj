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
%% MOCLJAVA
function callback_outputs = MOCLJAVA(fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);

% Khởi tạo kho lưu trữ để lưu các giải pháp
Pops=DetermineDomination(Pops);
Archive=GetNonDominatedParticles(Pops);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
callback_outputs = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOCLJAVA bắt đầu vòng lặp
for it = 1:MaxIt
    [Pops, ~] = SortPops(Pops, Archive, betaF);
    Best = Pops(1);
    Worst = Pops(end);
    for i=1:Pop_num
        a=randperm(Pop_num,1);
        b=randperm(Pop_num,1);
        while (a==b || a==i ||b==i)
            a=randperm(Pop_num,1);
            b=randperm(Pop_num,1);
        end
        fi=rand;
        if fi<=1/3
            Pops(i).Position=(Pops(i).Position)+randn.*(Best.Position-abs(Pops(i).Position))-randn.*(Worst.Position-abs(Pops(i).Position)); 
        elseif fi>=2/3
            Pops(i).Position=Pops(i).Position+rand(1,nVar).*(Best.Position-(Pops(i).Position))+rand(1,nVar).*(Pops(a).Position-Pops(b).Position);
        else
            allPos = GetPosition(Pops)';
            value_mean = mean(allPos);
            Pops(i).Position=(Pops(i).Position)+randn.*(Best.Position-abs(Pops(i).Position))-randn.*(value_mean-abs(Pops(i).Position));
        end

        Pops(i).Position = SimpleBounds(Pops(i).Position, lb, ub);
        Pops(i).Cost = fobj(Pops(i).Position);
        
        [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
        PlotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    end
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Pops)',GetCosts(Pops)');
        callback_outputs = [callback_outputs; output_cb];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
