function statistics = getCellData(data, ALL, centroids)
% Computes biologically relevant parameters of cells from pre-processed
% image stack.
%
% INPUTS
% ALL: Image stack now.
% data: Graph data struct.
% centroids: Centroids of cells to get data from.
%
% OUTPUTS
% cellArea: Areas
% cellPerimeter: Perimeters

%% Get stats
statistics = gatherDataStats(size(ALL),data);

%% Get index over time

