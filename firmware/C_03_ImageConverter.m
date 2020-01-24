
% # ***************************************************************************
% #   Stereo Vision - Thermal 
% #   ---------------------------------
% #   Written by: Lakitha Omal Harindha Wijeratne
% #   - for -
% #   Mints: Multi-scale Integrated Sensing and Simulation
% #   ---------------------------------
% #   Date: January 23rd, 2020
% #   ---------------------------------
% #   This module is written for generic implimentation of MINTS projects
% #   --------------------------------------------------------------------------
% #   https://github.com/mi3nts
% #   http://utdmints.info/
% #  ***************************************************************************


%% Chapter_03: Generating Negative Images For Thermal Mapping 

clc
clear all 
close all 
% 
% /stereoImageDataSets/thermalAndWebCam/webCam
imageData = dir( "../threeWayImageDataSets/utdSet4/right/*.jpg")
imageDataTable  = unique(struct2table(imageData),'rows')
% 
for n = 1:length(imageData)
    
    fileName = strcat(imageDataTable.folder{n}+"/",imageDataTable.name{n})
    A = imread(fileName);
    C = imcomplement(A);  
    image(C)
    FN = strrep(fileName,"right","rightNegative")
%     mkdir(FN)
    imwrite(C,FN)
    
end 

% /stereoImageDataSets/thermalAndWebCam/webCam
imageData = dir( "../threeWayImageDataSets/utdSet4/left/*.jpg")
imageDataTable  = unique(struct2table(imageData),'rows')

for n = 1:length(imageData)
       
    fileName = strcat(imageDataTable.folder{n}+"/",imageDataTable.name{n})
    A = imread(fileName);
    C = imcomplement(A);  
    image(C)
    FN = strrep(fileName,"left","leftNegative")
%     FN = strrep(fileName,"/left","/leftNegative")
    imwrite(C,FN)
    
end 

