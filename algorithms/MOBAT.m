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
function eva_curve = MOBAT (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,Fmax,Fmin,alpha,gamma,ro,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy 
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);
r = rand(Pop_num, 1);     %pulse emission rate for each BAT
A = rand(Pop_num, 1);     %loudness for each BAT


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

% MOBAT bắt đầu
for it=1:MaxIt
    Best = SelectLeader(Archive, betaF);

    for ii = 1:Pop_num
        Pops(ii).Frequency = Fmin + (Fmax - Fmin) * rand; %randomly chose the frequency
        Pops(ii).Velocity = Pops(ii).Velocity + (Pops(ii).Position - Best.Position) * Pops(ii).Frequency; %update the velocity
        Pops(ii).Position = Pops(ii).Position + Pops(ii).Velocity; %update the BAT position

        % Apply simple bounds/limits
        Pops(ii).Position = SimpleBounds(Pops(ii).Position, lb, ub);

        %check the condition with r
        if rand > r(ii)
            % The factor 0.001 limits the step sizes of random walks
            %               x(ii,:)=Best.Position+0.001*randn(1,dim);
            eps = -1 + (1 - (-1)) * rand;
            Pops(ii).Position = Best.Position + eps * mean(A);
            % Apply simple bounds/limits
            Pops(ii).Position = SimpleBounds(Pops(ii).Position, lb, ub);
        end
               
        % Update if the solution improves, or not too loud
         Pops(ii).Cost = fobj(Pops(ii).Position); % calculate the objective function
        if rand < A(ii)
            A(ii) = alpha * A(ii);
            r(ii) = ro * (1 - exp(-gamma * it));
        end
    end
    [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Pops)',GetCosts(Pops)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
