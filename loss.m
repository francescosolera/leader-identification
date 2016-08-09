function out = loss(Y_i, Y)

out = norm(Y - Y_i, 2)^2;

end

