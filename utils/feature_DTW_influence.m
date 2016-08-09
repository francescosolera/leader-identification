function out = feature_DTW_influence(members, trajectories, group)
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
        
        % last parameter describes the distance employed in the DTW
        % 2 stands for euclidean
        out(a, b) = -abs(time_lagged_DTW(a_traj, b_traj, 2));
    end
end

end