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
%% MODOA
function callback_outputs = MODOA (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,P,Q,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_callbacks)
% Khởi tạo bầy 
Pops=CreateEmptyParticle(Pop_num);
Pops=Initialization(Pops, nVar, ub, lb, fobj);
VarSize = [1 nVar];
beta1 = -2 + 4 * rand(); 
beta2 = -1 + 2 * rand();
naIni = 2; % Số lượng tối thiểu của các dingoes sẽ tấn công
naEnd = Pop_num / naIni; % SSố lượng tối đa của các dingoes sẽ tấn công
na = round(naIni + (naEnd - naIni) * rand());

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

% MODOA bắt đầu
for it=1:MaxIt
    [Pops,~] = SortPops(Pops, Archive, betaF);
    Best = Pops(1);
    Worts = Pops(end);
    survival = SurvivalRate(Pops, Best, Worts); % Tỷ lệ của survival
    for r = 1:Pop_num
        sumatory = 0;
        if rand() < P % Nếu đi săn?
            sumatory = Attack(Pop_num, na, GetPosition(Pops)', r); 

            if rand() < Q % Nếu nhóm tấn công?
                Pops(r).Position = beta1 * sumatory - Best.Position; 
            else %  Hành hạ
                r1 = round(1 + (Pop_num - 1) * rand()); %
                Pops(r).Position = Best.Position + beta1 * (exp(beta2)) * ((Pops(r1).Position - Pops(r).Position));
            end

        else % Ăn xác
            r1 = round(1 + (Pop_num - 1) * rand());
            Pops(r).Position = (exp(beta2) * Pops(r1).Position - ((-1) ^ GetBinary()) * Pops(r).Position) / 2; 
        end

        if mean(survival(r)) <= 0.3 % Quy trình sinh tồn
            band = 1;
            while band
                r1 = round(1 + (Pop_num - 1) * rand());
                r2 = round(1 + (Pop_num - 1) * rand());

                if r1 ~= r2
                    band = 0;
                end
            end
            Pops(r).Position = Best.Position + (Pops(r1).Position - ((-1) ^ GetBinary()) * Pops(r2).Position) / 2; % Section 2.2.4, Strategy 4: Eq.6
        end
        Pops(r).Position = SimpleBounds(Pops(r).Position,lb,ub);
        Pops(r).Cost = fobj(Pops(r).Position);
        % Lưu lại các cá voi có phù hợp vào kho lưu trữ
        [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
        plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
    end
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    % Gọi hàm callbacks
    if ~isempty(f_callbacks) && isa(f_callbacks,'function_handle')
        output_cb = f_callbacks(GetPosition(Pops)',GetCosts(Pops)');
        callback_outputs = [callback_outputs; output_cb];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
