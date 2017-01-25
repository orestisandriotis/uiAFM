function [pixel_numberi, pixel_numberj] = pixel_resolution(MaiheaderDir)

%% find the pixel resolution
A=fileread(MaiheaderDir);
fileID=fopen(MaiheaderDir,'rt','n','UTF-8');
% fileID = fopen(filename,permission,machinefmt,encodingIn)
%%
B=strfind(A,'force-scan-map.position-pattern.grid.ilength=');
% strfind(file,string) is looking for a specific string in the file.
fseek(fileID,B,'cof');
% moves at the location where specific string is located 

tline = fgetl(fileID);
where=strfind(tline,'=');
% "where" is the position of the "=" symbol in the tline string
pixel_numberi = str2double(tline(where+1:end)); % number of points    
fclose(fileID);
%%
fileID=fopen(MaiheaderDir,'rt','n','UTF-8');
B=strfind(A,'force-scan-map.position-pattern.grid.jlength=');
% strfind(file,string) is looking for a specific string in the file.
fseek(fileID,B,'cof');
% moves at the location where specific string is located 

tline = fgetl(fileID);
where=strfind(tline,'=');
pixel_numberj = str2double(tline(where+1:end)); % number of points
fclose(fileID);