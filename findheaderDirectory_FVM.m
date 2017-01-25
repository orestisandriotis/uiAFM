%% find directory of header properties
function headerDir = findheaderDirectory_FVM(zipContents)

n=length(zipContents);
string = 'shared-data/header.properties';

% header.properties directory
for cell = 1 : n;
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        headerDir = zipContents{cell,1};
   elseif isequal == 0;
        continue
   end
end