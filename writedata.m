function [fdata ,spring_constant]=...
            writedata(HeaderFileDirectory,SegmentHeaderFileDirectory,...
                        HeighDataDirectory,vDelfDataDirectory)

% HeaderFileDirectory: file directory of the main header properties. There
% is the information about the scaling factors to convert the raw data.
% SegmentHeaderFileDirectory: file directory of the header of each segment.
% Each segment means the loading (#0) and unloading (#1).

% HeighDataDirectory: file directory of height.dat file
% vDelfDataDirectory: file directory of vDeflection.dat file
% 
%% find the number of total points
A=fileread(SegmentHeaderFileDirectory);
fileID=fopen(SegmentHeaderFileDirectory,'rt','n','UTF-8');
% fileID = fopen(filename,permission,machinefmt,encodingIn)

B=strfind(A,'force-segment-header.num-points=');
% strfind(file,string) is looking for a specific string in the file.
fseek(fileID,B,'cof');
% moves at the location where specific string is located 

tline = fgetl(fileID);
where=strfind(tline,'=');
% "where" is the position of the "=" symbol in the tline string
n = str2double(tline(where+1:end)); % number of points    
fclose(fileID);

%% Read the height measured data and the vertical deflection.
% Reading the raw height data into a column of length n              
fileID = fopen(HeighDataDirectory);
% fread(fileID,sizeA,precision,skip,machinefmt)
RawHeight = fread(fileID,n,'int32',0,'b'); %raw data
fclose(fileID);


% Reading the deflection height data into a column of length n      
fileID = fopen(vDelfDataDirectory);
RawvDeflection = fread(fileID,n,'int32',0,'b'); %raw data


%% get scaling factors from header file
% calls getheaderinfo function to extract the scaling factors.
% All the scaling factors are included in the header.properties file and
% not the segment-header.properties.
[mult_height_meters1, offset_height_meters1,...
                   mult_height_meters2, offset_height_meters2,...
                   mult_vDefl_volts, offset_vDefl_volts,...
                   sensitivity, spring_constant] =...
                   getheaderinfo(HeaderFileDirectory);
%% converts raw data and writes them into one varialble 'fdata'

% converts raw into volts by calling the getheaderinfo function
heightvolts = RawHeight.*mult_height_meters1 + offset_height_meters1;

deflvolts=RawvDeflection.*mult_vDefl_volts + offset_vDefl_volts;

% converts volts into meters
height_meters = heightvolts.*mult_height_meters2 + offset_height_meters2;
% height_meters = heightvolts.*mult_height_meters + offset_height_meters;
deflmeter=deflvolts.*sensitivity;

fdata(:,1) = height_meters;

fdata(:,2) = deflmeter;

clear tline SegmentHeaderFileDirectory HeighDataDirectory...
      vDelfDataDirectory mult_height_volts offset_height_volts...
                   mult_height_meters offset_height_meters...
                   mult_vDefl_volts offset_vDefl_volts...
                   mult_vDefl_meters 
fclose(fileID)



