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
%% MOTlb
function callback_outputs = MOTlb(fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo bầy
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

% MOTlb bắt đầu vòng lặp
for it = 1:MaxIt
    
    % Tính toán trung bình dân số
    Mean = 0;
    for i = 1:Pop_num
        Mean = Mean + Pop(i).Position;
    end
    Mean = Mean/Pop_num;

    % Chọn giáo viên
    Teacher = SelectLeader(Archive, betaF);


    % Giai đoạn giáo viên
    for i = 1:Pop_num
        % Tạo ra giải pháp trống
        newsol = CreateEmptyParticle(1);
        
        % Yếu tố giảng dạy
        TF = randi([1 2]);
        
        % Giảng dạy (chuyển sang giáo viên)
        newsol.Position = Pop(i).Position ...
            + rand(VarSize).*(Teacher.Position - TF*Mean);
        
        % Cắt
        newsol.Position = SimpleBounds(newsol.Position, lb, ub);
        
        % Tinsh
        newsol.Cost = fobj(newsol.Position);
        
        % Gộp
        Pop(i) = newsol;

        % Giai đoạn học
        for i = 1:Pop_num
            
            A = 1:Pop_num;
            A(i) = [];
            j = A(randi(Pop_num-1));
            
            Step = Pop(i).Position - Pop(j).Position;
            if Dominates(Pop(j), Pop(i))
                Step = -Step;
            end
            
            % Tạo giải pháp trống
            newsol = CreateEmptyParticle(1);
            
            % Giảng dạy (chuyển sang giáo viên)
            newsol.Position = Pop(i).Position + rand(VarSize).*Step;
            
            % Cắt
            newsol.Position = SimpleBounds(newsol.Position, lb, ub);
            
            % Tính 
            newsol.Cost = fobj(newsol.Position);
            
            % Gộp 
            Pop(i) = newsol;
        end
    end

    % Thêm giải pháp
    [Pop,Archive,G] = AddNewSolToArchive(Pop,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    % Vẽ đồ thị và xuất thông tin
    plotChart(Pop, Archive, nCost, 50, is_maximization_or_minization);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Pop)',GetCosts(Pop)');
        callback_outputs = [callback_outputs; output_cb];
    end

end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end




