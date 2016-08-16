function handles = parameterGet(handles)

editedFrames = 1;

% Update facelists
for n = 1:editedFrames'
    handles.masterData(n).FACELIST = makeNewFace(handles,n);
end

% Get polygons and centroids for every cell, every frame
for frame = 1:size(handles.masterData,2)
    handles = makeCellPolygons(handles,frame); % Get polygons and centroids for every cell, every frame
end

cellStats = getCellData(handles);
save('cellStats','cellStats')
exportData('cellStats', '.csv', handles)