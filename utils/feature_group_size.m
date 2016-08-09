function out = feature_group_size(members, trajectories, group)
n = length(group);
out = zeros(n, n);

for a = 1 : n
    for b = 1 : n
        if a == b, continue; end       
        out(a, b) = 1;
    end
end

end