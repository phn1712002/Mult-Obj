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
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) được dựa
% trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimizationn  
%% MOGWS
function eva_curve = MOGWS(fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,options,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
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

luciferin_temp = options.L0*ones(Pop_num, nCost);       % Initialising the luciferin
decision_range = options.r0*ones(Pop_num, 1);  % Initialising the decision range

% MOGWS bắt đầu
for it=1:MaxIt
    % Updating the luciferin
    luciferin_temp = (1-options.rho)*luciferin_temp + options.y*GetCosts(Pops)';
    luciferin = minCostRandom(luciferin_temp', nCost);

    % Moving the Glow-worms
    for ii = 1:Pop_num
        curX = Pops(ii).Position;
        curLuciferin = luciferin(ii);
        distFromI = EuclidDistance(GetPosition(Pops)',repmat(curX,Pop_num,1));
        Ni = find((distFromI < decision_range(ii)) & (luciferin > curLuciferin));
        if isempty(Ni)  % If no glow-worm exists within its local range
            Pops(ii).Position = curX;
        else
            localRangeL = luciferin(Ni);
            localRangeX = Pops(Ni);

            probs = (localRangeL - curLuciferin)/sum(localRangeL - curLuciferin);
            selectedPos = RouletteWheelSelection(probs);
            selectedX = localRangeX(selectedPos).Position;
            Pops(ii).Position = curX + options.s*(selectedX - curX)/EuclidDistance(selectedX,curX);
        end
        % Return back the search agents that go beyond the boundaries of the search space
        Pops(ii).Position=SimpleBounds(Pops(ii).Position,lb,ub);
        Pops(ii).Cost=fobj(Pops(ii).Position);
        neighborSz = length(Ni);
        decision_range(ii) = min([options.rs,max([0,decision_range(ii) + options.B*(options.nt-neighborSz)])]);
    end
    [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
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

