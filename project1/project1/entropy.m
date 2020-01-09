function [H] = entropy(p)
H = 0;
for i = 1:length(p)
    tmp = -p(i)*log(p(i));
    if ~isnan(tmp) && ~isinf(tmp)
        H = H + tmp;
    end
end
end