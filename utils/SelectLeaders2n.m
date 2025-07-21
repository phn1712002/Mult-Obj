function Leaders2n = SelectLeaders2n(Archive, betaF, Leader_old, n)    
    Leaders2n = [];
    rep = Archive;

    if size(Archive, 1) <= n
        ItMax = size(Archive, 1) - 1;
    else
        ItMax = n - 1;
    end

    for i=1:ItMax
        rep_temp = rep;
        if size(Archive,1)>i
            counter=0;
            for newi=1:size(rep,1)
                if sum(Leader_old.Position~=rep(newi).Position)~=0
                    counter=counter+1;
                    rep_temp(counter,1)=rep(newi);
                end
            end
            Leader=SelectLeader(rep_temp,betaF);
            Leader_old = Leader;
            rep = rep_temp;
            Leaders2n = [Leaders2n; Leader];
        end 
    end
end