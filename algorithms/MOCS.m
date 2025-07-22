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
%% MOCS
function eva_curve = MOCS(fobj,is_maximization_or_minization,nVar,lb,ub,nestsCuckoos_num,pa,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo một quần thể chim và tổ chim, coi tổ chim và chim Cuckoo là như nhau
nestsCuckoos=CreateEmptyParticle(nestsCuckoos_num);
nestsCuckoos=Initialization(nestsCuckoos, nVar, ub, lb, fobj);

% Khởi tạo kho lưu trữ các giải pháp
nestsCuckoos=DetermineDomination(nestsCuckoos);
Archive=GetNonDominatedParticles(nestsCuckoos);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOCS bắt đầu 
for it=1:MaxIt

    LeaderNestsCuckoos=SelectLeader(Archive,betaF);
    
    beta=3/2;
    sigma=(gamma(1+beta)*sin(pi*beta/2)/(gamma((1+beta)/2)*beta*2^((beta-1)/2)))^(1/beta);
    for j=1:nestsCuckoos_num
        % Thực hiện chuyến bay Levy
        s=nestsCuckoos(j).Position;
        u=randn(size(s))*sigma;
        v=randn(size(s));
        step=u./abs(v).^(1/beta);
        stepsize=0.01*step.*(s-LeaderNestsCuckoos.Position);
        s=s+stepsize.*randn(size(s));
        nestsCuckoos(j).Position=SimpleBounds(s,lb,ub);
        nestsCuckoos(j).Cost=fobj(nestsCuckoos(i).Position);
        nestsCuckoos(j).Best.Position=nestsCuckoos(j).Position;
        nestsCuckoos(j).Best.Cost=nestsCuckoos(j).Cost;
        % Thực hiện phá hủy tổ Pa
        if rand > pa
            r1 = floor(nestsCuckoos_num*rand()+1);
            r2 = floor(nestsCuckoos_num*rand()+1);
            stepsize=rand*(nestsCuckoos(r1).Position-nestsCuckoos(r2).Position);
            nestsCuckoos(j).Position=nestsCuckoos(j).Position+stepsize;
            nestsCuckoos(j).Position=SimpleBounds(nestsCuckoos(j).Position,lb,ub);
        end 
    end
    % Lưu lại những giải pháp tốt nhất
    [nestsCuckoos,Archive,G] = AddNewSolToArchive(nestsCuckoos,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    plotChart(nestsCuckoos, Archive, nCost, 50, is_maximization_or_minization);
    
    % Callbacks
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(nestsCuckoos)',GetCosts(nestsCuckoos)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end




