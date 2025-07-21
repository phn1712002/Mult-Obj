%%
% Người chỉnh sửa       : Phạm Hoàng Nam
% Gmail                 : phn1712002@gmail.com 
% Tài liệu tham khảo    : 
% - MOTLB (Code)  
% Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% Được dựa trên code gốc của MOTLB để tạo ra các bản Multi Objective Optimization
%% MOTLB
function eva_curve = MOTLB(Fobj,is_maximization_or_minization,nVar,Lb,Ub,Pop_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
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

% MOTLB bắt đầu vòng lặp
for it = 1:MaxIt
    
    % Calculate Population Mean
        Mean = 0;
        for i = 1:Pop_num
            Mean = Mean + Pop(i).Position;
        end
        Mean = Mean/Pop_num;

        % Select Teacher
        Teacher = SelectLeader(Archive, betaF);


        % Teacher Phase
        for i = 1:Pop_num
            % Create Empty Solution
            newsol = CreateEmptyParticle(1);
            
            % Teaching Factor
            TF = randi([1 2]);
            
            % Teaching (moving towards teacher)
            newsol.Position = Pop(i).Position ...
                + rand(VarSize).*(Teacher.Position - TF*Mean);
            
            % Clipping
            newsol.Position = max(newsol.Position, Lb);
            newsol.Position = min(newsol.Position, Ub);
            
            % Evaluation
            newsol.Cost = Fobj(newsol.Position);
            
            % Comparision
            if Dominates(newsol.Cost, Pop(i))
                Pop(i) = newsol;
            end

            % Learner Phase
            for i = 1:Pop_num
                
                A = 1:Pop_num;
                A(i) = [];
                j = A(randi(Pop_num-1));
                
                Step = Pop(i).Position - Pop(j).Position;
                if Dominates(Pop(j), Pop(i))
                    Step = -Step;
                end
                
                % Create Empty Solution
                newsol = CreateEmptyParticle(1);
                
                % Teaching (moving towards teacher)
                newsol.Position = Pop(i).Position + rand(VarSize).*Step;
                
                % Clipping
                newsol.Position = max(newsol.Position, Lb);
                newsol.Position = min(newsol.Position, Ub);
                
                % Evaluation
                newsol.Cost = Fobj(newsol.Position);
                
                % Comparision
                if Dominates(newsol.Cost, Pop(i))
                    Pop(i) = newsol;
                end
                
            end
        end
    [Pop,Archive,G] = AddNewSolToArchive(Pop,Archive,Archive_size,G,nGrid,alphaF,gammaF);
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




