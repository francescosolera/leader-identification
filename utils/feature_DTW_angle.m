function out = feature_DTW_angle(members, trajectories, group)
n = length(group);
out = zeros(n, n);

for a = 1 : n
    for b = 1 : n
        if a == b, continue; end
        
        a_traj_p = trajectories{members==group(a)};
        b_traj_p = trajectories{members==group(b)};
                
        % on these trajectories, compute angles...
        a_traj = zeros(size(a_traj_p, 1) - 1, 2);
        b_traj = zeros(size(b_traj_p, 1) - 1, 2);
        for i = 1 : size(a_traj_p, 1) - 1, a_traj(i, :) = [a_traj_p(i, 1), atan2d((a_traj_p(i+1, 3)-a_traj_p(i, 3)), (a_traj_p(i+1, 2)-a_traj_p(i, 2)))]; end
        for i = 1 : size(b_traj_p, 1) - 1, b_traj(i, :) = [b_traj_p(i, 1), atan2d((b_traj_p(i+1, 3)-b_traj_p(i, 3)), (b_traj_p(i+1, 2)-b_traj_p(i, 2)))]; end
        
        % find common frames
        [~, a_idx, b_idx] = intersect(a_traj(:, 1), b_traj(:, 1));
        a_traj = a_traj(a_idx, 2);
        b_traj = b_traj(b_idx, 2);
        
        % last parameter describes the distance employed in the DTW
        % 2 stands for euclidean
        out(a, b) = -time_lagged_DTW(a_traj, b_traj, 1);
    end
end

end