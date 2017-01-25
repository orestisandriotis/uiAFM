function [smoothed_load , smoothed_unload, smoothed_holding] = smooth_and_overlap(load,unload,holding)
% SMOOTH_AND_OVERLAP in case of holding data data is just smoothend

%for checking uncomment following lines
% load=fdata_load{1,1};
% unload=fdata_unload{1,1};
% holding=fdata_holding{1,1};



N=nargin;
smoothed_load = sgolayfilt(load,2,35);   
smoothed_unload = sgolayfilt(unload,2,35);

switch N
    case 3  %with holding
        
smoothed_holding = sgolayfilt(holding,2,35);


%figure to check filtering uncomment for use
% figure
% hold on
% plot(load(:,1),load(:,2),'r');
% plot(holding(:,1),holding(:,2),'r');
% plot(unload(:,1),unload(:,2),'r');
% plot(smoothed_load(:,1),smoothed_load(:,2),'b');
% plot(smoothed_holding(:,1),smoothed_holding(:,2),'b');
% plot(smoothed_unload(:,1),smoothed_unload(:,2),'b');
% legend('loading','holding','unloading','loadingSmoothed','holdingSmoothed','unloadingSmoothed')
% 

    case 2  %no holding

% overlap the maximum point of loading curve with the max. point of
% unloading curve.

xmin_load = min(smoothed_load(:,1)); 
ymax_load = max(smoothed_load(:,2));
xmin_unload = min(smoothed_unload(:,1)); 
ymax_unload = max(smoothed_unload(:,2));


if  (xmin_load > xmin_unload) && (ymax_load > ymax_unload)
    xoverlap = xmin_load-xmin_unload;
    yoverlap = ymax_load-ymax_unload;

    smoothed_unload(:,1)=smoothed_unload(:,1)+xoverlap;
    smoothed_unload(:,2)=smoothed_unload(:,2)+yoverlap;
    
elseif  (xmin_load > xmin_unload) && (ymax_load < ymax_unload)
    xoverlap = xmin_load-xmin_unload;
    yoverlap = ymax_unload-ymax_load;
    
    smoothed_unload(:,1)=smoothed_unload(:,1)+xoverlap;
    smoothed_unload(:,2)=smoothed_unload(:,2)-yoverlap;
    
elseif  (xmin_load < xmin_unload) && (ymax_load < ymax_unload)
    xoverlap = xmin_unload-xmin_load;
    yoverlap = ymax_unload-ymax_load;

    smoothed_unload(:,1)=smoothed_unload(:,1)-xoverlap;
    smoothed_unload(:,2)=smoothed_unload(:,2)-yoverlap;
    
elseif  (xmin_load < xmin_unload) && (ymax_load > ymax_unload)
    xoverlap = xmin_unload-xmin_load;
    yoverlap = ymax_load-ymax_unload;

    smoothed_unload(:,1)=smoothed_unload(:,1)-xoverlap;
    smoothed_unload(:,2)=smoothed_unload(:,2)+yoverlap;
end

end