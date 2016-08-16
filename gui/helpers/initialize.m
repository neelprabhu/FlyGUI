function handles = initialize(handles)

global ALL;
GT = imread('myGT.png');
handles.GT = padarray(GT, [20,20]);
handles.ALL = padarray(ALL, [20,20,0]);
handles.zStX = 20; handles.zStoX = size(handles.ALL(:,:,1),2)-19;
handles.zStY = 20; handles.zStoY = size(handles.ALL(:,:,1),1)-19; % Zoom settings
[V,E,A,F] = embryoInitGraph(handles.GT,20,false);
handles.masterData = struct('VALL',{V},'EALL',{E},'ADJLIST',{A},'FACELIST',{F});
handles.f = 1; % default frame
handles.oldData = handles.masterData(handles.f);
handles.vDT = setVVoronoi(handles);
handles.eDT = setEVoronoi(handles);