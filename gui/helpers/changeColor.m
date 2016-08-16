function handles = changeColor(handles)

handles.vIndex = handles.vertexIdx;
handles.eIndex = handles.edgeIdx;

vProps = handles.vH{handles.vertexIdx};
vprevProps = handles.vH{handles.prevVIdx};
eProps = handles.eH{handles.edgeIdx};
eprevProps = handles.eH{handles.prevEIdx};
cProps = handles.cpH{handles.edgeIdx};
cprevProps = handles.cpH{handles.prevEIdx};

if handles.vD < handles.eD
    %hold on;
    set(vprevProps,'MarkerEdgeColor','r','MarkerFaceColor','r')
    set(eprevProps,'Color','y')
    set(cprevProps,'Visible','off')
    set(vProps,'MarkerEdgeColor','g','MarkerFaceColor','g')
    handles.prevVIdx = handles.vertexIdx; % Sets previous vertex equal to current
    handles.onE = false; handles.onV = true;
else
    %hold on;
    set(eprevProps,'Color','y')
    set(cprevProps,'Visible','off')
    set(vprevProps,'MarkerEdgeColor','r','MarkerFaceColor','r')
    set(eProps,'Color','g')
    set(cProps,'Visible','on')
    handles.prevEIdx = handles.edgeIdx;
    handles.onE = true; handles.onV = false;
end