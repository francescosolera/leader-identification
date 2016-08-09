function out = feature_distance(members, trajectories, group)
n = length(group);
out = zeros(n, n);

for a = 1 : n
    for b = 1 : n
        if a == b, continue; end
        
        a_traj = trajectories{members==group(a)};
        b_traj = trajectories{members==group(b)};
        
        % find common frames
        [~, a_idx, b_idx] = intersect(a_traj(:, 1), b_traj(:, 1));
        a_traj = a_traj(a_idx, [2 3]);
        b_traj = b_traj(b_idx, [2 3]);
        
        out(a, b) = median(sqrt(sum((a_traj - b_traj).*(a_traj - b_traj), 2)));
        
    end
end

tmp = repmat(mean(out, 1), size(out, 1), 1);
out = exp(-tmp);
out(eye(size(out))==1) = 0;


end