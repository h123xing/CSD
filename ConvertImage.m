function [] = ConvertImage
%Converts TIFF stack to 3D array
    %Primarily uses imread to convert each frame into a 2D layer for the
    %array

% asks user to select file and save directory
[filename, filePath] = uigetfile('*.tif','Select TIFF stack');
savePath = uigetdir(filePath,'Select Data folder');

%gets information about image
%   imfinfo allows for faster access to individual frames later
info = imfinfo(filename);
arraySize = length(info);

% preallocates a 3D array
x = uint8(zeros(info(1).Width,info(1).Height,arraySize));

%for display of status
lPrompt = 10;
sizeStr = num2str(arraySize);
disp(' ');

%fills in the 3D array
for k = 1:arraySize
    % note: image transposed into array because FastFlow seems to
    % transpose array onto GUI
    x(:,:,k) = transpose(imread(filename,'Index',k));
    
    %display status
    str = sprintf(['Frame: %d' '/' sizeStr],k);
    if (k==1)
        disp(str);
    else
        % char(8) is the ascii character for "backspace"
        [char(8)*ones(1,lStr+lPrompt),str]
    end
    lStr = length(str);
end

% saves trial with specific formatting
disp('Saving...');
saveFile = fullfile(savePath, 'trial001_cond1.mat');
save(saveFile, 'x');
disp('Converting done.');

end