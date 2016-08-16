function handles = edgeButton(handles)
handles.addEdge   = ~handles.addEdge;
handles.addVertex = 0;
if handles.addEdge == 1
    set(handles.add_edge,'BackgroundColor',[.76 .87 .78])
    set(handles.add_element,'BackgroundColor',[.941 .941 .941])
    handles.addVertex = 0;
else
    set(handles.add_edge,'BackgroundColor',[.941 .941 .941])
end