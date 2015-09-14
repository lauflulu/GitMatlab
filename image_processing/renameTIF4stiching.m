% this script inverts the x,y enumeration of IX71 images for stiching with
% FIJI

% Directory of the files
oldpathPrefix = 'C:\Users\Lukas\Documents\Studium\Lab\PicturesIX71\150717\thewholechip-22h-later_1\';
newpathPrefix = 'C:\Users\Lukas\Documents\Studium\Lab\PicturesIX71\150717\thewholechip-22h-later_1_Kopie\';
mkdir(newpathPrefix)
% Retrieve the name of the files only
nameList = dir(strcat(oldpathPrefix,'*.tif'));
nameList = {nameList(~[nameList.isdir]).name};

nameListSplitted = regexp(nameList, '[._]', 'split');


xList = cell(1,length(nameListSplitted));
yList = cell(1,length(nameListSplitted));

for i=1:length(nameList);
    xList{i}=[nameListSplitted{i}{5}];
    yList{i}=[nameListSplitted{i}{6}];
end

xList = str2double(xList);
yList = str2double(yList);

xWidth=max(xList)+1;
yHeight=max(yList)+1;

for i=1:length(nameList);
    xxx=xWidth-xList(i)-1;
    yyy=yHeight-yList(i)-1;
    newName = sprintf('Tile_%03d_%03d.ome.tif', [xxx,yyy]);
    movefile( strcat(oldpathPrefix,nameList{i}), strcat(newpathPrefix,newName))
end






