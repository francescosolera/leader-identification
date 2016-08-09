function [clusters, usethem] = getGroupsFromWindow(pedestrians, dataDirectory)
clusters = {};          % the data structure where groups are saved
usethem = [];           % tell us whether the group was ambiguous to annotate

fid = fopen([dataDirectory, '/clusters.txt']);

tline = fgetl(fid);
while ischar(tline)
    myCluster = str2num(tline);
    % now we have to check if every element of this group shows up in
    % the current window.
    thisGroups = myCluster(ismember(myCluster, pedestrians));
    clusters = [clusters, thisGroups];
    if ~isempty(thisGroups), usethem  = [usethem, ~ismember(-1, myCluster)]; end
    tline = fgetl(fid);
end
fclose(fid);
end