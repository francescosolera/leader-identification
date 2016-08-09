dataDirectory = 'D:\lab\leader\grow\data\eth';

clusters = {};          % the data structure where groups are saved
usethem = [];           % tell us whether the group was ambiguous to annotate

fid = fopen([dataDirectory, '/clusters.txt']);

counters = zeros(1, 10);
tline = fgetl(fid);
while ischar(tline)
    myCluster = str2num(tline);
    % now we have to check if every element of this group shows up in
    % the current window.
    counters(length(myCluster)) = counters(length(myCluster)) + 1;
    tline = fgetl(fid);
end
fclose(fid);
