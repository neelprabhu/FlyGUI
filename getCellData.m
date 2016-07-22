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

%% Get index over time

data      = handles.masterData;
ALL       = handles.ALL;
polygons  = handles.polygons;
centroids = handles.centroids;
click     = handles.cp;
stats     = gatherDataStats(size(ALL),data); % Gather stats from graph, all frames

%% Get index over time

% First find index of face corresponding to click
cMatrix       = centroids{1,1};
click         = repmat(click,size(cMatrix,1),1);
rootSumSq     = sqrt((cMatrix.^2) + (click.^2));
[blah,faceIndex] = min(rootSumSq);
b=5;
