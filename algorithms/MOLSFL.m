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
%% MOLSFL
function callback_outputs = MOLSFL(fobj,is_maximization_or_minization,nVar,lb,ub,nPopMemeplex,nMemeplex,alpha,beta,sigma,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo tham số
nPopMemeplex = max(nPopMemeplex, nVar+1);
nPop = nMemeplex*nPopMemeplex;	
VarSize = [1 nVar];  
I = reshape(1:nPop, nMemeplex, []);
q = max(round(0.3*nPopMemeplex),2); % Số lượng cha mẹ 

% Khởi tạo một 
Pops=CreateEmptyParticle(nPop);
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



% MOLSFL bắt đầu
Pops = SortPops(Pops, Archive, betaF);
Best = Pops(1);
for it=1:MaxIt
    
    % Khởi tạo mảng Memeplexes
    Memeplex = cell(nMemeplex, 1);

    % Hình thành Memeplexes and chạy FLA
    for j = 1:nMemeplex
        % Memeplex hình thành
        Memeplex{j} = Pops(I(j,:));
        
        % Chạy FLA
        nPop = numel(Memeplex{j});                  % Kích thước dân số
        P = 2*(nPop+1-(1:nPop))/(nPop*(nPop+1));    % Lựa chọn phân phối
        
        % Tính toán phạm vi dân số (hypercube nhỏ nhất)
        LowerBound = Memeplex{j}(1).Position;
        UpperBound = Memeplex{j}(1).Position;
        for i = 2:nPop
            LowerBound = min(LowerBound, Memeplex{j}(i).Position);
            UpperBound = max(UpperBound, Memeplex{j}(i).Position);
        end

        for it_beta = 1:beta
            % Chọn cha mẹ
            L = RandSample(P,q);
            B = Memeplex{j}(L);

            % Tạo ra con cái
            for k=1:alpha
                % Dân số sắp xếp
                [B, SortOrder] = SortPops(B, Archive, betaF);
                L = L(SortOrder);
                
                % Cờ
                ImprovementStep2 = false;
                Censorship = false;
                
                % Cải thiện Bước 1
                NewSol1 = B(end);
                Step = sigma*rand(VarSize).*(B(1).Position-B(end).Position);
                NewSol1.Position = B(end).Position + Step;
                if SimpleBounds(NewSol1.Position, lb, ub)
                    NewSol1.Cost = fobj(NewSol1.Position);
                    if Dominates(NewSol1,B(end))
                        B(end) = NewSol1;
                    else
                        ImprovementStep2 = true;
                    end
                else
                    ImprovementStep2 = true;
                end
                
                % Cải thiện Bước 2
                if ImprovementStep2
                    NewSol2 = B(end);
                    Step = sigma*rand(VarSize).*(Best.Position-B(end).Position);
                    NewSol2.Position = B(end).Position + Step;
                    if SimpleBounds(NewSol2.Position, lb, ub)
                        NewSol2.Cost = fobj(NewSol2.Position);
                        if Dominates(NewSol2,B(end))
                            B(end) = NewSol2;
                        else
                            Censorship = true;
                        end
                    else
                        Censorship = true;
                    end
                end
                    
                % Kiểm duyệt
                if Censorship
                    B(end).Position = unifrnd(LowerBound, UpperBound);
                    B(end).Cost = fobj(B(end).Position);
                end
            end
            Memeplex{j}(L) = B;
        end
        
        % Chèn bản ghi nhớ cập nhật vào dân số
        Pops(I(j,:)) = Memeplex{j};
        % Lưu lại các sói có phù hợp vào kho lưu trữ
        [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
        PlotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    end
    % Xuất kết quả
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Pops)',GetCosts(Pops)');
        callback_outputs = [callback_outputs; output_cb];
    end

    end
    OutResults(Archive, is_maximization_or_minization);;
end


