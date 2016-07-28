function statistics = gatherDataStats(sizeALL, data)
% Gathers statistics about BW connected components representing faces, 
% such as cell areas and perimeters, from a pre-processed image stack.
% 
% INPUTS
% data: (1 x n) struct where n = number of frames, containing graph data.
% sizeALL: (1 x 2) matrix, output from size(ALL)
%
% OUTPUTS
% statistics: An (m x 1) cell array, where m is the number of frames,
% containing statistics about connected components.
%
% @author Neel K. Prabhu

for n = 1:size(data,2)
    origdisplayGraph(data(n).VALL,data(n).EALL,'off');
    axis off;
    set(gca,'Position',[0 0 1 1])         
    pos = get(gcf,'Position');
    pos(3) = sizeALL(2);
    pos(4) = sizeALL(1);
    set(gcf,'Position',pos)
    f = getframe;
    f.cdata = imresize(f.cdata,[sizeALL(1) sizeALL(2)]);
    B = f.cdata(:, :, 1) > 240 & f.cdata(:, :, 2) > 240 & ...
        f.cdata(:, :, 3) < 200; % Optimize thresholds for resized graph.
    B = watershed(B);
    B = B ~= 0;
    cc = bwconncomp(B,4);
    stats = regionprops(cc,'Area','BoundingBox','Centroid', ...
        'MajorAxisLength','MinorAxisLength','Perimeter');
    for m = 1:size(stats,1) % Check if the region is invalid
        if stats(m).BoundingBox == [0.5 0.5 sizeALL(2) sizeALL(1)]
            stats(m) = []; % Delete that component
            break;
        end
    end
    statistics{n,1} = stats;
end