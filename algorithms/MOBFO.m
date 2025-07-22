% % %%
% % Người chỉnh sửa       : Phạm Hoàng Nam
% % Gmail                 : phn1712002@gmail.com 
% % Tài liệu tham khảo    : 
% % - MOPSO (Code)  
% %       https://www.mathworks.com/matlabcentral/fileexchange/52870-multi-objective-particle-swarm-optimization-mopso?s_tid=srchtitle
% %       By Yarpiz
% % - MOBFO (Code)
% %       https://www.mathworks.com/matlabcentral/fileexchange/55979-multi-objective-grey-wolf-optimizer-MOBFO
% %       By Seyedali Mirjalili
% % Tất cả nguyên lý dựa trên Single Objective Optimization kết hợp 2 thành phần: 
% % Kho lưu trữ (Archive) và Lựa chọn nhà lãnh đạo(SelectLeader) 
% % Được dựa trên code gốc của MOPSO để tạo ra các bản Multi Objective Optimization
% %% MOBFO
% function eva_curve = MOBFO (fobj,is_maximization_or_minization,nVar,lb,ub,Pop_num,Ns,C,Ped,Nr,Nc,MaxIt,Archive_size,alphaF,nGrid,betaF,gammaF,f_evaluate)
% % Khởi tạo một bầy sói
% Pops=CreateEmptyParticle(Pop_num);
% Pops=Initialization(Pops, nVar, ub, lb, fobj);
% 
% % Khởi tạo kho lưu trữ
% Pops=DetermineDomination(Pops);
% Archive=GetNonDominatedParticles(Pops);
% Archive_costs=GetCosts(Archive);
% G=CreateHypercubes(Archive_costs,nGrid,alphaF);
% nCost = size(GetCosts(Archive), 1);
% eva_curve = [];
% for i=1:numel(Archive)
%     [Archive(i).GridIndex, Archive(i).GridSubIndex]=GetGridIndex(Archive(i),G);
% end
% 
% healthJ = zeros(nCost, Pop_num);
% J = GetCosts(Pops)';
% lastJ = J;
% 
% % MOBFO bắt đầu
% for it=1:MaxIt
% 
%     for k = 1:Nr
%         chemJ = J;
%         for j = 1:Nc
%             for i = 1:Pop_num
%                 del = (rand(1, nVar) - 0.5) * 2;
%                 Pops(i).Position = Pops(i).Position + (C / sqrt(del * del')) * del;
%                 Pops(i).Position = SimpleBounds(Pops(i).Position, lb, ub);
%                 J(i, :) = fobj(Pops(Pop_num).Position);
% 
%                 for m = 1:Ns
%                     temp.Cost = lastJ(i)
%                     if Dominates(Pops(i), )
%                         Pops(i).Position = Pops(i).Position + C * (del / sqrt(del * del'));
%                         Pops(i).Position = SimpleBounds(Pops(i).Position, lb, ub);
%                     else
%                         del = (rand(1, nVar) - 0.5) * 2;
%                         Pops(i).Position = Pops(i).Position + C * (del / sqrt(del * del'));
%                         Pops(i).Position = SimpleBounds(Pops(i).Position, lb, ub);
%                     end
%                     J(i, :) = fobj(Pops(Pop_num).Position);
%                 end
%             end
%         Jchem_S = [Jchem J];
%         end
% 
%         for i = 1:Pop_num
%             healthPops(i) = sum(Jchem_S(i)); % sum of cost function of all chemotactic loops for a given k & l
%         end
% 
%         [~, I] = sort(healthPops, 'ascend');
%     end
% 
% 
% 
%     % Lưu lại các sói có phù hợp vào kho lưu trữ
%     [Pops,Archive,G] = AddNewSolToArchive(Pops,Archive,Archive_size,G,nGrid,alphaF,gammaF);
%     % Xuất kết quả
%     disp(['In iteration ' num2str(it) ': Number of solutions in the archive = ' num2str(numel(Archive))]);
% 
%     plotChart(Pops, Archive, nCost, 50, is_maximization_or_minization);
% 
%     if ~isempty(f_evaluate) && isa(f_evaluate,'function_handle')
%         eva_value = f_evaluate(GetPosition(Pops)',GetCosts(Pops)');
%         eva_curve = [eva_curve; eva_value];
%     end
% 
% end
%     OutResults(Archive, is_maximization_or_minization);;
% end
% 
% 
