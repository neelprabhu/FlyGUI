function handles = trackStop(handles)

if handles.isChanged == 0
    if ~isempty(handles.oldData)
        handles.oldData(1) = [];
    end
else
    handles.isChanged = 0;
end
if handles.vertexIdx ~= -1
    handles.vertexIdx = -1;
    handles.vDT = setVVoronoi(handles);
end
if handles.clickDown
    handles.clickDown = 0;
    handles.eDT = setEVoronoi(handles);
end