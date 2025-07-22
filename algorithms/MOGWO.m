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
%% MOGWO
function eva_curve = MOGWO(fobj,is_maximization_or_minization,nVar,lb,ub,GreyWolves_num,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo một bầy sói
GreyWolves=CreateEmptyParticle(GreyWolves_num);
GreyWolves=Initialization(GreyWolves, nVar, ub, lb, fobj);

% Khởi tạo kho lưu trữ
GreyWolves=DetermineDomination(GreyWolves);
Archive=GetNonDominatedParticles(GreyWolves);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% MOGWO bắt đầu
for it=1:MaxIt
    a=2-it*((2)/MaxIt);
    for i=1:GreyWolves_num
        
        % Lựa chọn 3 sói đầu đàn
        Delta=SelectLeader(Archive,betaF);
        Leaders2n = SelectLeaders2n(Archive,betaF,Delta,3);
        if size(Leaders2n, 1)  == 2
            Beta = Leaders2n(1);
            Alpha = Leaders2n(2);
        else
            Beta=SelectLeader(Archive,betaF);
            Alpha=SelectLeader(Archive,betaF);
        end

        % Quá trình đi săn
        c=2.*rand(1, nVar);
        D=abs(c.*Delta.Position-GreyWolves(i).Position);
        A=2.*a.*rand(1, nVar)-a;
        X1=Delta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Beta.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X2=Beta.Position-A.*abs(D);
        
        c=2.*rand(1, nVar);
        D=abs(c.*Alpha.Position-GreyWolves(i).Position);
        A=2.*a.*rand()-a;
        X3=Alpha.Position-A.*abs(D);
        
        GreyWolves(i).Position=(X1+X2+X3)./3;
        
        % Cập nhật quá trình sau chuyến đi săn
        GreyWolves(i).Position=min(max(GreyWolves(i).Position,lb),ub);
        GreyWolves(i).Cost = fobj(GreyWolves(i).Position);
    end
    % Lưu lại các sói có phù hợp vào kho lưu trữ
    [GreyWolves,Archive,G] = AddNewSolToArchive(GreyWolves,Archive,Archive_size,G,nGrid,alphaF,gammaF);
    
    % Xuất kết quả
    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    plotChart(GreyWolves, Archive, nCost, 50, is_maximization_or_minization);
    
    % Callbacks
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(GreyWolves)',GetCosts(GreyWolves)');
        eva_curve = [eva_curve; eva_value];
    end

end
    OutResults(Archive, is_maximization_or_minization);;
end


