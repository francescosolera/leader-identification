function out = NDCG(Y_i, Y)

rel_Y_i = length(Y) - Y;
rel_Y_i(rel_Y_i~=max(rel_Y_i)) = 0;
rel_Y_i(rel_Y_i==max(rel_Y_i)) = 10;
rel_Y_i_sorted = sort(rel_Y_i, 'descend');
out = 0;
N = 0;
for i = 1 : length(Y)
    out = out + (2^rel_Y_i(Y_i(i))-1)/log2(Y_i(i)+1);
    N = N + (2^rel_Y_i_sorted(Y_i(i))-1)/log2(Y_i(i)+1);
end

out = out/N;

end