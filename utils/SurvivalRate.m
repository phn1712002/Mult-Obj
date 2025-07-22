function o = SurvivalRate(Pops, Best, Worts)
    for i = 1:size(Pops, 1)
        o(i) = (Worts.Cost - Pops(i).Cost) / (Worts.Cost - Best.Cost);
    end
end