%% INITIALIZE
clc; clear; close all;
addpath(genpath('utils'));

% units of measurements
s = 1;  Hz = 1/s;
m = 1;  f = 1;

% load data
model_par.dataDirectory = 'data/stu003';
[myF, groups, video_par] = loadData('load from file', model_par.dataDirectory);

%% ALGORITHM PARAMETERS
% parameters
model_par.display                = true;
model_par.window_size            = 50 * f;                                 % number of frames to observe to extract features
model_par.window_stride          = model_par.window_size;
model_par.trainingSetSize        = 10;                                     % testing is on whole sequence (NEED TO CHANGE)        
model_par.minGroupSize           = 2;

% features
feature_extraction               = 0;                                      % do extraction or load from file
model_par.features               = [1, 1, 1, 1, 1, 1, 1, 1, 1, 0];         % active features (see line below)

model_par.features_callbacks = { ...
    @feature_DTW_distance, @feature_DTW_speed, @feature_DTW_acceleration, ...
    @feature_distance, ...
    @feature_DTW_influence, @feature_DTW_no_influence, ...
    @feature_DTW, @feature_group_size, ...
    @feature_MOD_distance, @feature_MOD_speed
};

model.feature                    = model_par.features;
model.feature_cb                 = model_par.features_callbacks;
model.trainingSetSize            = model_par.trainingSetSize;
model.dataDirectory              = model_par.dataDirectory;
model.minGroupSize               = model_par.minGroupSize;

defScenario = [ 'data: ' model_par.dataDirectory ', #tr: ' num2str(model_par.trainingSetSize)];
fprintf('%s\n', defScenario);

%% FEATURE EXTRACTION OR LOADING
if feature_extraction || ~exist([model_par.dataDirectory '.mat'], 'file')
    
    fprintf('extracting features:   0%%');
    window_pointer = 1;                                                 i = 1;
    while true
        % now for this window we have to compute the features
        [X(i).F, X(i).members, X(i).groups, X(i).myfeatures, X(i).PR, Y(i).order, Y(i).usethem] = getFeaturesFromWindow(myF, window_pointer, model_par); %#ok
        
        % move the temporal window
        window_pointer = window_pointer + model_par.window_stride;      i = i + 1;
        
        % print some output and stop when the video is finished
        fprintf('\b\b\b%2d%%', round(window_pointer / length(unique(myF(:,1) - model_par.window_size)) * 100));
        if (window_pointer > length(unique(myF(:,1))) - model_par.window_size), break; end
    end
    
    fprintf('\b\b\b\b100%%\n');
    save([model_par.dataDirectory '.mat'], 'X', 'Y');
    
else
    fprintf('feature loaded from file...\n');
    load([model_par.dataDirectory '.mat']);
end

%% TRAINING PHASE

% lerning parameters
model.maxIter           = 30000;
model.lambda            = 0.00005;
model.polinomial_kernel = 1;

model = trainBCFW(X, Y, model);

res_leader = zeros(1, length(X));
res_loss = zeros(1, length(X));
for i = 1 : length(X)
    results = predict(model, X(i), Y(i), model.minGroupSize);
    fprintf('results on %d-th subsequence: leader accuracy (%2.2f%%), ranking loss (%2.2f). \n', i, results.leader_accuracy*100, results.rank_accuracy);
    res_leader(i) = results.leader_accuracy;
    res_loss(i) = results.rank_accuracy;
end
figure(2);
bar([res_leader', res_loss']); legend('leader accuracy (the higher the better)', 'ranking loss (the lower the better)'); xlabel('examples');

results = predict(model, X, Y, model.minGroupSize);
results