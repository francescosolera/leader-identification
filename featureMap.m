function out = featureMap(model, X, Y)
    
    out = polinomial_kernel(X*(length(Y)-Y+1), model.polinomial_kernel);

end

