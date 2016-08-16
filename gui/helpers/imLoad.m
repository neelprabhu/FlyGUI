function handles = imLoad(handles)

global ALL;
[file1, path1] = uigetfile({'*.mat';'*.*'}, 'Choose a pre-processed .mat file.');
data = load([path1,file1]);
handles.masterData = data.data;
handles.oldData = handles.masterData(1);
[file2, path2] = uigetfile({'*.tif';'*.*'}, 'Choose a pre-processed .tif stack.');
stack = loadtiff([path2,file2]);
ALL = stack;
handles.ALL = padarray(stack, [20,20,0]);
handles.zStX = 20; handles.zStoX = size(handles.ALL(:,:,1),2)-19;
handles.zStY = 20; handles.zStoY = size(handles.ALL(:,:,1),1)-19; % Zoom settings
handles.f = 1;
handles.fileName = file1(1:end-4);
handles.vDT = setVVoronoi(handles); handles.eDT = setEVoronoi(handles);