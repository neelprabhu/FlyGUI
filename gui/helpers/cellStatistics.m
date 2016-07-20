function statistics = cellStatistics(ALL,centroids)
% Computes biologically useful parameters, such as cell areas and
% perimeters, from a pre-processed image stack.
% 
% INPUTS
% ALL: An image stack from loadtiff WITH associated padarray.
% centroids: (2 x n) matrix representing centroids over time for ONE cell.
%
% OUTPUTS
% cellArea: A matrix with cell areas measured in pixels^2.
% cellPerimeter: A matrix with cell perimeters measured in pixels^2.
%
% @author Neel K. Prabhu

for n = 1:size(ALL,3)
    img = ALL(:,:,n); hminima = 25;                                                                                                
    L = watershed(imhmin(medfilt2(img,[3,3]), hminima));         
    B = imreadgroundtruth(L==0, true); % GT
    B = ~B; % Flip values
    imshow(B)
    cc = bwconncomp(B,4);
    stats = regionprops(cc,'all');
    for m = 1:size(stats,1)
        if stats(m).BoundingBox == [0.5 0.5 size(ALL,1) size(ALL,2)]
            stats(m) = [];
            break;
        end
    end
    statistics{n,1} = stats;
end
h = 5;