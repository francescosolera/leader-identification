function showGroups(model, X, Y, video_par)
gt = ~isempty(Y);

% note that some color may repeat even amongst clearly different clusters
% due to lackage of "simple" colors.
colors = 'rbgmcy';

% loop through examples (different windows)
for i = 1 : length(X)
    
    if ~gt
        results = predict(model, X(i), [], 1);
        Y(i).order = results.Y;
    end
    
    % find leaders ids
    leaders = zeros(length(Y(i).order), 1);
    for j = 1 : length(leaders), leaders(j) = X(i).groups{j}(Y(i).order{j}==1); end
    
    frames = unique(X(i).F(:, 1));
    
    % for each frame we draw a convex hull around the group members and a big
    % dot on the leader
    for f = 1 : length(frames)
        % we extract the current frame data
        on_scene = X(i).F(X(i).F(:,1) == frames(f),:);
        
        clf
        img = imread(sprintf('%s/%06d.jpeg', model.dataDirectory, frames(f)));
        
        % we show the current frame
        figure1=figure(1);
        imshow(img);
        hold on;
        
        for g = 1 : length(X(i).groups)
            % cgmos = current group membera on scene
            cgmos = ismember(X(i).groups{g}, on_scene(:,2));
            if any(cgmos) % I have at least one person of group g on scene
                cgmos_ids = X(i).groups{g}(cgmos);
                radius = 20;
                steps = 10;
                th = 0:2*pi/steps:2*pi;
                cluster_points = zeros(length(cgmos_ids)*length(th), 2);
                
                % for each group member we draw a circle around him and
                % then we use the points to create a convex hull.
                for p = 1 : length(cgmos_ids)
                    data = on_scene(on_scene(:, 2) == cgmos_ids(p), [3,5]);
                    
                    try
                        data_(1, :) = video_par.m2pixel(1, 1)*data(:, 2) + video_par.m2pixel(1, 2);
                        data_(2, :) = video_par.m2pixel(2, 1)*data(:, 1) + video_par.m2pixel(2, 2);
                        data = data_;
                    catch
                        % scaling
                        data = video_par.H * [data, ones(size(data, 1), 1)]';
                        data = round(data ./ (eps+repmat(data(3, :), 3, 1)));
                    end
                    
                    x = radius*cos(th) + data(1, :);
                    y = radius*sin(th) + data(2, :);
                        
                    cluster_points(1+(p-1)*length(th):p*length(th), :) = [x', y'];
                    
                    %                     if cgmos_ids(p) == X(i).groups{g}(1) && length(cgmos_ids) > 1
                    %                         plot(data(1),data(2),'o','linewidth',4,'color', 'w');
                    %                     end
                    
                    if any(cgmos_ids(p) == leaders) && length(cgmos_ids) > 1
                        plot(data(1),data(2),'o','linewidth',4,'color', colors(mod(g, length(colors)) + 1));
                    end
                    
                end
                
                % we draw the convex hull
                if size(cluster_points, 1) > 0 && length(cgmos_ids) > 1
                    k = convhull(cluster_points(:, 1), cluster_points(:, 2));
                    h = fill(cluster_points(k, 1), cluster_points(k, 2), colors(mod(g, length(colors)) + 1));
                    set(h,'EdgeColor', colors(mod(g, length(colors)) + 1));
                    alpha(h, 0.1)
                end
            end
            
        end
        %if(mod(f,1)==0)
            saveas(figure1,['.\output\' num2str(f) '.jpg']);
        %end
        hold off;
        
      print(figure1,'-djpeg',['output/figure' num2str(i) '.jpg']);
        
        pause(0.1);
    end
    
end