function handles = edgeAdd(handles)

handles.oldData = [handles.masterData(handles.f); handles.oldData];
handles.isChanged = 1;
handles.E2 = handles.vertexIdx;
handles.addEdge = 1;

masterData = handles.masterData;

k = 2; % Number of interior control points
nctr = k + 2; % Number of control points
mult = ones(1, nctr - 3);

control = [masterData(handles.f).VALL{handles.E1}, ...
    masterData(handles.f).VALL{handles.E1}+(masterData(handles.f).VALL{handles.E2}-masterData(handles.f).VALL{handles.E1}).*(1/3), ...
    masterData(handles.f).VALL{handles.E1}+(masterData(handles.f).VALL{handles.E2}-masterData(handles.f).VALL{handles.E1}).*(2/3), ...
    masterData(handles.f).VALL{handles.E2}];
order = 3;
open = true;
n = 101;
makeNeedles = false;

s = splineMake(control, order, mult, open, n, makeNeedles);

next = size(masterData(handles.f).EALL,1);
masterData(handles.f).EALL{next+1} = s;

tmp = [handles.E2;next+1];
masterData(handles.f).ADJLIST{handles.E1,1} = [masterData(handles.f).ADJLIST{handles.E1,1},...
    tmp];
tmp = [handles.E1;next+1];
masterData(handles.f).ADJLIST{handles.E2,1} = [masterData(handles.f).ADJLIST{handles.E2,1},...
    tmp];
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
[handles.vH, handles.eH, handles.cpH] = ...
    customdisplayGraph(handles.ALL(:,:,handles.f), ...
    masterData(handles.f).VALL, masterData(handles.f).EALL, 'on');
set(gca,'XLim',xlim)
set(gca,'YLim',ylim)
handles.masterData = masterData;
handles.eDT = setEVoronoi(handles);