%% mainscript_single_force´-
%This script is for tht analysis of microindentation experiments performed
%with spherical indenters. The indentations on the material must have been 
%done with "force spectroscopy so that the data consists of a couple of
%single *.jpk-force files. To use this file also *.force files (forcemaps)
%the single *.jpk-force files located in the *.force zip first have to be
%unzipped. Therefore also the JPKSPM Data processing software can be used
%(File->Split Map File -> Folder Of Force Curves) or any other unziping
%program can also be used (i.e 7zip)
%
%ADDITIONAL INFORMATION
%SHAPE OF THE CURVES:
%The force-curves should consist of at least 50% data where
%the tip is not in contact with the surface. This is necessary for tilting
%the curves (See contact point). If curves should be analysed which don't 
%have this specification then lower the "p" variable in line 33 in the file
%ContactPoint.m!







%% Cleaning up Matlab workspace
clear 
close all
clc
%% INPUT
%Input data directory
datadir=uigetdir('',...
    'Please select the folder the .*jpk-force data is stored');   
odir = pwd;           %current directory (the skripts are stored in)
prompt = {...
    'Enter the radius of the indenter (um):',...
    'Enter the value of the reference slope:',...
    'Enter the poisson ratio of the sample',...
    'Filename (eg. run1kor149)',...
    'Holding'};
    dlg_title = 'Input data';
    num_lines = 1;
    def = {...
        '7.5',...
        '1.01',...
        '0.5',...
        'g1p105uN',...                  %Run#KOR###Grid## changed 
        'Y'};
    answer = inputdlg(prompt,dlg_title,num_lines,def);  
    radius = str2double(cell2mat(answer(1,1)));
    reference = str2double(cell2mat(answer(2,1)));
    nu = str2double(cell2mat(answer(3,1)));
    sample_name = cell2mat(answer(4,1));
    QHolding=cell2mat(answer(5,1));
% Stores the reference slope, the radius
clear prompt dlg_title num_lines def answer;
% Sets LATEX fonts as default fonts for all figures to be ploted.
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% read the list of all force scan series in the current folder
%Creating a folder "Analysis Data" in datadir for saving the results
mkdir(datadir,'AnalysisData'); 
ADdir=fullfile(datadir,'AnalysisData');
flist = dir(strcat(datadir,'\*.jpk-force')); % Lists directory informatoin in a structure.
[num_of_files, ~] = size(flist); % the number of force maps in the folder.
filename = cell(num_of_files,1);

index(:,1) = 1:num_of_files;
%% Analysis over the force maps.
% prealocate variables FDATA_LOAD, FDATA_UNLOAD and SMOOTHED ONES.
fdata_load = cell(num_of_files,1); 
fdata_unload = cell(num_of_files,1);
fdata_loadS = cell(num_of_files,1); 
fdata_unloadS = cell(num_of_files,1);
f_loadS_OFF = cell(num_of_files,1); 
data_unload = cell(num_of_files,1);
approach = cell(num_of_files,1);
retract = cell(num_of_files,1);
if QHolding=='Y'; %prealocate just if holding time exists in experiements
    fdata_holding = cell(num_of_files,1);
    fdata_holdingS = cell(num_of_files,1);
    data_holding = cell(num_of_files,1);
    holding = cell(num_of_files,1);
end

for i = 1:num_of_files;


filename{i,1} = flist(i,1).name; % takes first force curve
zipContents = listzipcontents(fullfile(datadir,filename{i,1})); % lists contents of zip file 
% without unzipping it

%% unzip certain content from zipped Force Volume Map
unzip(fullfile(datadir,filename{i,1})); % unzip files. Force scan series need to be unzipped before

