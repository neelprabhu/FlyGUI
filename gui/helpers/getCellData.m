function cellStats = getCellData(handles)
% Computes biologically relevant parameters of cells from pre-processed
% image stack.
%
% INPUTS
% ALL: Image stack.
% data: Graph data struct.
% centroids: Centroids of cells to get data from.
%
% OUTPUTS
% cellStats: An (n x 1) cell array containing tables with biological data
% about tracked cells.
%
% @author Neel K. Prabhu

%% Get stats
data      = handles.masterData;
ALL       = handles.ALL;
polygons  = handles.polygons;
centroids = handles.centroids;
%click     = handles.cp;
stats     = gatherDataStats(size(ALL),data); % Gather stats from graph, all frames
cellStats = cell(size(data,2),1);

%% Get index over time if single cell

% % First find index of face corresponding to click
% cMatrix                 = centroids{1,1};
% click                   = repmat(click,size(cMatrix,1),1);
% sqrtSumSq               = sqrt(sum((click - cMatrix).^2,2));
% [~,cellStats.faceIndex] = min(sqrtSumSq);

%% Get connComp/face index pairs

for n = 1:size(data,2) % for every frame
    faceC = centroids{n}; % face centroids
    compC = cat(1,stats{n}.Centroid); % conncomp centroids
    for m = 1:size(compC,1) % for every centroid in comp (because actual cells)
        cent      = repmat(compC(m,:),size(faceC,1),1);
        sqrtSumSq = sqrt(sum((faceC - cent).^2,2));
        [~,index] = min(sqrtSumSq);
        cStats{n}(m,:) = {index stats{n}(m)}; % conncomp/face pairs per frame
    end
    
    info = cat(1,cStats{n}{:,2});
    for l = 1:size(info,1)
        info(l).Cell  = cStats{n}{l,1};
        info(l).Frame = n;
    end
    info = orderfields(info, [8,7,1:6]);
    
    cellStats{n,1} = struct2table(info);
    
    % Make a figure with cell labels
    if n ==1
        figure(1)
        imagesc(handles.ALL(:,:,n)), colormap gray, axis ij
        hold on
        a = [cStats{n}{:,2}]; centMat = cat(1,a.Centroid);
        text(centMat(:,1),centMat(:,2),num2str(cat(1,cStats{n}{:,1})), ...
            'Color','y','FontSize',14)
    end
end