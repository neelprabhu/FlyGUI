for n = 1:10
    figure(1)
    area = cat(1,s{n}.Perimeter)';
    histogram(area,10)
    pause(1)
    close;
end
