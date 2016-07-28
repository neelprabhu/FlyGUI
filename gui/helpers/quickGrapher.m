% QUICKGRAPHER A simple script that takes excel data on cell area and
% perimeter and graphs them as a function of frame.
%
% data: A matrix with first column cell indices, second column areas,
% third column perimeters. 


A = [9 16 4 11 5]; % Cells with largest area, smallest area/perimeter, largest perimeter, etc.
areas  = data(:,2);
perims = data(:,3);

figure(1)
counter = 1;
for a = A
    indices = find(data(:,1) == a);
    subplot(2,1,1)
    plot(1:50,areas(indices),'LineWidth',2)
    hold on
    set(gca,'XLim',[1 50])
    subplot(2,1,2)
    plot(1:50,perims(indices),'LineWidth',2)
    hold on
    set(gca,'XLim',[1 50])
    counter = counter + 1;
end

subplot(2,1,1)
title('Area of Five Amnioserosa Cells vs. Time')
xlabel('Time (frame)')
ylabel('Area (pixels^2)')
text(2,1300,'8','Color','b','FontSize',15)
text(4,1250,'10','Color',[0.6 0 1],'FontSize',15)
text(2,950,'4','Color',[1 0.5 0.2],'FontSize',15)
text(2,500,'15','Color',[0 0.5 0],'FontSize',15)
text(2,200,'16','Color',[1 0 0],'FontSize',15)

subplot(2,1,2)
title('Perimeter of Five Amnioserosa Cells vs. Time')
xlabel('Time (frame)')
ylabel('Perimeter (pixels)')