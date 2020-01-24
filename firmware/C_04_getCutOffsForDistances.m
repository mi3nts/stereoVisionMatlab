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

%% Chapter_04: Generating Negative Images For Thermal Mapping 

% The current script relies on a manual process to figure out min and max
% distances for a given distance calibration
% Analisis done on utdset4


clc
clear all
close all 

addpath("../dataProducts/")

addpath("../threeWayImageDataSets/utdSet4/thermal/")

addpath("../threeWayImageDataSets/utdSet4/left/")
addpath("../threeWayImageDataSets/utdSet4/leftNegative/")

addpath("../threeWayImageDataSets/utdSet4/right/")
addpath("../threeWayImageDataSets/utdSet4/rightNegative/")

load('leftAndRightParametorsNov06th.mat')
load('thermalParametorsNov06th.mat')


timeCurrent = '040_11_05_17_58_00_';
timeCurrent = '050_11_05_17_58_28_';
timeCurrent = '060_11_05_17_58_56_';
timeCurrent = '070_11_05_17_59_24_';
timeCurrent = '080_11_05_17_59_52_';
timeCurrent = '090_11_05_18_00_28_';
timeCurrent = '100_11_05_18_00_56_';
timeCurrent = '110_11_05_18_01_17_';
timeCurrent = '120_11_05_18_01_52_';
timeCurrent = '130_11_05_18_02_27_';
timeCurrent = '140_11_05_18_02_48_';
timeCurrent = '150_11_05_18_03_23_';
timeCurrent = '160_11_05_18_03_44_';
timeCurrent = '170_11_05_18_04_41_';
timeCurrent = '180_11_05_18_05_02_';
timeCurrent = '190_11_05_18_05_44_';
timeCurrent = '200_11_05_18_06_12_';
timeCurrent = '210_11_05_18_07_08_';
timeCurrent = '220_11_05_18_07_36_';
timeCurrent = '230_11_05_18_08_12_';
timeCurrent = '240_11_05_18_08_33_';
timeCurrent = '250_11_05_18_09_29_';
timeCurrent = '260_11_05_18_10_04_';
timeCurrent = '270_11_05_18_10_32_';
timeCurrent = '280_11_05_18_11_21_';
timeCurrent = '290_11_05_18_11_57_';
timeCurrent = '300_11_05_18_12_32_';

frameThermal            = imread(strcat(timeCurrent,'thermal.jpg'));

frameLeft               = imread(strcat(timeCurrent,'left.jpg'));
frameLeftNegative      = imread(strcat(timeCurrent,'leftNegative.jpg'));


frameRight              = imread(strcat(timeCurrent,'right.jpg'));
frameRightNegative      = imread(strcat(timeCurrent,'rightNegative.jpg'));


% Gaining Rectified Images 


[frameLeftNegativeRect,frameRightNegativeRect] = ...
                                       rectifyStereoImages(...
                                                frameLeftNegative ,...
                                                frameRightNegative,...
                                                stereoParamsLeftAndRight);
                                            
frameThermalRect        = undistortImage(frameThermal,...
                                                    thermalParams);


[frameLeftRect, frameRightRectPre] = rectifyStereoImages(frameLeft,...
                                                        frameRight,...
                                                            stereoParamsLeftAndRight);

frameRightRect = imhistmatch(frameRightRectPre,...
                                frameLeftRect,...
                                    'method','uniform');

frameLeftGray  = rgb2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);
    

disparityMap = disparitySGM(frameLeftGray,frameRightGray);
points3D = reconstructScene(disparityMap, stereoParamsLeftAndRight);

Z = points3D(:, :, 3);
imshow(Z, [3100,3230]);
title('Disparity Map');
colormap jet
colorbar



