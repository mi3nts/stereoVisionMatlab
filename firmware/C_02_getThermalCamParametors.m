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

%% Chapter_01 : Generating Thermal Camera Calibration Parametors

% For the thermal camera calibration utdset4 is used

% Define images to process
imageFileNames = {'/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/040_11_05_17_56_13_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/040_11_05_17_56_20_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/040_11_05_17_56_27_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/040_11_05_17_57_53_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/040_11_05_17_58_00_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/050_11_05_17_58_21_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/050_11_05_17_58_28_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/060_11_05_17_58_49_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/060_11_05_17_58_56_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/070_11_05_17_59_10_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/070_11_05_17_59_17_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/070_11_05_17_59_24_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/080_11_05_17_59_45_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/080_11_05_17_59_52_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/080_11_05_17_59_59_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/080_11_05_18_00_21_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/080_11_05_18_00_28_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/100_11_05_18_00_49_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/100_11_05_18_00_56_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/110_11_05_18_01_17_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/120_11_05_18_01_45_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/120_11_05_18_01_52_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/130_11_05_18_02_20_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/140_11_05_18_02_27_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/140_11_05_18_02_48_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/150_11_05_18_03_09_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/150_11_05_18_03_16_thermal.jpg',...
    '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/stereoVisionCalibration/firmware/MATLAB/threeWayImageDataSets/utdSet4/thermalCalib/150_11_05_18_03_23_thermal.jpg',...
    };
% Detect checkerboards in images
[imagePoints, boardSize, imagesUsed] = detectCheckerboardPoints(imageFileNames);
imageFileNames = imageFileNames(imagesUsed);

% Read the first image to obtain image size
originalImage = imread(imageFileNames{1});
[mrows, ncols, ~] = size(originalImage);

% Generate world coordinates of the corners of the squares
squareSize = 35;  % in units of 'millimeters'
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% Calibrate the camera
[thermalParams, imagesUsed, estimationErrors] = estimateCameraParameters(imagePoints, worldPoints, ...
    'EstimateSkew', false, 'EstimateTangentialDistortion', false, ...
    'NumRadialDistortionCoefficients', 2, 'WorldUnits', 'millimeters', ...
    'InitialIntrinsicMatrix', [], 'InitialRadialDistortion', [], ...
    'ImageSize', [mrows, ncols]);

% View reprojection errors
h1=figure; showReprojectionErrors(thermalParams);

% Visualize pattern locations
h2=figure; showExtrinsics(thermalParams, 'CameraCentric');

% Display parameter estimation errors
displayErrors(estimationErrors, thermalParams);

% For example, you can use the calibration data to remove effects of lens distortion.
undistortedImage = undistortImage(originalImage, thermalParams);

% See additional examples of how to use the calibration data.  At the prompt type:
% showdemo('MeasuringPlanarObjectsExample')
% showdemo('StructureFromMotionExample')
save('../dataProducts/thermalCalibrationNov06th')
save('../dataProducts/thermalParametorsNov06th','thermalParams')
close all
