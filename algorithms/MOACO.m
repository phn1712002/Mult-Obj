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
%% MOACO
function eva_curve = MOACO(fobj,is_maximization_or_minization,nVar,lb,ub,Ants_num,n_Sample,q,zeta,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% Khởi tạo bầy kiến
Ants=CreateEmptyParticle(Ants_num);
Ants=Initialization(Ants, nVar, ub, lb, fobj);

% Khởi tạo kho lưu trữ
Ants=DetermineDomination(Ants);
Archive=GetNonDominatedParticles(Ants);
Archive_costs=GetCosts(Archive);
G=CreateHypercubes(Archive_costs,nGrid,alphaF);
nCost = size(GetCosts(Archive), 1);
VarSize=[1 nVar];   % Variables Matrix Size
eva_curve = [];
for i=1:numel(Archive)
    [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
end

% Sort Ramdon Population
Ants = SortPops(Ants,Archive,betaF);

% Solution Weights
w=1/(sqrt(2*pi)*q*Ants_num)*exp(-0.5*(((1:Ants_num)-1)/(q*Ants_num)).^2);

% Selection Probabilities
p=w/sum(w);


% MOACO bắt đầu
for it=1:MaxIt
    
    % Means
    s=zeros(Ants_num,nVar);
    for l=1:Ants_num
        s(l,:)=Ants(l).Position;
    end

    % Standard Deviations
    sigma=zeros(Ants_num,nVar);
    for l=1:Ants_num
        D=0;
        for r=1:Ants_num
            D=D+abs(s(l,:)-s(r,:));
        end
        sigma(l,:)=zeta*D/(Ants_num-1);
    end

    % Create New Population Array
    Ants_new=CreateEmptyParticle(n_Sample);
    resultTemp = Inf;
    for t=1:n_Sample
        
        % Initialize Position Matrix
        Ants_new(t).Position=zeros(VarSize);
        
        % Solution Construction
        for i=1:nVar
            
            % Select Gaussian Kernel
            l=RouletteWheelSelection(p);
            
            % Generate Gaussian Random Variable
            resultTemp = s(l,i)+sigma(l,i)*randn;
            while resultTemp <= lb(i) && resultTemp >= ub(i) 
                resultTemp = s(l,i)+sigma(l,i)*randn;
            end
            Ants_new(t).Position(i) = resultTemp;
            
        end
        
        % Evaluation
        Ants_new(t).Cost=fobj(Ants_new(t).Position);
        
    end
    % Merge Main Population (Archive) and New Population (Samples)
    Ants=[Ants; Ants_new];

    % Sort Ramdon Population
    Ants = SortPops(Ants,Archive,betaF);

    % Delete Extra Members
    Ants=Ants(1:Ants_num);

    % Lưu lại các cá voi có phù hợp vào kho lưu trữ
    [Ants,Archive,G] = AddNewSolToArchive(Ants,Archive,Archive_size,G,nGrid,alphaF,gammaF);

    disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
    
    plotChart(Ants, Archive, nCost, 50, is_maximization_or_minization);
    if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
        eva_value = f_evaluate(GetPosition(Ants)',GetCosts(Ants)');
        eva_curve = [eva_curve; eva_value];
    end
end
% Xuất kết quả
OutResults(Archive, is_maximization_or_minization);
end
