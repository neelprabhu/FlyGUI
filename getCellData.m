function cellStats = getCellData(handles)
% Computes biologically relevant parameters of cells from pre-processed
% image stack.
%
% INPUTS
% ALL: Image stack.
% data: Graph data struct.
% centroids: Centroids of cells to get data from.
%
% OUTPUTS
% cellArea: Areas
% cellPerimeter: Perimeters

%% Get stats
data      = handles.masterData;
ALL       = handles.ALL;
polygons  = handles.polygons;
centroids = handles.centroids;
click     = handles.cp;

stats     = gatherDataStats(size(ALL),data);

%% Get index over time




