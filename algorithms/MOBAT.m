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
%% MOBAT
function callback_outputs = MOBAT (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,Fmax,Fmin,alpha,gamma,ro,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo bầy 
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);
r = rand(Pop_num, 1);     % Tốc độ phát xung cho mỗi con dơi
A = rand(Pop_num, 1);     % Lớn tiếng cho mỗi con dơi


% Khởi tạo kho lưu trữ
Pops=DetermineDomination(Pops);
Archive=GetNonDominatedParticles(Pops);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
callback_outputs = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOBAT bắt đầu
for it=1:MaxIt
    Best = SelectLeader(Archive, betaF);

    for ii = 1:Pop_num
        Pops(ii).Frequency = Fmin + (Fmax - Fmin) * rand; % Chọn ngẫu nhiên tần số
        Pops(ii).Velocity = Pops(ii).Velocity + (Pops(ii).Position - Best.Position) * Pops(ii).Frequency; % Cập nhật vận tốc
        Pops(ii).Position = Pops(ii).Position + Pops(ii).Velocity; % Cập nhật vị trí
        Pops(ii).Position = SimpleBounds(Pops(ii).Position, lb, ub);

        % Kiểm tra tình trạng với r
        if rand > r(ii)
            eps = -1 + (1 - (-1)) * rand;
            Pops(ii).Position = Best.Position + eps * mean(A);
            Pops(ii).Position = SimpleBounds(Pops(ii).Position, lb, ub);
        end
               
        Pops(ii).Cost = fobj(Pops(ii).Position);
        % Cập nhật nếu giải pháp được cải thiện, hoặc không quá ồn ào
        if rand < A(ii)
            A(ii) = alpha * A(ii);
            r(ii) = ro * (1 - exp(-gamma * it));
        end
    end
    [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    % Vẽ đồ thị và xuất thông tin
    plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
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
