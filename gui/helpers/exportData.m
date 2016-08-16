function exportData(dataName, endString, handles)
% EXPORTDATA Converts MATLAB table structure that stores biological data
% into .csv file, which opens in Excel.
%
% dataName: Name of input .mat file in single quotes ('exampleData')
% endString: File extenstion in single quotes with dot ('.xls') or ('.csv')
%
% @author Virginia Cheng

filename = handles.fileName;
data = load(dataName);
 
stats = data.cellStats;
results = [];
for i = 1:length(stats)
     frameData = stats{i};
     results = [results; frameData];
end
writetable(results, strcat(filename,'.csv'));