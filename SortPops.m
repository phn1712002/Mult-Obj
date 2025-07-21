function [Pops, SortOrder] = SortPops(Pops,Archive,betaF)
size_Pops = size(Pops,1);
LeaderPops=SelectLeader(Archive,betaF);
LeaderPops2n = SelectLeaders2n(Archive, betaF, LeaderPops, size_Pops);
Pops_new = [LeaderPops;LeaderPops2n];

if(size(Pops_new,1) < size_Pops)
    [Pops, Pops_new, SortOrder, SortOrder_temp] = sub_f(Pops, Pops_new, LeaderPops);
    Pops=Pops(SortOrder_temp);
    Pops = [Pops_new; Pops];
    Pops = Pops(1:size_Pops);
    
else
    [Pops, Pops_new, SortOrder, ~] = sub_f(Pops, Pops_new, LeaderPops);
    Pops = [Pops_new; Pops];
    Pops = Pops(1:size_Pops);
end
end


function [Pops, Pops_Leader, SortOrder, SortOrder_temp] = sub_f(Pops, Pops_Leader, LeaderPops)
Pops_temp = Pops;
index_leaders = zeros(1, size(Pops_Leader,1));

for i=1:size(Pops,1)
    Pops(i).Best.Position=LeaderPops.Position;
    Pops(i).Best.Cost=LeaderPops.Cost;
    flag = false;
    for j=1:size(Pops_Leader,1)
        if isequal(Pops_temp(i).Position, Pops_Leader(j).Position) && isequal(Pops_temp(i).Cost, Pops_Leader(j).Cost)
            Pops_temp(i).Cost = Inf;  
            index_leaders(j) = i; 
            flag = true;
        end
    end
    
    if flag == false
        Pops_temp(i).Cost = Pops_temp(i).Cost(randi(length(Pops_temp(i).Cost)));
    end
end
idx_error = find(index_leaders == 0);
Pops_Leader(idx_error) = [];  % Xóa các phần tử bằng 0
index_leaders(idx_error) = [];  % Xóa các phần tử bằng 0
[~, SortOrder]=sort([Pops_temp.Cost]);
SortOrder_temp = SortOrder;
SortOrder = [index_leaders SortOrder ];
SortOrder = SortOrder(1:size(Pops,1));
end
