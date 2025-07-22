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
%% MOPSO
function callback_outputs = MOPSO(fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,MaxIt,Weight,Weightdamp,personalCoefficient,globalCoefficient,mutationRate,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo bầy chim
Pop=CreateEmptyParticle(Pop_num);
Pop=Initialization(Pop, nVar, ub, lb, fobj);
VarSize=[1 nVar];

% Khởi tạo kho lưu trữ để lưu các giải pháp
Pop=DetermineDomination(Pop);
Archive=GetNonDominatedParticles(Pop);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
callback_outputs = [];
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
        Pop(i).Position = SimpleBounds(Pop(i).Position, lb, ub);

        Pop(i).Cost=fobj(Pop(i).Position);
        % Thực hiện đột biến
        pm=(1-(it-1)/(MaxIt-1))^(1/mutationRate);
        if rand < pm
            NewSol.Position=Mutate(Pop(i).Position,pm,lb,ub);
            NewSol.Cost=fobj(NewSol.Position);
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
    
    % Cập nhật Weight
    Weight=Weight*Weightdamp;  
    
    % Xuất và vẽ thông tin đồ thị
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    PlotChart(Pop, Archive, nCost, 50, is_maximization_or_minization);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Pop)',GetCosts(Pop)');
        callback_outputs = [callback_outputs; output_cb];
    end

end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end




