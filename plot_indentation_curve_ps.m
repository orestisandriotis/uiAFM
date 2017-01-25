function plot_indentation_curve_ps(approach_x,approach_y,...
                                       retract_x,retract_y, name,...
                                       figure_size,n,ADdir,holding_x,holding_y)
% i=3;
% approach_x=-mapsData(i).Approach{i,1}(:,1);
% approach_y=mapsData(i).Approach{i,1}(:,2);
% retract_x=-mapsData(i).Retract{i,1}(:,1);
% retract_y=mapsData(i).Retract{i,1}(:,2);
% name=name;
% figure_size=figure_size;
% n=i,
% holding_x=-mapsData(i).Holding{i,1}(:,1);
% holding_y=mapsData(i).Holding{i,1}(:,2);
                                   
                                   
                                   
N=nargin-1; %number of inputs: minus is cause of ADdir was added additionally                                  
% 
figure('Visible','off');
% Sets size of figure in centimeters
figure2 = gcf;
set(figure2, 'NextPlot', 'replace');
figure2.Units='centimeters';
figure2.Position = [10 10 figure_size figure_size];
figure2.PaperUnits='centimeters';
figure2.PaperPosition = [10 10 figure_size figure_size];
% Automatically places figure in center of an A4 paper
figure2.PaperPositionMode = 'auto';
% Sets the size of the paper to the same size of the figure.
figure2.PaperSize = [figure_size figure_size];
% scrsz = get(0,'ScreenSize');
% set(figure1, 'Position',[scrsz(3)-1000 scrsz(4)-800 scrsz(3)/3 scrsz(4)/2]);
% set(figure2, 'units', 'centimeters', 'pos', [32 10 8 8])

% axes1 = axes('Parent',figure2,'FontSize',9,'FontName','Times');
% 
axes1 = axes('Parent',figure2,'FontSize',9);
% set(groot, 'defaultAxesTickLabelInterpreter','latex');
% set(groot, 'defaultLegendInterpreter','latex');
ax=gca;
ax.GridLineStyle = '--';
grid 'on';

hold(axes1,'all');
box(axes1,'on');
%% sets the limits of the x and y axes.
xmin = 0;
switch N
    case 7;    %case no holding data exists
    xmax = max(approach_x);
    case 9;    %case holding data exists
    xmax = max(retract_x);    
end
ymin = 0;
ymax = max(approach_y);
axis([xmin xmax+0.1*xmax ymin ymax+0.1*ymax])
%% plots data
plot(approach_x,approach_y)
if N==9;    %case holding data exists
   plot(holding_x,holding_y); 
end
plot(retract_x,retract_y)
%% adds labels

xlabel('Height ($\mu$m)','FontSize',10,'Interpreter','Latex');
ylabel('Deflection ($\mu$m)','FontSize',10,'Interpreter','Latex');

%% resizes the length of the legend line
if N==7;
[~, hobj1]=legend('Loading','Unloading','Location','best');
end
if N==9;
[~, hobj1]=legend('Loading','Holding','Unloading','Location','best');
end
textobj = findobj(hobj1, 'type', 'line');
% finds x coordinate of line legend
lineXData = get(textobj(1), 'XData');
lineXData2 = get(textobj(3), 'XData');
if N==9;    %case of holding
   lineXData3 = get(textobj(5), 'XData'); 
end
%  new x coordinates to resize the length line of the legend
lineXData(1) = 0.3;  
lineXData2(1) = 0.3;
if N==9;
   lineXData3(1) = 0.3; 
end
% sets the new x coordinate - line length resized
set(textobj(1), 'XData', lineXData);
set(textobj(3), 'XData', lineXData2);
if N==9;
   set(textobj(5), 'XData', lineXData3); 
end

% removes legend border and backgrand
legend boxoff


title(sprintf('Indent %d', n))

% 
% print(figure2,'-dpsc','-r300',name);

folder = strcat(ADdir,'\','figures');
f = fullfile(folder,sprintf('%s.ps',name));
print(figure2,'-dpsc','-r300',f );
f2 = fullfile(folder,sprintf('%s.png',name));
print(figure2,'-dpng','-r600',f2 );

close(figure2);
