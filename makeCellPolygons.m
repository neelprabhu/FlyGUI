function handles = makeCellPolygons(handles,frame)

% @author Neel K. Prabhu

data         = handles.masterData;
face         = data(frame).FACELIST;
vertex       = data(frame).VALL;
edge         = data(frame).EALL; % Grab data
numcells     = size(face,1);
polyCell     = cell(numcells,1); % Empty matrices here
centroidCell = zeros(numcells,2);

for n = 1:numcells % For every cell in the frame
    faceMatrix = face{n};
    for m = 1:size(faceMatrix,2) % For every pairing per cell
        polyCell{n} = [polyCell{n};vertex{faceMatrix(1,m)}'; ...
            edge{faceMatrix(2,m)}.curve(:,ceil(end/2)-1:ceil(end/2)+1)'];
    end
    centroidCell(n,:) = mean(polyCell{n});
end

handles.polygons{frame,1}  = polyCell;
handles.centroids{frame,1} = centroidCell; 

% axis(gca)
% plot(centroidCell(:,1),centroidCell(:,2),'go','MarkerFaceColor','b','MarkerSize',5)