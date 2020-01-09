function [d] = KL_distance(s, mu)

if length(s) ~= length(mu)
    disp('KL-dis error, different length');
end

d = 0;
for i = 1:length(s)
    tmp = s(i) .* log(s(i)/mu(i));
    if ~isnan(tmp) && ~isinf(tmp)
        d = d+tmp;
    end
end;
end