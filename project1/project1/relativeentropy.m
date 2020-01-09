function [H] = relativeentropy(ss,B)
H = 0;
A = -B.*log(B);
for i = 1:size(A,1)
    for j = 1:size(A,2)
        if isnan(A(i,j))
            A(i,j) = 0;
        end
    end
end
tmp = ss*(A);
for i = 1:length(tmp)
    if ~isnan(tmp(i))
        H = H + tmp(i);
    end
end
end