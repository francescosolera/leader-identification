function out = feature_MOD_distance(members, trajectories, group)
n = length(group);
out = zeros(n, n);

c_d = 1;

for a = 1 : n
    for b = 1 : n
        if a == b, continue; end
        
        % extract trajectories
        a_traj_p = trajectories{members==group(a)};
        b_traj_p = trajectories{members==group(b)};
        
        % compute observed velocity and acceleration
        [a_traj, b_traj] = computeTrajectoriesDerivativesIntersection(a_traj_p, b_traj_p);
        
        if size(a_traj.p, 1) < 10, out(a, b) = 0; continue; end
        
        % now compute follower (a) expected acceleration when considering
        % (b) as the leader
        gamma = mean(sqrt(sum((a_traj.p(:, [2 3]) - a_traj.p(:, [2 3])).^2, 2)));
        a_traj_model_a = [a_traj.p(:, 1), c_d*(b_traj.p(:, [2 3])-a_traj.p(:, [2 3]) - gamma)];
        
        % compute difference betweem model and observations
        %out(a, b) = exp(-bhattacharyya(a_traj_model_a(:, [2 3]), a_traj.a(:, [2 3])));
        out(a, b) = exp(-mean(sqrt(sum((a_traj_model_a(:, [2 3]) - a_traj.a(:, [2 3])).*(a_traj_model_a(:, [2 3]) - a_traj.a(:, [2 3])), 2))));

        %         if out(a,b) == 0
%             pause
%         end
        %diff = a_traj.a(:, [2 3]) - a_traj_model_a(:, [2 3]);
        %out(a, b) = mean(sqrt(sum(diff.^2, 2)));
    end
end
end