function handles = vertButton(handles)
handles.addVertex = ~handles.addVertex;
handles.addEdge   = 0;
if handles.addVertex % Change color of buttons
    set(handles.add_element,'BackgroundColor',[.76 .87 .78])
    set(handles.add_edge,'BackgroundColor',[.941 .941 .941])
else
    set(handles.add_element,'BackgroundColor',[.941 .941 .941])
end