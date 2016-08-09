function out = time_lagged_DTW(a_traj, b_traj, distance_type)
out = 0;

% based on a and b traj length, find -K and +K
% only 1/3 of the window size is used for comparison
K = min(round(size(a_traj, 1)/4),30);

step=round(2*K/6);

M = 0;
a_traj_comp = a_traj(K+1:end-K, :);
for z = -K : step : +K
    % shift traj b
    b_traj_comp = b_traj(K+z+1:end-K+z, :);
    % compute DTW on distance (last param 2)
    [d, ~, k, ~] = DTW(a_traj_comp', b_traj_comp', distance_type);
    if d == 0, continue; end
    % accumulate normalization coeff
    M = M + (d/k)^-1;
    % accumulate feature
    out = out + z*(d/k)^-1;
end

if M == 0, M = 1; end
out = out / M;

end