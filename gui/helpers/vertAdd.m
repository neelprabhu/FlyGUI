function handles = vertAdd(handles)

masterData = handles.masterData;
handles.oldData = [handles.masterData(handles.f); handles.oldData];
handles.isChanged = 1;
eI = handles.edgeIdx;
tmpS = masterData(handles.f).EALL{eI};
tmpCurve =  tmpS.curve;
eDis = min    (sqrt((handles.cp(1)-tmpCurve(1,:)).^2 + (handles.cp(2)-tmpCurve(2,:)).^2         ));
VonE = false;
if eDis<2
    VonE  = true;
end

next = size(masterData(handles.f).VALL,1);
masterData(handles.f).VALL{next+1} = handles.cp';
masterData(handles.f).ADJLIST{next+1} = []; % Initialize empty adjacency

handles.vIndex = next+1;

if VonE
    tmpdis = realmax;
    
    [r,c] = size(tmpS.control);
    for k = 1:c
        P2P = sqrt((handles.cp(1)-tmpS.control(1,k))^2+(handles.cp(2)-tmpS.control(2,k))^2);
        if P2P<tmpdis
            tmpdis = P2P;
            numC = k;
        end
    end
    
    if numC~=1
        preDist = sqrt((handles.cp(1)-tmpS.control(1,numC-1))^2+(handles.cp(2)-tmpS.control(2,numC-1))^2);
    else
        preDist = realmax;
    end
    
    if numC~= length(tmpS.control)
        nextDist = sqrt((handles.cp(1)-tmpS.control(1,numC+1))^2+(handles.cp(2)-tmpS.control(2,numC+1))^2);
    else
        nextDist = realmax;
    end
    
    if preDist <nextDist
        numC2 = numC-1;
    else
        numC2 = numC+1;
    end
    
    if numC<numC2
        sNum = numC; lNum = numC2;
    else
        lNum = numC; sNum = numC2;
    end
    
    order = 3;
    open = true;
    n = 101;
    makeNeedles = false;
    
    k1 = sNum-1; % Number of interior control points
    nctr1 = k1 + 2; % Number of control points
    mult1 = ones(1, nctr1 - 3);
    
    control1 = [];
    for k=1:sNum
        control1 = [control1, tmpS.control(:,k)];
    end
    
    if ((sNum==1) && (lNum==2))
        k1 = 1; % Number of interior control points
        nctr1 = k1 + 2; % Number of control points
        mult1 = ones(1, nctr1 - 3);
        control1 = [control1, (tmpS.control(:,1)+handles.cp')./2];
    end
    
    control1 = [control1,handles.cp'];
    
    s1 = splineMake(control1, order, mult1, open, n, makeNeedles);
    
    k2 = length(tmpS.control)-sNum-1; % Number of interior control points
    nctr2 = k2 + 2; % Number of control points
    mult2 = ones(1, nctr2 - 3);
    
    control2 = [];
    control2 = handles.cp';
    
    ttnum = length(tmpS.control);
    if ((lNum==ttnum) && (sNum==ttnum-1))
        
        k2 = 1; % Number of interior control points
        nctr2 = k2 + 2; % Number of control points
        mult2 = ones(1, nctr2 - 3);
        control2 = [control2, (tmpS.control(:,ttnum)+handles.cp')./2];
    end
    
    for k = sNum+1:c
        control2 = [control2,tmpS.control(:,k)];
    end
    s2 = splineMake(control2, order, mult2, open, n, makeNeedles);%%Right now have to have at lease one ctrl point to generate a spline
    
    %delete original spline
    masterData(handles.f).EALL{eI} = [];
    
    %put the two new splines into EALL
    next = size(masterData(handles.f).EALL,1);
    masterData(handles.f).EALL{next+1} = s1;
    masterData(handles.f).EALL{next+2} = s2;
    indEE1 = next + 1;
    indEE2 = next +2;
    
    %index of the first and the second point
    myAdj= masterData(handles.f).ADJLIST;
    
    [ind1,nothing] = nearestNeighbor(handles.vDT,(tmpS.control(:,1))');
    [ind2,nothing] = nearestNeighbor(handles.vDT,(tmpS.control(:,length(tmpS.control)))');%%%%%% might be wrong
    
    %refresh 1st point's adjlist
    tmpVonE = [length(masterData(handles.f).VALL);indEE1];
    
    for k = 1: length(myAdj{ind1}(1,:))
        
        if myAdj{ind1}(2,k) == eI
            masterData(handles.f).ADJLIST{ind1}(:,k) = tmpVonE;%%the erro refers to spline.control
            break;
        end
        
    end
    
    %refresh 2nd point's adjlist
    tmpVonE = [length(masterData(handles.f).VALL);indEE2];
    
    for k = 1:length(myAdj{ind2}(1,:))
        if myAdj{ind2}(2,k) ==eI
            masterData(handles.f).ADJLIST{ind2}(:,k)=tmpVonE;
            break
        end
    end
    % refresh new point's adjlist
    masterData(handles.f).ADJLIST{size(masterData(handles.f).VALL,1)} = [ind1 ind2;indEE1 indEE2];
    
end

hold on;
xlim = get(gca,'XLim');
ylim = get(gca,'YLim');
[handles.vH, handles.eH, handles.cpH] = ...
    customdisplayGraph(handles.ALL(:,:,handles.f), ...
    masterData(handles.f).VALL, masterData(handles.f).EALL, 'on');
set(gca, 'XLim', xlim);
set(gca, 'YLim', ylim);
handles.masterData = masterData;
handles.vDT = setVVoronoi(handles);
handles.eDT = setEVoronoi(handles);