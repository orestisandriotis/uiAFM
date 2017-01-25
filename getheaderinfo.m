% getheaderinfo
% reads header from a force scan series and extracts the scaling
% parameters.

function [mult_height_meters1 ,offset_height_meters1...
                   ,mult_height_meters2 ,offset_height_meters2...
                   ,mult_vDefl_volts ,offset_vDefl_volts...
                   ,sensitivity ,spring_constant] = getheaderinfo(filedirectory)

fileID=fopen(filedirectory,'rt','n','UTF-8'); % fileID = fopen(filename,permission,machinefmt,encodingIn)
A=fileread(filedirectory);
%% Height: 1. CONVERSION raw-meters & 2. SCALE meters
% Conversion RAW -> VOLTS
fseek(fileID,1,'cof'); % goes at the first position in the file

%   Multiplier
    B=strfind(A,'lcd-info.3.encoder.scaling.multiplier=');
    % strfind(file,string) is looking for a specific string in the file.
    fseek(fileID,B,'cof');
    % moves at the location where specific string is located 
    tline = fgetl(fileID);
    % stores that string in a character
    where=strfind(tline,'=');
    % "where" is the position of the "=" symbol in the tline string
    mult_height_meters1 = str2double(... % convert the string to number
                        tline(where+1:end)... % this is the number
                                    );
                                
%   Offset
    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.3.encoder.scaling.offset=');
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    offset_height_meters1 = str2double(tline(where+1:end));


% SCALING METERS -> METERS
    
%   Multiplier
    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.3.conversion-set.conversion.nominal.scaling.multiplier=');    
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    mult_height_meters2 = str2double(tline(where+1:end));
 

%   Offset
    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.3.conversion-set.conversion.nominal.scaling.offset=');    
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    offset_height_meters2 = str2double(tline(where+1:end));


%% vDeflection: 1. CONVERSION raw-volts & 2. volts to meters
% Conversion RAW -> VOLTS
    
%   Multiplier
    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.2.encoder.scaling.multiplier=');    
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    mult_vDefl_volts = str2double(tline(where+1:end)); % multiplier for scaling the raw height data and convert to volts

%   Offset
    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.2.encoder.scaling.offset=');    
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    offset_vDefl_volts = str2double(tline(where+1:end)); 


% Conversion VOLTS -> METERS
    
%   Multiplier (that is the sensitivity measured in meters per Volts)
    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.2.conversion-set.conversion.distance.scaling.multiplier=');    
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    sensitivity = str2double(tline(where+1:end));

%% Spring constant

    clear tline where;
    frewind(fileID);
    B=strfind(A,'lcd-info.2.conversion-set.conversion.force.scaling.multiplier=');    
    fseek(fileID,B,'cof'); 
    tline = fgetl(fileID);
    where=strfind(tline,'=');
    spring_constant = str2double(tline(where+1:end));
    
clear tline A B where 

fclose(fileID);



