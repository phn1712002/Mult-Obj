function [val] = GetBinary()

    if rand() < 0.5
        val = 0;
    else
        val = 1;
    end

end