function exportData(dataName, endString)

filename = strcat('seqParam_', datestr(datetime), endString)
data = load(dataName);
 
stats = data.cellStats;
results = [];
for i = 1:length(stats)
     frameData = stats{i};
     results = [results; frameData];
end
writetable(results, filename);