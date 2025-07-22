function Cost = minCostRandom(Cost, nCost)
    rand_rows = randi(nCost, [size(Cost,2), 1]);  % Need to change dimension
    Cost = Cost(sub2ind(size(Cost), rand_rows', 1:size(Cost,2)));
    Cost = Cost';
end
