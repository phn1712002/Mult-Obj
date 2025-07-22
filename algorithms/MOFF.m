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
%% MOFF
function callback_outputs = MOFF(fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,gamma,beta0,alpha,alpha_damp,delta,m,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo bầy 
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);
delta = delta * (ub - lb);
VarSize = [1 nVar];
if isscalar(lb) && isscalar(ub)
    dmax = (ub - lb) * sqrt(nVar);
else
    dmax = norm(ub - lb);
end

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

% MOFF bắt đầu
for it=1:MaxIt
    newSol=Pops;
    for i = 1:Pop_num
        for j = (i+1):Pop_num
            rij = norm(Pops(i).Position - Pops(j).Position) / dmax;
            beta = beta0 * exp(-gamma * rij ^ m);
            e = delta .* randn(VarSize);
    
            newSol(i).Position = Pops(i).Position ...
                + beta * rand(VarSize) .* (Pops(j).Position - Pops(i).Position) ...
                + alpha * e;
    
            newSol(i).Position = SimpleBounds(newSol(i).Position,lb,ub);
            newSol(i).Cost = fobj(newSol(i).Position);
        end
    end

    
    % Lưu lại các sol có phù hợp vào kho lưu trữ
    [newSol,Archive,G] = AddNewSolToArchive(newSol,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    % Gộp
    Pops = [newSol; Pops];

    % Cắt ngắn
    [Pops,~] = SortPops(Pops,Archive,betaF);
    Pops = Pops(1:Pop_num);

    % Hệ số đột biến
    alpha = alpha * alpha_damp;

    % Vẽ đồ thị và xuất thông tin
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Pops)',GetCosts(Pops)');
        callback_outputs = [callback_outputs; output_cb];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
