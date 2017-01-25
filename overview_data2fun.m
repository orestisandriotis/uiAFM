 function [input_answer] = overview_data2fun(rows,columns,...
                            approach_x,approach_y,...
                            retract_x,retract_y,...
                            indent,...
                            holding_x,holding_y,previous_plots)
% OVERVIEW_DATA2FUN
% INPUTS: rows and columns which are used to define the position of the
% subplots. Approach and retract data as well as the number of the indent.
% OUTPUT: Asks the user to whether the ploted graph is to be used for
% analysis or not. 
%% plotting all curves in one figure and save as pdf in A4 Landscape.
N=nargin;
subplot(rows,columns,indent-previous_plots);

% plot loading: in micrometers by scaling 10^6
plot(approach_x*10^6,approach_y*10^6)
% to plot the unloading curve in same subplot
hold on;
grid on;
if N==10; %holding exists
    %plot holding: in micrometers by scaling 10^6
   plot(holding_x*10^6,holding_y*10^6) 
end
% plot unloading: in micrometers by scaling 10^6
plot(retract_x*10^6,retract_y*10^6)
scatter(0,0,'Filled');


ax=gca;


input_answer=questdlg('Do you want this graph?',...
    'Graphselection',...
    'Yes','No','No');




% number above subplot to identify index of indent 

if isequal(input_answer,'Yes');
    % Set the remaining axes properties  
    ax.XColor = 'b';
    ax.YColor = 'b';
        
elseif isequal(input_answer,'No');
    % Set the remaining axes properties  
    ax.XColor = 'r';
    ax.YColor = 'r';
    
end

title(sprintf('%d',indent))



