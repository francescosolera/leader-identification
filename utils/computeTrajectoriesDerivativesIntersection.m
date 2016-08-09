function [a_traj, b_traj] = computeTrajectoriesDerivativesIntersection(a_traj_p, b_traj_p)

% extract observed velocity
a_traj_v = 0.5*(circshift(a_traj_p, -1) - circshift(a_traj_p, +1));     a_traj_v = [a_traj_p(2:end-1, 1), a_traj_v(2:end-1, [2 3])];
b_traj_v = 0.5*(circshift(b_traj_p, -1) - circshift(b_traj_p, +1));     b_traj_v = [b_traj_p(2:end-1, 1), b_traj_v(2:end-1, [2 3])];

% extract observed acceleration
a_traj_a = 0.5*(circshift(a_traj_v, -1) - circshift(a_traj_v, +1));     a_traj_a = [a_traj_v(2:end-1, 1), a_traj_a(2:end-1, [2 3])];
b_traj_a = 0.5*(circshift(b_traj_v, -1) - circshift(b_traj_v, +1));     b_traj_a = [b_traj_v(2:end-1, 1), b_traj_a(2:end-1, [2 3])];

% find common frames
cf = intersect(a_traj_a(:, 1), b_traj_a(:, 1));
a_traj.p = a_traj_p(ismember(a_traj_p(:, 1), cf), :);
a_traj.v = a_traj_v(ismember(a_traj_v(:, 1), cf), :);
a_traj.a = a_traj_a(ismember(a_traj_a(:, 1), cf), :);
b_traj.p = b_traj_p(ismember(b_traj_p(:, 1), cf), :);
b_traj.v = b_traj_v(ismember(b_traj_v(:, 1), cf), :);
b_traj.a = b_traj_a(ismember(b_traj_a(:, 1), cf), :);

end