function results = predict(model, X, Y, min_group_size)

%% prepare variables patterns and labels
idx = 1;
results.X = [];
for i = 1 : length(X)
    for j = 1 : length(X(i).groups)
        if length(X(i).groups{j}) >= min_group_size
            results.X{idx} = [X(i).PR{j, :}]';
            if ~isempty(Y), labels{idx} = Y(i).order{j}'; usethem(idx) = Y(i).usethem(j); end
            idx = idx + 1;
        end
    end
end

if isempty(results.X), results.rank_accuracy = 1; results.leader_accuracy = 1; return; end

n = length(results.X);

%% make inference
results.Y = cell(1, n);
for i = 1 : n
    
    %% kernelized version
    % I cannot use the sort function anymore with the kernel as the y is not
    % linear any longer. I need to try all possible rankings for each group
    M = size(results.X{i}, 2);
    v = perms(1:M);
    
    P = zeros(size(v, 1), 1);
    for j = 1 : size(v, 1)
        P(j) = model.w'*featureMap(model, results.X{i}, v(j, :)');
    end
    
    [~, idx] = max(P);
    results.Y{i} = v(idx, :)';
    
    
    
    %     [~, B] = sort(results.X{i}'*model.w, 'descend');
    %     results.Y{i}(B) = 1 : length(B);
    %     results.Y{i} = results.Y{i}';
end

%% measure accuracy
if ~isempty(Y)
    % 1) leader accuracy
    results.leader_accuracy = 0;
    for i = 1 : n
        if find(results.Y{i}==1) == find(labels{i}==1) || ~usethem(i)
            results.leader_accuracy = results.leader_accuracy + 1/n;
        end
    end
    
    % 2) rank accuracy (loss)
    results.rank_accuracy = 0;
    for i = 1 : n
        if ~usethem(i)
            results.rank_accuracy = results.rank_accuracy  + 1/n;
        else
            results.rank_accuracy = results.rank_accuracy + loss(labels{i}, results.Y{i})/n;
        end
    end
    
    %3) leader distribution
    leaderz=zeros(10,1);
    
    %for i=1:length(results.Y)
    for i = 1 : n
        if usethem(i)
            for j=1:length(results.Y{i})
                leaderz(j)=leaderz(j)+int32(results.Y{i}(j)==1);
            end
        end
    end
    leaderz(1)=leaderz(1)+sum(abs(usethem-1));
    results.leaderz=leaderz./n;
    
    
end

end