function out = feature_DTW_acceleration(members, trajectories, group)
n = length(group);
out = zeros(n, n);

for a = 1 : n
    for b = 1 : n
        if a == b, continue; end
        
        a_traj_p = trajectories{members==group(a)};
        b_traj_p = trajectories{members==group(b)};
        [a_traj, b_traj] = computeTrajectoriesDerivativesIntersection(a_traj_p, b_traj_p);
        
        % last parameter describes the distance employed in the DTW
        out(a, b) = -time_lagged_DTW(a_traj.a(:,[2 3]), b_traj.a(:,[2 3]), 2);
    end
end

end