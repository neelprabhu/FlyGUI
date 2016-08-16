function handles = pointTrack(handles)

if handles.vertexIdx ~= -1 && handles.vD < handles.eD && handles.clickDown == 1
    masterData = handles.masterData; %Gets the data struct
    handles.isChanged = 1;
    newcp = get(gca,'CurrentPoint');
    newcp = newcp(1, 1:2)';
    masterData(1).VALL{handles.vertexIdx} = newcp; % Move point here.
    edge = masterData(1).ADJLIST{handles.vertexIdx};
    edgeSize = size(edge);
    for i = 1:edgeSize(2)
        splineNum = edge(2,i);
        spline1 = masterData(handles.f).EALL{splineNum};
        splineIdx = 1;
        controls = spline1.control;

        spl = controls(:, 1);
        minn = abs(spl(1) - masterData(1).VALL{handles.vertexIdx}(1)) + ...
                abs (spl(2) - masterData(1).VALL{handles.vertexIdx}(2));
        spl = controls(:, length(controls));
        subb = abs(spl(1) - masterData(1).VALL{handles.vertexIdx}(1)) + ...
                abs (spl(2) - masterData(1).VALL{handles.vertexIdx}(2));
        if subb < minn
                splineIdx = length(controls);
        end       
        
        controls(:, splineIdx) = newcp;
        spline1.control = controls;
        spline1 = splineEvalEven(spline1, true, true, false);
        masterData(1).EALL{splineNum} = spline1;
        set(handles.eH{splineNum},'XData', spline1.curve(1,:));
        set(handles.eH{splineNum},'YData', spline1.curve(2,:));
        set(handles.cpH{splineNum},'XData', spline1.control(1,:));
        set(handles.cpH{splineNum},'YData', spline1.control(2,:));
    end
    set(gca,'XLim',xlim)
    set(gca,'YLim',ylim)
    handles.masterData = masterData;
    vH = handles.vH; vProp = vH{handles.vertexIdx};
    set(vProp,'XData',newcp(1),'YData',newcp(2))
end

if handles.onE && handles.clickDown == 1
    handles.isChanged = 1;
    masterData = handles.masterData; %Gets the data struct
    newcp = get(gca,'CurrentPoint');
    newcp = newcp(1, 1:2)';
    spline1 = masterData(handles.f).EALL{handles.edgeIdx};
    controls = spline1.control;
    controlIdx = 1;
    minn = 10000;
    for j = 2: length(controls)-1
        spl = controls(:,j);
        subb = abs(spl(1) - newcp(1)) + ...
                abs (spl(2) - newcp(2));
        if subb < minn
                controlIdx = j;
                minn = subb;
        end
    end
    controls(:, controlIdx) = newcp;
    spline1.control = controls;
    spline1 = splineEvalEven(spline1, true, true, false);
    masterData(handles.f).EALL{handles.edgeIdx} = spline1;
    set(handles.eH{handles.edgeIdx},'XData', spline1.curve(1,:));
    set(handles.eH{handles.edgeIdx},'YData', spline1.curve(2,:));
    set(handles.cpH{handles.edgeIdx},'XData', spline1.control(1,:));
    set(handles.cpH{handles.edgeIdx},'YData', spline1.control(2,:));
    handles.masterData = masterData;
end