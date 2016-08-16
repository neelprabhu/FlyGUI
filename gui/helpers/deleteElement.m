function handles = deleteElement(handles)
if handles.onV
    handles.oldData = [handles.masterData(handles.f); handles.oldData];
    index = handles.vIndex;
    set(handles.vH{index},'Visible','off')
    
    tmpVvalue = handles.masterData(handles.f).VALL{index};
    handles.masterData(handles.f).VALL{index} = [NaN;NaN];
    adj = handles.masterData(handles.f).ADJLIST{index}; % More deletions
    
    if isempty(adj)
        return;
    else
        if length(adj(1,:)) == 2
            order = 3;
            open = true;
            n = 101;
            makeNeedles = false;
            
            ctrl1 = handles.masterData(handles.f).EALL{adj(2,1)}.control;
            ctrl2 = handles.masterData(handles.f).EALL{adj(2,2)}.control;
            
            if ctrl1(:,1) == tmpVvalue
                c2 = ctrl1;

                if ctrl2(:,length(ctrl2)) == tmpVvalue
                    c1 = ctrl2; 
                else
                    c1 = [fliplr(ctrl2(1,:));fliplr(ctrl2(2,:))];
                end
 
            else
                c1 = ctrl1;

                if ctrl2(:,1) == tmpVvalue
                    c2 = ctrl2;
                else 
                    c2 = [fliplr(ctrl2(1,:));fliplr(ctrl2(2,:))];
                end
            end
            control = [c1(:,1:length(c1)-1),tmpVvalue,c2(:,2:length(c2))];
            
            k = length(ctrl1)+length(ctrl2) -3;
            nctr = k + 2; % Number of control points
            mult = ones(1, nctr - 3);
            
            s = splineMake(control, order, mult, open, n, makeNeedles);
            
            set(handles.eH{adj(2,1)},'Visible','off')
            set(handles.cpH{adj(2,1)},'Visible','off')
            set(handles.eH{adj(2,2)},'Visible','off')
            set(handles.cpH{adj(2,2)},'Visible','off')
            handles.masterData(handles.f).EALL{adj(2,1)}=[];
            handles.masterData(handles.f).EALL{adj(2,2)}=[];
            
            next = length(handles.masterData(handles.f).EALL);
            handles.masterData(handles.f).EALL{next+1} = s;
            
            masterData = handles.masterData;
            
            tmpAdj = masterData(handles.f).ADJLIST{adj(1,1)};
            
            for k = 1:length(tmpAdj(1,:))
                if tmpAdj(1,k) == index
                    
                    masterData(handles.f).ADJLIST{adj(1,1)}(:,k) = [ adj(1,2)  ; next+1];
                    
                end
            end
            
            tmpAdj = masterData(handles.f).ADJLIST{adj(1,2)};
            
            for k = 1:length(tmpAdj(1,:))
                if tmpAdj(1,k) == index
                    
                    masterData(handles.f).ADJLIST{adj(1,2)}(:,k) = [ adj(1,1)  ; next+1];
                    
                end
            end
            
            xlim = get(gca,'XLim');
            ylim = get(gca,'YLim');
            [handles.vH, handles.eH, handles.cpH] = ...
                customdisplayGraph(handles.ALL(:,:,handles.f), ...
                masterData(handles.f).VALL, masterData(handles.f).EALL, 'on');
            set(gca,'XLim',xlim)
            set(gca,'YLim',ylim)
            handles.masterData = masterData;
            handles.eDT = setEVoronoi(handles);
            
        else
            vert = adj(1,:);
            edge = adj(2,:);
            handles.masterData(handles.f).ADJLIST{index} = []; % Get rid of deleted vertex ADJLIST
            for n = 1:numel(edge)
                handles.masterData(handles.f).EALL{edge(n)} = []; % Get rid of incident
                set(handles.eH{edge(n)},'Visible','off') % Edges visible off
                handles.cpH{edge(n)} = []; % Delete plotted control points
                adjMatrix = handles.masterData(handles.f).ADJLIST{vert(n)}; % Adjacent vertices' ADJLIST
                adjMatrix(:,find(adjMatrix(1,:) == index)) = []; % Delete the old entry
                handles.masterData(handles.f).ADJLIST{vert(n)} = adjMatrix; % Reset
            end
        end
    end
end

if handles.onE
    handles.oldData = [handles.masterData(handles.f); handles.oldData];
    index = handles.eIndex;
    ctrlMatrix = handles.masterData(handles.f).EALL{index}.control;
    vIndex1 = nearestNeighbor(handles.vDT,ctrlMatrix(:,1)');
    vIndex2 = nearestNeighbor(handles.vDT,ctrlMatrix(:,end)');
    adjMatrix1 = handles.masterData(handles.f).ADJLIST{vIndex1};
    adjMatrix1(:,find(adjMatrix1(1,:) == vIndex2)) = [];
    adjMatrix2 = handles.masterData(handles.f).ADJLIST{vIndex2};
    adjMatrix2(:,find(adjMatrix2(1,:) == vIndex1)) = []; % Get rid of adjacencies
    handles.masterData(handles.f).ADJLIST{vIndex1} = adjMatrix1;
    handles.masterData(handles.f).ADJLIST{vIndex2} = adjMatrix2; % Reset
    set(handles.eH{index},'Visible','off')
    set(handles.cpH{index},'Visible','off')
    handles.cpH{index} = [];
    handles.masterData(handles.f).EALL{index} = [];
end