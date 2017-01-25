function plot_linear_fit(approach_X,approach_Y,retract_X,...
                            retract_Y,percent,figure_size,name,n,...
                            ADdir,holding_X,holding_Y)
N=nargin-1; %number of inputs: -1 is caus ADdir was added additionally
flipretract_x(:,1) = -retract_X; % makes positive the Z-displacement
[~, row]=max(retract_Y); % stores the position of the maximum deflection.

index = 1;
% The while loop below stores the positive unloading data only.
while ((flipretract_x(row ,1) > 0) && (retract_Y(row ,1) > 0))
    pos_retract(index,1) = flipretract_x(row,1);
    pos_retract(index,2) = retract_Y(row,1); 
    
    row=row+1;
    index = index+1;
end

clear row

flipapproach_x(:,1) = -approach_X;
[~, row]=max(approach_Y);


index = 1;
% The while loop below stores the positive loading data only.
while ((flipapproach_x(row ,1) > 0) && (approach_Y(row ,1) > 0))
    pos_approach(index,1) = flipapproach_x(row,1);
    pos_approach(index,2) = approach_Y(row,1);
    row=row-1;
    index = index+1;
end

% select the upper portion of the unloading curve that 
y_lower=(1-percent)*max(pos_retract(:,2));
clear row index
[~, row]=max(pos_retract(:,2));
while (pos_retract(row,2) > y_lower)
    row=row+1;
end

[a]=polyfit(pos_retract(1:row,1),pos_retract(1:row,2),1);

xmin=-a(2)/a(1);
Zmax=max(pos_retract(:,1));
x = xmin:(Zmax-xmin)/100:Zmax;
y = a(1)*x+a(2);
clear Zmax

%% plot the linear fit for review
figure('Visible','off');

% Sets size of figure in centimeters
figure2 = gcf;

figure2.Units='centimeters';
figure2.Position = [10 10 figure_size figure_size];
figure2.PaperUnits='centimeters';
figure2.PaperPosition = [10 10 figure_size figure_size];
figure2.PaperPositionMode = 'auto';
figure2.PaperSize = [figure_size figure_size];
axes1 = axes('Parent',figure2,'FontSize',9,'FontName','Times');
hold(axes1,'all');
box(axes1,'on');
%% sets the limits of the x and y axes.
xmin = 0;
xmax = max(pos_retract(:,1));
ymin = 0;
Dmax = max(pos_retract(:,2));
axis([xmin xmax+0.1*xmax ymin Dmax+0.1*Dmax])
%% plots data

if N==10;
plot(pos_approach(:,1),pos_approach(:,2),-holding_X,holding_Y,...
    pos_retract(:,1),pos_retract(:,2))
end
if N==8;
plot(pos_approach(:,1),pos_approach(:,2),...
    pos_retract(:,1),pos_retract(:,2))
end

plot(x,y,'-','Color',[0.8 0.2 0.8])

plot(pos_retract(1:row,1),pos_retract(1:row,2),'Color',[0.2 0.6 0.2])

%% adds labels
xlabel('Height ($\mu$m)','FontSize',10,'Interpreter','Latex');
ylabel('Deflection ($\mu$m)','FontSize',10,'Interpreter','Latex');

%% resizes the length of the legend line
if N==8;
[~, hobj1]=legend('Loading','Unloading','Linear fit',...
    sprintf('Upper %d percent', percent*100),'Location','northwest');
end
if N==10;
[~, hobj1]=legend('Loading','Holding','Unloading','Linear fit',...
    sprintf('Upper %d percent', percent*100),'Location','northwest');
end
textobj = findobj(hobj1, 'type', 'line');
% finds x coordinate of line legend
lineXData = get(textobj(1), 'XData');
lineXData2 = get(textobj(3), 'XData');
lineXData3 = get(textobj(5), 'XData');
lineXData4 = get(textobj(7), 'XData');
if N==10;
    lineXData5 = get(textobj(9), 'XData');
end
%  new x coordinates to resize the length line of the legend
lineXData(1) = 0.3;  
lineXData2(1) = 0.3;
lineXData3(1) = 0.3;
lineXData4(1) = 0.3;
if N==10;
    lineXData5(1)=0.3;
end
% sets the new x coordinate - line length resized
set(textobj(1), 'XData', lineXData);
set(textobj(3), 'XData', lineXData2);
set(textobj(5), 'XData', lineXData3);
set(textobj(7), 'XData', lineXData4);
if N==10;
    set(textobj(9), 'XData', lineXData5);
end
% removes legend border and backgrand
legend boxoff
title(sprintf('Linear Fit of indent%d', n))

% print(figure2,'-dpsc','-r300',sprintf('%s_linFit',name));

folder = strcat(ADdir,'\','figures');
f = fullfile(folder,sprintf('%s_linFit.ps',name));
print(figure2,'-dpsc','-r300',f );

f2 = fullfile(folder,sprintf('%s_linFit.png',name));
print(figure2,'-dpng','-r600',f2 );

close(figure2);

