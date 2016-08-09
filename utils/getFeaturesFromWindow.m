function [myF, members, groups, features, PR, Y, usethem] = getFeaturesFromWindow(myF, frame_number, model_par)
%% PREPARE WINDOW DATA
% select the working window
% frame_number in myF in terms of uniques element
frameID         = unique(myF(:,1));
index_start     = find(myF(:,1)==frameID(frame_number), 1, 'first');
index_end       = find(myF(:,1)==frameID(frame_number+model_par.window_size-1), 1, 'last');

myF = myF(index_start : index_end, :);

% extract the pedestrians which can be seen inside this window
members = unique(myF(:, 2));

% it is also very useful to verify that each pedestrians will remain in the
% scene for at least a minimum number of frames, let's say 4  - so that we
% will be able to actually work on some data. shorter sequences will thus
% be ignored!
for i = 1 : size(members)
    if sum(myF(:, 2) == members(i)) < 20
        % delete the trajectory of the user from this scene
        myF(myF(:, 2) == members(i), :) = [];
    end
end

% update members and retrieve groups
members = unique(myF(:, 2));
[groups, usethem]  = getGroupsFromWindow(members, model_par.dataDirectory);

%% EXTRACT PEOPLE TRAJECTORIES
trajectories = cell(1, length(members));
for i = 1 : length(members)
    trajectories{i} = myF(myF(:, 2)==members(i), [1 3 5]);
end

%% EXTRACT FEATURES
features    = cell(length(groups), sum(model_par.features));
PR          = cell(length(groups), sum(model_par.features));
Y           = cell(length(groups), 1);
for i = 1 : length(groups)
    feature_idx = 0;
    
    %fprintf('.');
    for j = 1 : length(model_par.features_callbacks)
        if model_par.features(j)
            feature_idx = feature_idx + 1;
            features{i, feature_idx} = model_par.features_callbacks{j}(members, trajectories, groups{i});
            PR{i, feature_idx} = pageRank(features{i, feature_idx});
        end
    end
    
    Y{i} = 1 : length(groups{i});
end

end