% further data analysis.
headerDir = findheaderDirectory_FVM(zipContents);
% find the header.properties file in the zipContents.
% The findheaderDirectory function avoids
% stores string of main header in variable
MaiheaderDir = findMainHeader_FVM(zipContents);
% String variable of main header is used as input in function
%% preallocate a structure
if i == 1;  
    switch QHolding
        case 'N';
        mapsData = struct('MapName',cell(i,1),...
                  'load_data',{cell(num_of_files,1)},...
                  'unload_data',{cell(num_of_files,1)},...
                  'SmoothedLoad_data',{cell(num_of_files,1)},...
                  'SmoothedUnload_data',{cell(num_of_files,1)},...
                  'Approach',{cell(num_of_files,1)},...
                  'Retract',{cell(num_of_files,1)}...               
                  );
    
        case 'Y';
       mapsData = struct('MapName',cell(i,1),...
                  'load_data',{cell(num_of_files,1)},...
                  'holding_data',{cell(num_of_files,1)},...
                  'unload_data',{cell(num_of_files,1)},...
                  'SmoothedLoad_data',{cell(num_of_files,1)},...
                  'SmoothedHolding_data',{cell(num_of_files,1)},...
                  'SmoothedUnload_data',{cell(num_of_files,1)},...
                  'Approach',{cell(num_of_files,1)},...
                  'Holding',{cell(num_of_files,1)},...
                  'Retract',{cell(num_of_files,1)}...               
                  );
    end
      
else

end

    % write the name of the i th map
    mapsData(i).MapName=sprintf('force-curve-%d',i);

%% loading data only

    [vDefldir ,segHeaderDir ,heightdir] = findloaddir_FVM(...
                                                   zipContents,index(i,1)); 
% findloaddir: function that automatically assigns the directories in which
% the loading data are located as well as the segment-header.properties.

% segHeaderDir: directory of header properties of segment.
% heightdir: directory of height measured raw data
% vDefldir: directory of vDeflection raw data
    fdata_load{i,1} = writedata(headerDir,segHeaderDir,heightdir,vDefldir);

%%%%%%%%%% HEIGHT DATA %%%%%%%%%%
% fdata_load(:,1)

%%%%%%%%%% DEFLECTION DATA %%%%%%%%%%
% fdata_load(:,2)
    clear segHeaderDir heightdir vDefldir;

%% in case of holding holding data only
if QHolding=='Y';
    [vDefldir ,segHeaderDir ,heightdir] = findholdingdir_FVM(...
                                                   zipContents,index(i,1)); 
% findholdingdir: function that automatically assigns the directories in which
% the holding data are located as well as the segment-header.properties.

% segHeaderDir: directory of header properties of segment.
% heightdir: directory of height measured raw data
% vDefldir: directory of vDeflection raw data
    fdata_holding{i,1} = writedata(headerDir,segHeaderDir,heightdir,vDefldir);

%%%%%%%%%% HEIGHT DATA %%%%%%%%%%
% fdata_load(:,1)

%%%%%%%%%% DEFLECTION DATA %%%%%%%%%%
% fdata_load(:,2)
    clear segHeaderDir heightdir vDefldir;
end
%% unloading data only

    [vDefldir ,segHeaderDir ,heightdir] = findunloaddir_FVM(zipContents,...
                                                            index(i,1),QHolding);
% segHeaderDir: directory of header properties of segment.
% heightdir: directory of height measured raw data
% vDefldir: directory of vDeflection raw data

    [fdata_unload{i,1}, spring_constant] = writedata(headerDir,...
                                                     segHeaderDir,...
                                                     heightdir,vDefldir);

%%%%%%%%%% HEIGHT DATA %%%%%%%%%%
% fdata_unload(:,1)

%%%%%%%%%% DEFLECTION DATA %%%%%%%%%%
% fdata_unload(:,2)
    clear segHeaderDir heightdir vDefldir;



%% smooth data and connect the loading with the unloading curve or in case 
%of holding just smooth data (some of the curves have a gap in between the
%last loading curve data point and the first unloading data point which are
%should be connected)
switch QHolding
    case 'Y'
    [fdata_loadS{i,1} ,fdata_unloadS{i,1},fdata_holdingS{i,1}] = smooth_and_overlap(...
                                        fdata_load{i,1},fdata_unload{i,1},fdata_holding{i,1});
    case 'N'
   [fdata_loadS{i,1} ,fdata_unloadS{i,1}] = smooth_and_overlap(...
                                        fdata_load{i,1},fdata_unload{i,1});    
end
%%%%%% AT THIS POINT DATA WERE SAVED TO VARIABLE "beforeContactPoint.mat"

