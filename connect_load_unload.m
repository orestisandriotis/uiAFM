function [data_unload] = connect_load_unload(load,unload)
% CONNECT_LOAD_UNLOAD
% This function should run after the 

% smoothed_load(:,1)=load(:,1); 
% smoothed_load(:,2)=load(:,2);

data_unload(:,1)=unload(:,1);
data_unload(:,2)=unload(:,2);

xmin_load = min(load(:,1)); 
ymax_load = max(load(:,2));
xmin_unload = min(data_unload(:,1)); 
ymax_unload = max(data_unload(:,2));


if  (xmin_load > xmin_unload) && (ymax_load > ymax_unload)
    xoverlap = xmin_load-xmin_unload;
    yoverlap = ymax_load-ymax_unload;

    data_unload(:,1)=data_unload(:,1)+xoverlap;
    data_unload(:,2)=data_unload(:,2)+yoverlap;
    
elseif  (xmin_load > xmin_unload) && (ymax_load < ymax_unload)
    xoverlap = xmin_load-xmin_unload;
    yoverlap = ymax_unload-ymax_load;
    
    data_unload(:,1)=data_unload(:,1)+xoverlap;
    data_unload(:,2)=data_unload(:,2)-yoverlap;
    
elseif  (xmin_load < xmin_unload) && (ymax_load < ymax_unload)
    xoverlap = xmin_unload-xmin_load;
    yoverlap = ymax_unload-ymax_load;

    data_unload(:,1)=data_unload(:,1)-xoverlap;
    data_unload(:,2)=data_unload(:,2)-yoverlap;
    
elseif  (xmin_load < xmin_unload) && (ymax_load > ymax_unload)
    xoverlap = xmin_unload-xmin_load;
    yoverlap = ymax_load-ymax_unload;

    data_unload(:,1)=data_unload(:,1)-xoverlap;
    data_unload(:,2)=data_unload(:,2)+yoverlap;
end

