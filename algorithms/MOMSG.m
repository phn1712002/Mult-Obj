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
%% MOMSG
function eva_curve = MOMSG(fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,c,SAP,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy cá voi
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);
% Khởi tạo kho lưu trữ
Pops=DetermineDomination(Pops);
Archive=GetNonDominatedParticles(Pops);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end
% MOMSG bắt đầu
for it=1:MaxIt
    Best = SelectLeader(Archive, betaF);
    for i=1:Pop_num
            Pops(i).Position=c*Pops(i).Position+rand*(Best.Position - Pops(i).Position);
            Pops(i).Position = SimpleBounds(Pops(i).Position, lb, ub);
            Pops(i).Cost=fobj(Pops(i).Position);
    end
    [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);

    Best = SelectLeader(Archive, betaF);
    for i=1:Pop_num
            r1=floor(1+rand*Pop_num);
            while(r1==i)
                r1=floor(1+rand*Pop_num);
            end

            if Dominates(Pops(i),Pops(r1))
                if rand>SAP
                    Pops(i).Position=Pops(i).Position+rand*(Pops(i).Position-Pops(r1).Position)+rand*(Best.Position-Pops(i).Position);
                else
                    Pops(i).Position=lb+rand*(ub-lb);
                end
            else
                Pops(i).Position = Pops(i).Position+rand*(Pops(r1).Position-Pops(i).Position)+rand*(Best.Position-Pops(i).Position);
            end
            Pops(i).Position = SimpleBounds(Pops(i).Position, lb, ub);
            Pops(i).Cost=fobj(Pops(i).Position);
            
            % Add
            [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
            
            % Plot
            plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    end
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    % Callbacks
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Pops)',GetCosts(Pops)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
