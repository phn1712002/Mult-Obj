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
%% MOWAO
function eva_curve = MOWAO(fobj,is_maximization_or_minization,nVar,lb,ub,Whales_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy cá voi
Whales=CreateEmptyParticle(Whales_num);
Whales=Initialization(Whales, nVar, ub, lb, fobj);


% Khởi tạo kho lưu trữ
Whales=DetermineDomination(Whales);
Archive=GetNonDominatedParticles(Whales);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOWAO bắt đầu
for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    a2=-1+it*((-1)/MaxIt);
    for i=1:Whales_num
        
        % Lựa chọn cá voi tốt nhất
        LeaderWhales=SelectLeader(Archive,betaF);
        
        % Quá trình đi săn 
        r1=rand(); 
        r2=rand(); 
        
        A=2*a*r1-a;  
        C=2*r2;      

        b=1;               
        l=(a2-1)*rand+1;   
        p = rand();        
        
        % Lựa chọn cách thức săn mồi
        if p<0.5 % Phương pháp bao vây con mồi 
            if abs(A)>=1 % Tìm kiếm con mồi
                rand_leader_index = floor(Whales_num*rand()+1);
                X_rand = Whales(rand_leader_index).Position;
                D_X_rand=abs(C*X_rand-Whales(i).Position); 
                Whales(i).Position=X_rand-A*D_X_rand;     
                
            elseif abs(A)<1 % Săn con mồi
                D_Leader=abs(C*LeaderWhales.Position-Whales(i).Position);
                Whales(i).Position=LeaderWhales.Position-A*D_Leader;     
            end
            
        elseif p>=0.5 % Phương pháp tấn công mạng bong bóng
            distance2Leader=abs(LeaderWhales.Position-Whales(i).Position);
            Whales(i).Position=distance2Leader*exp(b.*l).*cos(l.*2*pi)+LeaderWhales.Position;
        end
        % Cập nhật giá trị sau khi đi chuyến săn
        Whales(i).Position=min(max(Whales(i).Position,lb),ub);
        Whales(i).Cost=fobj(Whales(i).Position);
    end
    
    % Lưu lại các cá voi có phù hợp vào kho lưu trữ
    [Whales,Archive,G] = AddNewSolToArchive(Whales,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    % Plot
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    plotChart(Whales, Archive, nCost, 50, is_maximization_or_minization);
    % Callbacks
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Whales)',GetCosts(Whales)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
