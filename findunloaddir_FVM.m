%% find directory of header properties
%in case of no holding exists string in line 8,20,32 has to be 'segments/1/channels/vDeflection.dat'
%in case of holding exists string in line 8,20,32  has to be 'segments/2/channels/vDeflection.dat'

function [vDefldir ,segHeaderDir ,heightdir] = findunloaddir_FVM(zipContents,index,QHolding)

switch QHolding %Differ between case that holding or no holding
    case 'N' %No holding data exists
n=length(zipContents);
% vDeflection.dat directory
string = sprintf('segments/1/channels/vDeflection.dat',index);
for cell = 1 : n;   
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        vDefldir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end

end

% segment-header.properties directory
string = sprintf('segments/1/segment-header.properties',index);
for cell = 1 : n;   
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        segHeaderDir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end

end

% capacitiveSensorHeight.dat directory
string = sprintf('segments/1/channels/measuredHeight.dat',index);   %changed capacitiveSensorHeight to measuredHeight
for cell = 1 : n;   
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        heightdir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end
   
end

    case 'Y' %Holding exists
        
n=length(zipContents);
% vDeflection.dat directory
string = sprintf('segments/2/channels/vDeflection.dat',index);
for cell = 1 : n;   
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        vDefldir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end

end

% segment-header.properties directory
string = sprintf('segments/2/segment-header.properties',index);
for cell = 1 : n;   
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        segHeaderDir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end

end

% capacitiveSensorHeight.dat directory
string = sprintf('segments/2/channels/measuredHeight.dat',index);   %changed capacitiveSensorHeight to measuredHeight
for cell = 1 : n;   
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        heightdir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end
   
end
        


end