function [model] = trainBCFW(X, Y, model)
X_train = X(1 : model.trainingSetSize);
Y_train = Y(1 : model.trainingSetSize);

% prepare input variables patterns and labels
idx = 1;
for i = 1 : length(X_train)
    for j = 1 : length(X_train(i).groups)
        if length(X_train(i).groups{j}) >= model.minGroupSize && Y_train(i).usethem(j)
            patterns{idx} = [X_train(i).PR{j, :}]';
            labels{idx} = Y_train(i).order{j}';
            idx = idx + 1;
        end
    end
end

n = length(patterns);

% initialize variables
model.w = zeros(length(featureMap(model, patterns{1}, labels{1})), 1);
w_i = zeros(length(model.w), n);
l_i = zeros(1, n);
l = 0;

% plotting structures
w_k = zeros(length(model.w), model.maxIter);
step_k = zeros(1, model.maxIter);
accuracy_k = zeros(2, model.maxIter);
each_k = 100;

rand_v = rand(model.maxIter, 1);

for k = 1 : model.maxIter
    w_k(:, k) = model.w;
    
    % pick a block at random
    %i = mod(k, n)+1;  % sequential
    i = ceil(rand_v(k) * n);
    
    % solve the oracle
    y_hat = maxOracle(model, patterns{i}, labels{i});
    
    % find the new best value of the variable - model is passed for the
    % kernel computation
    w_s = 1/model.lambda/n*(featureMap(model, patterns{i}, labels{i}) - featureMap(model, patterns{i}, y_hat));
        
    % also compute the loss at the new point
    l_s = 1/n*loss(labels{i}, y_hat);
    
    % compute the step size
    step_size = min(max((model.lambda*(w_i(:, i)-w_s)'*model.w - l_i(i) + l_s) / model.lambda / ...
        ((w_i(:, i)-w_s)'*(w_i(:, i)-w_s)+eps), 0), 1);
    step_k(k) = step_size;
    
    % evaluate w_i and l_i
    w_i_new = (1 - step_size) * w_i(:, i) + step_size * w_s;
    l_i_new = (1 - step_size) * l_i(i) + step_size * l_s;
    
    % update w and l
    model.w = model.w + w_i_new - w_i(:, i);
    l = l + l_i_new - l_i(i);
    
    % update w_i and l_i
    w_i(:, i) = w_i_new;
    l_i(i) = l_i_new;
    
    % plot convergence information
    if ~mod(k, each_k)
        figure(1);
        subplot(2, 2, 1);
        plot(w_k');
        title('weights');
        results = predict(model, X, Y, model.minGroupSize);
        accuracy_k(:, k-each_k+1:k) = repmat([results.leader_accuracy; results.rank_accuracy], 1, each_k);
        legend(cellfun(@(x) sprintf('%s', strrep(func2str(x), '_', '-')), {model.feature_cb{model.feature==1}}, 'uniformoutput', 0));
        subplot(2, 2, 2);
        plot(step_k); title('learning step'); ylim([0 1]);
        subplot(2, 2, 3);
        plot(accuracy_k(1, :)); title('leader accuracy'); ylim([0 1]);
        subplot(2, 2, 4);
        plot(accuracy_k(2, :)); title('ranking loss (used in training)'); ylim([0 max(accuracy_k(2, :))]);
        drawnow;
    end
end

end

