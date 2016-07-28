function exportData(dataName, endString)

% dataName: Name of input .mat file in single quotes ('exampleData')
% endString: File extenstion in single quotes with dot ('.xls') or ('.csv')

filename = strcat('seqParam_', datestr(datetime), endString);
data = load(dataName);
 
stats = data.cellStats;
results = [];
for i = 1:length(stats)
     frameData = stats{i};
     results = [results; frameData];
end
writetable(results, filename);