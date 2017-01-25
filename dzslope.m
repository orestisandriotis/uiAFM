
function [DZslope ,Dmax ,Zmax]= dzslope(approach_X,approach_Y,retract_X,retract_Y,percent)


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
DZslope = a(1);
Zmax=max(pos_retract(:,1));
Dmax = max(pos_retract(:,2));


