%%
% Người chỉnh sửa       : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
% - MOPSO (Code)  
%       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
%       By Yarpiz
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
%% MOPSO
function eva_curve = MOPSO(Fobj,is_maximization_or_minization,nVar,Lb,Ub,Pop_num,MaxIt,Weight,Weightdamp,personalCoefficient,globalCoefficient,mutationRate,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy chim
Pop=CreateEmptyParticle(Pop_num);
Pop=Initialization(Pop, nVar, Ub, Lb, Fobj);
VarSize=[1 nVar];

% Khởi tạo kho lưu trữ để lưu các giải pháp
Pop=DetermineDomination(Pop);
Archive=GetNonDominatedParticles(Pop);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOPSO bắt đầu vòng lặp
for it = 1:MaxIt
    
    for i=1:Pop_num
        leaderPop=SelectLeader(Archive,betaF);
        
        Pop(i).Velocity = Weight*Pop(i).Velocity ...
            +personalCoefficient*rand(VarSize).*(Pop(i).Best.Position-Pop(i).Position) ...
            +globalCoefficient*rand(VarSize).*(leaderPop.Position-Pop(i).Position);
        
        Pop(i).Position = Pop(i).Position + Pop(i).Velocity;
        
        Pop(i).Position = max(Pop(i).Position, Lb);
        Pop(i).Position = min(Pop(i).Position, Ub);
        
        Pop(i).Cost=Fobj(Pop(i).Position);
    % Thực hiện đột biến
        pm=(1-(it-1)/(MaxIt-1))^(1/mutationRate);
        if rand < pm
            NewSol.Position=Mutate(Pop(i).Position,pm,Lb,Ub);
            NewSol.Cost=Fobj(NewSol.Position);
            if Dominates(NewSol,Pop(i))
                Pop(i).Position=NewSol.Position;
                Pop(i).Cost=NewSol.Cost;
            elseif Dominates(Pop(i),NewSol)
               % Không làm gì cả 
            else
                if rand<0.5
                    Pop(i).Position=NewSol.Position;
                    Pop(i).Cost=NewSol.Cost;
                end
            end
        end
        
        if Dominates(Pop(i),Pop(i).Best)
            Pop(i).Best.Position=Pop(i).Position;
            Pop(i).Best.Cost=Pop(i).Cost;
            
        elseif Dominates(Pop(i).Best,Pop(i))
            % Không làm gì cả  
        else
            if rand<0.5
                Pop(i).Best.Position=Pop(i).Position;
                Pop(i).Best.Cost=Pop(i).Cost;
            end
        end
    end
     % Lưu lại giải pháp tốt nhất
     [Pop,Archive,G] = AddNewSolToArchive(Pop,Archive,Archive_size,G,nGrid,alphaF,gammaF);
     Weight=Weight*Weightdamp;  
     
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    plotChart(Pop, Archive, nCost, 50, is_maximization_or_minization);
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Pop)',GetCosts(Pop)');
        eva_curve = [eva_curve; eva_value];
    end

end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end