% plot(fdata_loadS{i,1}(:,1),fdata_loadS{i,1}(:,2),fdata_unloadS{i,1}(:,1),fdata_unloadS{i,1}(:,2))
%% find contact point 
% Reads loading and finds contact point
% The function also applies some tilting of the unloading data.

% Scaling to micrometers to improve numerical properties when finding the
% contact point.
    scaling=1e6;

    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%Contact Point start%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
 switch QHolding
    case 'N'    
    
    [f_loadS_OFF{i,1} ,data_unload{i,1}] = ContactPoint(...
                        fdata_loadS{i,1}*scaling, ...
                        fdata_unloadS{i,1}*scaling);
                    
    case 'Y'   
    [f_loadS_OFF{i,1} ,data_unload{i,1},data_holding{i,1}] =...
                        ContactPoint(fdata_loadS{i,1}*scaling, ...
                        fdata_unloadS{i,1}*scaling,...
                        fdata_holdingS{i,1}*scaling);           
% %%%%%%%%%%%%%%%%%%%%%%%%%%%Contact Point end%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end
% The output data now are in MICROMETERS
%% connect unloading data to loading data or in case of holding just smooth

% approach and retract variables are in MICROMETERS.
switch QHolding
    case 'Y'
    [approach{i,1} ,retract{i,1},holding{i,1}] = smooth_and_overlap(f_loadS_OFF{i,1},...
                                                         data_unload{i,1},data_holding{i,1});
    case 'N'
    [approach{i,1} ,retract{i,1}] = smooth_and_overlap(f_loadS_OFF{i,1},...
                                                         data_unload{i,1});
end        

%% store all variables in the mapsData structure
switch QHolding
    case 'N'

    mapsData(i).load_data{i,1}=fdata_load{i,1}; 
    mapsData(i).unload_data{i,1}=fdata_unload{i,1};
    mapsData(i).SmoothedLoad_data{i,1}=fdata_loadS{i,1};
    mapsData(i).SmoothedUnload_data{i,1}=fdata_unloadS{i,1};
    mapsData(i).Approach{i,1}=approach{i,1};
    mapsData(i).Retract{i,1}=retract{i,1};
    case 'Y'

    mapsData(i).load_data{i,1}=fdata_load{i,1}; 
    mapsData(i).holding_data{i,1}=fdata_holding{i,1};
    mapsData(i).unload_data{i,1}=fdata_unload{i,1};
    mapsData(i).SmoothedLoad_data{i,1}=fdata_loadS{i,1};
    mapsData(i).SmoothedHolding_data{i,1}=fdata_holdingS{i,1};
    mapsData(i).SmoothedUnload_data{i,1}=fdata_unloadS{i,1};
    mapsData(i).Approach{i,1}=approach{i,1};
    mapsData(i).Holding{i,1}=holding{i,1};
    mapsData(i).Retract{i,1}=retract{i,1};


end 
    
    %% delete tmp files
    rmdir('segments','s');
    rmdir('shared-data','s');
    delete header.properties; % deletes file with filename=header.properties
    clear zipContents fdata_load data_unload fdata_loadS fdata_unload ...
          fdata_unloadS f_loadS_OFF approach retract fdata_holding ...
          fdata_holdingS data_holding
end
save (fullfile(ADdir,'data_without_Emodulus.mat'))    
% FROM NOW ON YOU HAVE TO CALL THE MAPSDATA STRUCTURE TO RUN THE REST OF
% THE SCRIPT.

%% overview the data and deside which to disregard from analysis
%maximum value of figure to be shown on one overview slide
figm=9; 

mkdir(fullfile(ADdir,'overview'));
str = cell(1,1);

% preallocate the variable indent    
indent(:,1) = zeros(num_of_files,1);
% total number of curves
indent(:,1) = 1:num_of_files;
    % Set figure properties
    set(groot, 'defaultAxesTickLabelInterpreter','latex');
    set(groot, 'defaultLegendInterpreter','latex');

%the following lines calculate 
if mod(num_of_files,figm)==0
    k=floor(num_of_files/figm);
else
    k=floor(num_of_files/figm)+1;
end

if mod(figm,3)==0;
   columns=3;
   rows=figm/3;
else
   columns=3;
   rows=figm/3+1;
end

