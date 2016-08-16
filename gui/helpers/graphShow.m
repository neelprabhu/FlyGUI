function handles = graphShow(handles)

mD = handles.masterData;
if size(mD,2) < handles.f
    error('No data on that frame!')
end
[handles.vH, handles.eH, handles.cpH] = ...
    customdisplayGraph(handles.ALL(:,:,handles.f), ...
    mD(handles.f).VALL, mD(handles.f).EALL, 'on');
set(gca, 'XLim', [handles.zStX handles.zStoX])
set(gca, 'YLim', [handles.zStY handles.zStoY])