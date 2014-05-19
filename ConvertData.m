function [] = ConvertData
% separates a TIFF stack to multiple 3D arrays (.mat)
% each trial represents 1 sec of images

% asks user to select file and save directory
[filename, filePath] = uigetfile('*.tif','Select TIFF stack');
savePath = uigetdir(filePath,'Select Data folder');

% important to separate stack into multiple files so FastFlow can
% efficiently image (for now, 1 sec trials)
fps = input('What is the fps of the TIFF stack? ');

%gets information about image
info = imfinfo(filename);
arraySize = length(info);

% note: to create uniform trials, does not include the last frames that
% would not fit into a full trial
numTrials = floor(arraySize/fps) - 1;

% figures out zeroes for file name formatting
numDigits = floor(log10(numTrials)) + 1;
zeroFormat = ['%0' num2str(numDigits) 'u'];

% preallocates a 3D array
x = uint8(zeros(info(1).Width,info(1).Height,fps));

% outer loop creates each trial; inner loop goes through each frame
for k = 1:numTrials
    
    % keeps track of which frames to save
    start = (k-1)*fps;
    
    for j = 1:fps
        % note: image transposed into array because FastFlow seems to
        % transpose array onto GUI
        x(:,:,j) = transpose(imread(filename,'Index',start + j));
    end
    
    % saves trial with specific formatting
    dataName = ['trial' sprintf(zeroFormat, k) '_cond1.mat'];
    saveFile = fullfile(savePath, dataName);
    save(saveFile, 'x');
    
    % displays status on command window
    display = ['trial ' num2str(k) ' done']; 
    disp(display);
end
disp('Converting done.');
end