for j = 0:k-1;
% Set figure properties    
    locationBeg=num2str(1+9*j);
    locationEnd=num2str(9+9*j);
    figure('Visible','on') 
    figure('units','normalized','outerposition',[0 0 1 1]);
    figure1=gcf;
    figure1.PaperOrientation = 'landscape';
    figure1.Units='centimeters';
    figure1.PaperPositionMode = 'auto';
    axes('Parent',figure1,'FontSize',9);
    % add annotation to figure
    annot = annotation('textbox');
    annot.Position = [0.45,0.95,0.3,0.03];
    annot.Interpreter = 'latex';
    annot.EdgeColor = 'none';
    annot.FitBoxToText = 'on';
    annot.String = sprintf('%s',sample_name);
    
    for i=(1:figm)+(figm*j)    
    % The function OVERVIEW_DATA2FUN is ploting the force curves of a force map
    % in a seperate figure and ASKS from the user to wirte "y" or "n" if the
    % graph is to be taken into account for analysis or not, respectively.
        if i<=num_of_files
        switch QHolding 
            case 'N'
            str{i,1} =  overview_data2fun(rows,...
                                           columns,...
                                              -mapsData(i).Approach{i,1}(:,1),...
                                               mapsData(i).Approach{i,1}(:,2),...
                                              -mapsData(i).Retract{i,1}(:,1),...
                                               mapsData(i).Retract{i,1}(:,2),...
                                               indent(i,1),figm*j...
                                               );
            case 'Y'
            str{i,1} =  overview_data2fun(rows,...
                                           columns,...
                                              -mapsData(i).Approach{i,1}(:,1),...
                                               mapsData(i).Approach{i,1}(:,2),...
                                              -mapsData(i).Retract{i,1}(:,1),...
                                               mapsData(i).Retract{i,1}(:,2),...
                                               indent(i,1),...
                                              -mapsData(i).Holding{i,1}(:,1),...
                                               mapsData(i).Holding{i,1}(:,2),...
                                               figm*j...
                                               );
        
        end
        else
            continue
        end
    end
    % set legend and labels at the last subplot.
    switch QHolding 
        case 'N'
    legend('Load','Unload','Location','best');
        case 'Y'
    legend('Load','Holding','Unload','Location','best');   
    end
    xlabel('Height ($\mu$m)','FontSize',11,'Interpreter','latex');
    ylabel('Deflection ($\mu$m)','FontSize',11,'Interpreter','latex');
    f2 = fullfile(ADdir,'overview',sprintf('%s_Loc%sto%s.pdf',...
        sample_name,locationBeg,locationEnd));
    print(figure1,'-dpdf','-r300',f2 );
    close all
end
    clear annot figure1;

curves_to_ANALYSE=find(strcmp(str,'Yes')==1);   
curves_to_disregard=find(strcmp(str,'No')==1);
 
    

clear indent figure1 axes1 annot i j scaling prompt f2 ans;

save (fullfile(ADdir,'selected_data_for_analysis.mat'));

%% plot all indent curves and save them as png
% In this section the scipt: 
% 1. Asks the user to provide the desirable size in centimeters of the 
% figure to be ploted.
% 2. Checks the total number of indents that are currently analyzed and
% plots:
% a. All if the number of indents is less than 10
% b. 10 uniquely randomly chosen indents.


%++++++++++ Input figure size be in centimeters ++++++++++
       prompt = {'Figure square size in centimeters:'};
       dlg_title = 'Input data';
       num_lines = [1 50];
       def = {'8 and no less than 5'};
       answer = inputdlg(prompt,dlg_title,num_lines,def);  
       figure_size = str2double(cell2mat(answer(1,1)));
       clear prompt dlg_title num_lines def answer;
