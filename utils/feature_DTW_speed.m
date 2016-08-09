function out = feature_DTW_speed(members, trajectories, group)
n = length(group);
out = zeros(n, n);

for a = 1 : n
    for b = 1 : n
        if a == b, continue; end
        
        a_traj_p = trajectories{members==group(a)};
        b_traj_p = trajectories{members==group(b)};
        [a_traj, b_traj] = computeTrajectoriesDerivativesIntersection(a_traj_p, b_traj_p);
         
%          if size(a_traj.p, 1) < 10
%              out(a, b) = eps;
%             continue;
%          end
        % find common frames
       % [~, a_idx, b_idx] = intersect(a_traj(:, 1), b_traj(:, 1));
        %a_traj = a_traj(a_idx, [2 3]);
       % b_traj = b_traj(b_idx, [2 3]);
        
        % last parameter describes the distance employed in the DTW
        % 2 stands for euclidean
        out(a, b) = -time_lagged_DTW(a_traj.v(:,[2 3]), b_traj.v(:,[2 3]), 2);
        if out(a, b) == 0, out(a, b) = eps; end
    end
end

end