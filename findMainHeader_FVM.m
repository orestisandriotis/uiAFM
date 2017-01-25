%% find directory of MAIN header properties
% We need this to find the pixel resolution
function MaiheaderDir = findMainHeader_FVM(zipContents)

n=length(zipContents);
string = 'header.properties';

% header.properties directory
for cell = 1 : n;
   isequal=strcmp(zipContents{cell,1},string);
   if (isequal == 1);
        MaiheaderDir = zipContents{cell,1};
%         display(cell)
   elseif isequal == 0;
        continue
   end
end