%   Figure size is then used as an input in the following function with the
%   name PLOT_INDENTATION_CURVE
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%% plot all curves only if there are 4 or less.
% for i = 1 : num_of_files

    mkdir(fullfile(ADdir,'figures')); % creates directory to save plots. (located in AnalysisData folder wher data is stored
    cta=length(curves_to_ANALYSE); %number of curves to analyse

if (cta <= 4)
      indents_to_plot = curves_to_ANALYSE; 
     for i = transpose(indents_to_plot);
       sprintf('Force%d',i)
       name = strcat(sample_name,sprintf('Force%d',i));
       switch QHolding
           case 'N'
               plot_indentation_curve_ps(-mapsData(i).Approach{i,1}(:,1),...
                                       mapsData(i).Approach{i,1}(:,2),...
                                      -mapsData(i).Retract{i,1}(:,1),...
                                       mapsData(i).Retract{i,1}(:,2),...
                                       name,figure_size,i,...
                                       ADdir)
       
           case 'Y'
               plot_indentation_curve_ps(-mapsData(i).Approach{i,1}(:,1),...
                                       mapsData(i).Approach{i,1}(:,2),...
                                      -mapsData(i).Retract{i,1}(:,1),...
                                       mapsData(i).Retract{i,1}(:,2),...
                                       name,figure_size,i,ADdir,...
                                       -mapsData(i).Holding{i,1}(:,1),...
                                       mapsData(i).Holding{i,1}(:,2))           
       end
    %%%%% NOTE %%%%% data are plotted in the positive quadrant although the...
    % height data is negative. This is done by placing a negative sign in ...
    % the above function.
     end
    
elseif (cta > 4)

     indents_to_plot = datasample(curves_to_ANALYSE(:,1),5,...
                                 'Replace',false);   
     for i = transpose(indents_to_plot); % In this case j must be a row list.
       
        sprintf('Force%d',i)
        name = strcat(sample_name,sprintf('Force%d',i));

        switch QHolding
            case 'N'
                plot_indentation_curve_ps(-mapsData(i).Approach{i,1}(:,1),...
                                       mapsData(i).Approach{i,1}(:,2),...
                                      -mapsData(i).Retract{i,1}(:,1),...
                                       mapsData(i).Retract{i,1}(:,2),...
                                       name,figure_size,i,...
                                       ADdir)
            case 'Y'
               plot_indentation_curve_ps(-mapsData(i).Approach{i,1}(:,1),...
                                       mapsData(i).Approach{i,1}(:,2),...
                                      -mapsData(i).Retract{i,1}(:,1),...
                                       mapsData(i).Retract{i,1}(:,2),...
                                       name,figure_size,i,ADdir,...
                                       -mapsData(i).Holding{i,1}(:,1),...
                                       mapsData(i).Holding{i,1}(:,2))           
       end
    %%%%% NOTE %%%%% data are plotted in the positive quadrant although the...
    % height data is negative. This is done by placing a negative sign in ...
    % the above function.
     end
      
end

% end% Selects randomly 5 unique observations from a list

% clear i filename headerDir name zipContents ans

close all;


%% elastic modulus calculation
% NEED TO DO:
% Select positive unloading data
% Select positive loading data
prompt = {'Percent of upper portion to calculate slope (eg. write 0.1 for upper 10%'};
dlg_title = 'Percent to find linear slope';
num_lines = 1;
def = {'0.25'};
answer = inputdlg(prompt,dlg_title,num_lines,def);  
percent = str2double(cell2mat(answer(1,1)));
clear prompt dlg_title num_lines def answer;
DZslope=zeros(length(curves_to_ANALYSE(:,1)),1);
Dmax = zeros(length(curves_to_ANALYSE(:,1)),1);
Zmax = zeros(length(curves_to_ANALYSE(:,1)),1);

%%  Plot the force displacement curves with line fit in postscript
       
if (cta <= 4)
         indents_to_plot = curves_to_ANALYSE;
        for i = transpose(curves_to_ANALYSE(:,1)); % analyzing ONLY the data with the current index
            
            sprintf('Indent%d',i)
            name = strcat(sample_name,sprintf('map%d indent%d',i));
            switch QHolding
                case 'N'
                    plot_linear_fit(mapsData(i).Approach{i,1}(:,1),...
                                    mapsData(i).Approach{i,1}(:,2),...
                                    mapsData(i).Retract{i,1}(:,1),...
                                    mapsData(i).Retract{i,1}(:,2),...
                                    percent,figure_size,name,i,...
                                    ADdir)
                case 'Y'
                    plot_linear_fit(mapsData(i).Approach{i,1}(:,1),...
                                    mapsData(i).Approach{i,1}(:,2),...
                                    mapsData(i).Retract{i,1}(:,1),...
                                    mapsData(i).Retract{i,1}(:,2),...
                                    percent,figure_size,name,i,ADdir,...
                                    mapsData(i).Holding{i,1}(:,1),...
                                    mapsData(i).Holding{i,1}(:,2))                                                    
            end
        end
        
elseif (cta > 4)   
     
     indents_to_plot = datasample(curves_to_ANALYSE(:,1),5,...
                                 'Replace',false);   
     for i = transpose(indents_to_plot);
    
            sprintf('Indent%d',i)
            name = strcat(sample_name,sprintf('map%d indent%d',i));
            switch QHolding
                case 'N'
                    plot_linear_fit(mapsData(i).Approach{i,1}(:,1),...
                                    mapsData(i).Approach{i,1}(:,2),...
                                    mapsData(i).Retract{i,1}(:,1),...
                                    mapsData(i).Retract{i,1}(:,2),...
                                    percent,figure_size,name,i,...
                                    ADdir)
                case 'Y'
                    plot_linear_fit(mapsData(i).Approach{i,1}(:,1),...
                                    mapsData(i).Approach{i,1}(:,2),...
                                    mapsData(i).Retract{i,1}(:,1),...
                                    mapsData(i).Retract{i,1}(:,2),...
                                    percent,figure_size,name,i,ADdir,...
                                    mapsData(i).Holding{i,1}(:,1),...
                                    mapsData(i).Holding{i,1}(:,2))
                                                  
            end
      end   
end


close all;
%% find DZ slope and
 results2 = struct('Filename',cell(length(curves_to_ANALYSE(:,1)),1),...
                  'Index',{zeros(1,1)},...                 
                  'Dmax',{zeros(1,1)},...
                  'Zmax',{zeros(1,1)},...
                  'DZslope',{zeros(1,1)},...
                  'Hmax',{zeros(1,1)},...
                  'Fmax',{zeros(1,1)},...
                  'Hc',{zeros(1,1)},...
                  'Stiffness',{zeros(1,1)},...
                  'Area',{zeros(1,1)},...
                  'Elastic_modulus',{zeros(1,1)}...
                  );         
k=1;    
for i = transpose(curves_to_ANALYSE(:,1)); 
        % here we select only the valid curves to be analyzed!

    % function: DZSLOPE - calculates the slope of deflection versus z.sensor,
    % the maximum deflection and maximum Z.sensor displacement.
        [DZslope(k,1), Dmax(k,1), Zmax(k,1)] = dzslope(...
                            mapsData(i).Approach{i,1}(:,1),...
                            mapsData(i).Approach{i,1}(:,2),...
                            mapsData(i).Retract{i,1}(:,1),...
                            mapsData(i).Retract{i,1}(:,2),percent); 
    

 
    %% preallocate a structure in which the results are stored
    
    results2(k).Filename = filename{k,1};
    results2(k).Index = curves_to_ANALYSE(k,1);    
    results2(k).Dmax = Dmax(k,1);
    results2(k).Zmax = Zmax(k,1);
    results2(k).DZslope = DZslope(k,1);
       
    k=k+1;
end
%% scale data to kPa, MPa or GPa

units=questdlg('The Elastic modulus should be shown in:',...
    'Elastic modulus units',...
    'kPa','MPa','GPa','GPa');
switch units
    case 'kPa'
        scale_value=1e-3;
    case 'MPa'
        scale_value=1e-6;
    case 'GPa'
        scale_value=1e-9;        
end

Hmax = zeros(length(curves_to_ANALYSE(:,1)),1);
stiffness = zeros(length(curves_to_ANALYSE(:,1)),1);
area = zeros(length(curves_to_ANALYSE(:,1)),1);
Hc = zeros(length(curves_to_ANALYSE(:,1)),1);
Ereduced = zeros(length(curves_to_ANALYSE(:,1)),1);
Esample = zeros(length(curves_to_ANALYSE(:,1)),1);
Fmax = zeros(length(curves_to_ANALYSE(:,1)),1);
Ref=1/reference; % unitless


k=1;
for i = transpose(curves_to_ANALYSE(:,1));

    Hmax(k,1) = Zmax(k,1) - Dmax(k,1);
    dD = Dmax(k,1) - (1-percent)*Dmax(k,1); % in um
    dh = dD*(1./DZslope(k,1)-Ref); % in um
    df = dD*spring_constant; % in uN
    stiffness(k,1) = df/dh; % in uN/um or N/m
    Fmax(k,1) = Dmax(k,1).*spring_constant; %in uN
    Hc(k,1) = Hmax(k,1) - 0.75.*Fmax(k,1)/stiffness(k,1); % in um



    area(k,1) = pi*(2*radius.*Hc(k,1)-Hc(k,1)^2);  % in um^2
    Ereduced(k,1) = sqrt(pi./area(k,1))/1.02.*...
                                stiffness(k,1)/2*1e6; %in Pascals: SI
    Esample(k,1) = Ereduced(k,1).*(1-nu^2); %in Pascals: SI
    

    results2(k).Hmax = Hmax(k,1);
    results2(k).Fmax = Fmax(k,1);
    results2(k).Hc = Hc(k,1);
    results2(k).Stiffness = stiffness(k,1);
    

    results2(k).Area = area(k,1);
    results2(k).Elastic_modulus = Esample(k,1)*scale_value;
    k=k+1;
end
clear Dmax Zmax DZslope Hc Hmax Fmax stiffness area Ereduced Esample dD ...
      dh df index ans i j;

%% final step selecting data for post-process
% Here only valid data are selected for statistical analysis
% Valid data are those whose:
% 1. DZslope value ranges between 0.15 to 0.85. Outside this range,
% experience has shown that the sensitivity of the instrument is
% compromised, providing invalid data.
% 2. The stiffness value is negative or ubnormaly large value. Negative 
% stiffness value occurs when the sample is much stiffer than the stiffness
% of the cantilever.

save(fullfile(ADdir,'before_last_filter_data.mat'))


valid = zeros(1,1); % if it comes out that valid=0 then all data are invalid
invalid = zeros(1,1);
valid_index = zeros(1,1);
% NOTE!: If the DZ slope on the sample is very close to the one on the
% glass slide then the stiffness will appear

       results_valid = struct('Filename',cell(1,1),...
                  'Index',{zeros(1,1)},...                 
                  'Dmax',{zeros(1,1)},...
                  'Zmax',{zeros(1,1)},...
                  'DZslope',{zeros(1,1)},...
                  'Hmax',{zeros(1,1)},...
                  'Fmax',{zeros(1,1)},...
                  'Hc',{zeros(1,1)},...
                  'Stiffness',{zeros(1,1)},...
                  'Area',{zeros(1,1)},...
                  'Elastic_modulus',{zeros(1,1)}...
                  );  
k=0;
k2=0;
for i = 1 : length(curves_to_ANALYSE(:,1));

             
        if (results2(i).DZslope > 0.15) && ...
                (results2(i).DZslope < 0.85) && ...
                (results2(i).Stiffness > 0)
            
            valid=k+1; 
            % total number of indices that correspond to valid data    
            k=k+1;
            
            valid_index(i,1) = results2(i).Index;       
            results_valid(k).Filename = results2(i).Filename;
            results_valid(k).Index = results2(i).Index;
            results_valid(k).Dmax = results2(i).Dmax;
            results_valid(k).Zmax = results2(i).Zmax;     
            results_valid(k).DZslope = results2(i).DZslope;
            results_valid(k).Hmax = results2(i).Hmax;    
            results_valid(k).Fmax = results2(i).Fmax;    
            results_valid(k).Hc = results2(i).Hc;    
            results_valid(k).Stiffness = results2(i).Stiffness;    
            results_valid(k).Area = results2(i).Area;    
            results_valid(k).Elastic_modulus = results2(i).Elastic_modulus;
%             

            
        else 
            
            invalid=k2+1;
            k2=k2+1;
        end
        
end

% percentage of valid data from a single force map.

        
         
%% write results in one variable cell
% the variable cell RESULTS is used as input in the function WRITEINTABLE
% to write a txt space delimited file all the results.

for i=1:valid;
    write_InTable(valid,results_valid,units,sample_name,ADdir,odir);
end
save(fullfile(ADdir,sprintf('results_%s.mat',sample_name)));
run subplots_post_analysis_single_force.m
