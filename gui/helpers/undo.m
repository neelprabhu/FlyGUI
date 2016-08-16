function handles = undo(handles)

handles.masterData(handles.f) = handles.oldData(1);
if(length(handles.oldData) >= 2)
    handles.oldData(1) = [];
end
handles.edgeIdx = 1;
handles.vertexIdx = 1;
handles.prevVIdx = 1;
handles.prevEIdx = 1;
handles.clickDown = 0;