function out = polinomial_kernel(X, d)
    out = X;
    if d == 1, return; end

    % if d == 2
    out = [];
    m = length(X);
    for i = 1 : m
        out = [out; X(i)^2; X(i)];                          %#ok
        for j = i + 1 : m, out = [out; X(i)*X(j)]; end      %#ok
    end
    
end