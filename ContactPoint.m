function [f_loadS_OFF ,data_unload,data_holding] = ContactPoint(smoothed_load, smoothed_unloadS,smoothed_holding)
%%%%%%%%%%% CONTACTPOINT: performs offset and tilt. Smoothing is also
%%%%%%%%%%% perfomed to the data by applying a moving_average.

N=nargin;   %number of inputs
% ++++++++++++++++++++++++++++++
% uncomment this to check the function on a set of data.
%N=2 %for no holding
% N=3 %with holding
% smoothed_load(:,1) = fdata_loadS{1,1}(:,1)*scaling;
% smoothed_load(:,2) = fdata_loadS{1,1}(:,2)*scaling;
% smoothed_unloadS(:,1) = fdata_unloadS{1,1}(:,1)*scaling;
% smoothed_unloadS(:,2) = fdata_unloadS{1,1}(:,2)*scaling;
% smoothed_holding(:,1)=fdata_holdingS{1,1}(:,1)*scaling;
% smoothed_holding(:,2)=fdata_holdingS{1,1}(:,2)*scaling;
% %++++++++++++++++++++++++++++++
% 
% figure
% hold on
% plot(smoothed_load(:,1),smoothed_load(:,2))
% plot(smoothed_unloadS(:,1),smoothed_unloadS(:,2))
% plot(smoothed_holding(:,1),smoothed_holding(:,2))
% xlabel('height'); ylabel('deflection')
% hold off


% Prealocate the offset data to a cell.

%% Store p% of Z-length data into x and y variables. 
%this is needed for tilting the data according the first 50% of the
%approach. The experiments should have been done in a way, that the 'not-
%in contact' part of the curves are at least 50% of the whole data.
    p=50;   %percentage of Z_length which should be stored
    xmin=min(smoothed_load(:,1));% mininum height
    [xmax ,row]=max(smoothed_load(:,1));% maximum height

    difference1=xmax-xmin; % the absolute height distance covered (Z length)
    n=((1-p/100)*difference1)+xmin; 
    % n is height value that corresponds to the upper p% of the approach
    % data.
    
%     nload=length(fdata_loadS{i,1}(:,1));

    index=max(find(smoothed_load(:,1)>=n)); 
    
    
    x=zeros(index,1);
    y=zeros(index,1);
    x(:,1) = smoothed_load(1:index,1);
    y(:,1) = smoothed_load(1:index,2); 


    
    
    
%% 1. Linear fit and substract data (TILTING)
%%%%%%%&&&&&&& 1st Y-OFFSET &&&&&&&%%%%%%%

%%%%%%% LINEAR FIT OF APPROACH NON CONTACT DATA %%%%%%%
    p1 = polyfit(x(:,1),y(:,1),1);
    ytemp(:,1) = polyval(p1,smoothed_load(:,1)); %tilting approach
    ytemp_unload(:,1) = polyval(p1,smoothed_unloadS(:,1)); %tilting holding
    if N==3
       ytemp_holding(:,1)=polyval(p1,smoothed_holding(:,1)); %tilt unload
    end
%  Uncomment below to view plot
%     figure;
%     hold on
%     plot(x(:,1),y(:,1),'o','LineStyle','none','Color',[0.8 0.8 0.8])
%     plot(smoothed_load(:,1),smoothed_load(:,2))
%     plot(x(:,1),polyval(p1,x(:,1)),'-r')
%     hold off

%%%%%%% SUBTRACT LINEAR FIT FROM DEFLECTION DATA %%%%%%%
sub1(:,1) = smoothed_load(:,2) - ytemp(:,1); % LOAD
sub1_unload(:,1) = smoothed_unloadS(:,2) - ytemp_unload(:,1); % UNLOAD
switch N
    case 2  %case no holding exists. if holding would exist data_unload would be overwriten later once again
data_unload(:,2) = sub1_unload(:,1);          
data_unload(:,1) = smoothed_unloadS(:,1);

    case 3 %with Holding
   sub1_holding(:,1)=smoothed_holding(:,2)-ytemp_holding(:,1); 
   data_holding(:,2)=sub1_holding(:,1);
   data_holding(:,1)=smoothed_holding(:,1);
end
% 
%     figure;
%     grid on
%     hold on
%     plot(smoothed_load(:,1),sub1(:,1),'-r','LineWidth',1.5)
%     plot(smoothed_unloadS(:,1),sub1_unload(:,1),'-r','LineWidth',1.5)
%     plot(smoothed_holding(:,1),sub1_holding(:,1),'-r','LineWidth',1.5)
%     plot([2.5e-6 6.5e-6],[0 0],'-b','LineWidth',1.5)
%     hold off  


