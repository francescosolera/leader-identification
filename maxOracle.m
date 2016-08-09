function out = maxOracle(model, X, Y)
M = length(Y);
Z = (M^2-1)*M/3;

%% kernelized version
% I cannot use the sort function anymore with the kernel as the y is not
% linear any longer. I need to try all possible rankings for each group
v = perms(1:M);

H = zeros(size(v, 1), 1);
losses = H;
featuremaps = H;
for i = 1 : size(v, 1)
    %Y_neg = M - v(i, :)' + 1;
    losses(i) = loss(Y, v(i, :)');
    featuremaps(i) = model.w'*featureMap(model, X, v(i, :)');
    H(i) = loss(Y, v(i, :)') + model.w'*featureMap(model, X, v(i, :)');
    %H(i) = + loss(Y, v(i, :)');

end

[~, idx] = max(H);
out = v(idx, :)';


% %% linear version
% [~, B] = sort(2*Y + X'*model.w, 'descend');
% out(B) = 1 : length(B);
% out = out';


end

