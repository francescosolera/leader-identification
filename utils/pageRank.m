function out = pageRank(feature)
n = size(feature, 1);
alpha = 0.85;
K = 20;

if n == 1, out = 1; return; end

% make feature row stochastic
feature = feature - 2*min([0, min(min(feature))]);      % guarantee only positive vaues
%feature = abs(feature);
feature(eye(size(feature))==1) = 0;
feature = feature ./ max(sum(feature, 2));
feature(eye(size(feature))==1) = 1 - sum(feature, 2);
S = feature;

%S = feature ./ (eps+repmat(sum(feature, 2), 1, n));
G = alpha*S + (1-alpha)*ones(n, 1)*ones(1, n)/n;

% power iteration method
pi = ones(n, 1) / n;
for i = 1 : K
    pi = G'*pi;
end

f = 10^5;
out = round(pi*f)/f;

end