%% find contact point based on the 1st derivative of the smoothed data.

% smooth with RLOWESS and set the degree of smoothing to 0.015. This number
% was selected to be the most approapriate as it gives more representative
% smoothed data of the original data. 

rloess(:,1)=smooth(sub1(:,1),0.015,'rloess');

%%  First derivative calculation to find contact point.
dy = diff(rloess(:,1));     
dx = diff(smoothed_load(:,1));
deriv1 = dy./dx; 

% flip the deriv1 list
moving_deriv(:,1)=smooth(deriv1(:,1),'moving');    %changed '0.02,'rloess'' to 'moving'
rloess_deriv(:,1)=smooth(deriv1(:,1), 0.02,'rloess');
% smooths the derivative.

flippedDeriv=flipud(moving_deriv);
% plot(fdata_loadS{i,1}(1:length(deriv1),1),flippedDeriv,'.g','LineWidth',1.5)
% DATA ARE FLIPPED TO START ITERATING TO SEARCH FOR THE FIRST TIME THE 0
% POINT APPEARS. THIS IS THE POSITION OF THE CONTACT POINT. DATA THEN
% SHOULD AGAIN BE FLIPPED AND ALSO FIND A WAY TO DETERMINE THE POSITION OF
% THE 0 POINT IN THE LIST. THIS POSITION IS THE ELEMENT OF THE X-YOFFSET.
% 
% for k = [length(deriv1),7000,5000,4000,3000,2000,1000,500,200,100];   
%     figure;
%     plot(fdata_loadS{i,1}(1:k,1),deriv1(1:k,1)*10^-6,'-m','LineWidth',1.5) 
%     hold on
%     plot(fdata_loadS{i,1}(:,1),sub3(:,1),'-r','LineWidth',1.5)
%     title(['data range 1 to',int2str(k)])
% end

ii=find(flippedDeriv(:,1)>0, 1 ); 
    
    position = length(moving_deriv)-ii;   
    
%  figure;
%  hold on
%  grid on
%  plot(smoothed_load(1:end-1,1),deriv1(:,1),'Linewidth',1.5)
%  plot(smoothed_load(1:end-1,1),rloess_deriv(:,1),'Linewidth',1.5)
%  plot(smoothed_load(1:end-1,1),moving_deriv(:,1),'Linewidth',1.5)
% 
%  plot(smoothed_load(:,1),sub1(:,1),'Linewidth',1.5)
%  
%  legend('-','-','1st derivative','smoothed derivative','original y-offset data')
% hold off


 xoffset = smoothed_load(position,1);
    yoffset = rloess(position,1);
    
%     
%     
%     figure;
%     hold on
%     grid on
%     plot(smoothed_load(:,1),rloess,'o','LineWidth',1) 
%     plot([xoffset xoffset],[-0.5e-8 4e-8],'--','LineWidth',1) %line at X
%     plot([2.5e-6 6.5e-6],[0 0],'--','LineWidth',1) %line at Y=0
% 
%     
%% store offset data


% Apply x-y offset on original data and store them.
f_loadS_OFF(:,1) = smoothed_load(:,1)-xoffset;
f_loadS_OFF(:,2) = sub1(:,1) - yoffset; 

if N==3;    %holding exists
    data_unload(:,2) = sub1_unload(:,1)-yoffset;
    data_unload(:,1) = smoothed_unloadS(:,1)-xoffset;
    
    data_holding(:,2)=sub1_holding(:,1)-yoffset;
    data_holding(:,1)=smoothed_holding(:,1)-xoffset;
    
end

%     figure;
%     hold on
%     grid on
%     plot(f_loadS_OFF(:,1),f_loadS_OFF(:,2),'o','LineWidth',1)
%     xlim1=min(f_loadS_OFF(:,1));
%     xlim2=max(f_loadS_OFF(:,1));
%     plot([xlim1 xlim2],[0 0],'--','Color',[0 0 0],'LineWidth',1) %line at Y=0
%     ylim1=min(f_loadS_OFF(:,2));
%     ylim2=max(f_loadS_OFF(:,2));
%     plot([0 0],[ylim1+0.2*ylim1 ylim2+0.1*ylim1],'--','Color',[0 0 0],'LineWidth',1) %line at x=0
%     legend('Approad at contact point')




clear moving_average dy dx deriv1 sub1 sub2 sub3 xmin xmax temp x y p1...
      p2 p3 row j x1 y1 flippedDeriv index ytemp xoffset yoffset position...
      ii n unloadtemp loadtemp sub1_unload ytemp_unload
  




