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
%% MOAEBO
function callback_outputs = MOAEBO(fobj,is_maximization_or_minization,nVar,lb,ub,Pops_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo bầy 
Pops=CreateEmptyParticle(Pops_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);

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

% Sắp xếp dân số Ramdon
[Pops, ~] = SortPops(Pops,Archive,betaF);

% MOAEBO bắt đầu
Matr=[1,nVar];
Pops_new=CreateEmptyParticle(Pops_num);
for it=1:MaxIt
    
    r1=rand;
    a=(1-it/MaxIt)*r1;
    xrand=rand(1,nVar).*(ub-lb)+lb;
    Pops_new(1).Position=(1-a)*Pops(Pops_num).Position+a*xrand;

    u=randn(1,nVar);
    v=randn(1,nVar);
    C=1/2*u./abs(v);
    Pops_new(2).Position=Pops(2).Position+C.*(Pops(2).Position-Pops_new(1).Position);

    for i=3:Pops_num
        u=randn(1,nVar);
        v=randn(1,nVar); 
        C=1/2*u./abs(v);
        r=rand;
        
        if r<1/3
            Pops_new(i).Position=Pops(i).Position+C.*(Pops(i).Position-Pops_new(1).Position);
            
        else
            if  1/3<r && r<2/3
                Pops_new(i).Position=Pops(i).Position+C.*(Pops(i).Position - Pops(randi([2 i-1])).Position);
            else
                r2=rand;
                Pops_new(i).Position=Pops(i).Position+C.*(r2.*(Pops(i).Position - Pops_new(1).Position)+(1-r2).*(Pops(i).Position-Pops(randi([2 i-1])).Position));
            end
        end
    end

    for i=1:Pops_num
        Pops_new(i).Position=SpaceBound(Pops_new(i).Position,ub,lb);
        Pops_new(i).Cost = fobj(Pops_new(i).Position);
        if Pops_new(i).Cost < Pops(i).Cost
            Pops(i).Cost=Pops_new(i).Cost;
            Pops(i).Position=Pops_new(i).Position;
        end
    end
    
    Leader=SelectLeader(Archive,betaF);

    for i=1:Pops_num
        
        r3=rand;
        Ind=round(rand)+1;
        e=r3*randi([1 2])-1;
        h = 2*r3-1;
        D = 3*randn(1,Matr(Ind));
        
            
        Pops_new(i).Position=Leader.Position+D.*(e*Leader.Position-h*Pops(i).Position);
        Pops_new(i).Position=SpaceBound(Pops_new(i).Position,ub,lb);
    end

    for i=1:Pops_num
        Pops_new(i).Position=SpaceBound(Pops_new(i).Position,ub,lb);
        Pops_new(i).Cost=fobj(Pops_new(i).Position);
        if Pops_new(i).Cost<Pops(i).Cost
            Pops(i).Cost=Pops_new(i).Cost;
            Pops(i).Position=Pops_new(i).Position;
        end
    end

    % Sắp xếp dân số Ramdon
    [Pops,~] = SortPops(Pops,Archive,betaF);

    % Lưu lại các cá voi có phù hợp vào kho lưu trữ
    [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
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
