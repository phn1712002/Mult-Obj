function [sumatory] = Attack(SearchAgents_no, na, Positions, r)
    sumatory = 0;
    vAttack = vectorAttack(SearchAgents_no, na);

    for j = 1:size(vAttack, 2)
        sumatory = sumatory + Positions(vAttack(j), :) - Positions(r, :);
    end

    sumatory = sumatory / na;
end

function [vAttack] = vectorAttack(SearchAgents_no, na)
    c = 1;
    vAttack = [];

    while (c <= na)
        idx = round(1 + (SearchAgents_no - 1) * rand());

        if ~findrep(idx, vAttack)
            vAttack(c) = idx;
            c = c + 1;
        end

    end

end

function [band] = findrep(val, vector)
    % return 1= repeated  0= not repeated
    band = 0;

    for i = 1:size(vector, 2)

        if val == vector(i)
            band = 1;
            break;
        end

    end

end