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

%% Chapter_05: Three Way Calibration 

clc
clear all 
close all

addpath("../dataProducts/")

addpath("../threeWayImageDataSets/utdSet5/thermal/")
addpath("../threeWayImageDataSets/utdSet5/celcius/")
addpath("../threeWayImageDataSets/utdSet5/kelvin/")

addpath("../threeWayImageDataSets/utdSet5/left/")
addpath("../threeWayImageDataSets/utdSet5/leftNegative/")

addpath("../threeWayImageDataSets/utdSet5/right/")
addpath("../threeWayImageDataSets/utdSet5/rightNegative/")

load('../dataFiles/transformParametorsNov6')


%% Getting the distance map 


% Loading the test image 
timeCurrent = '2019_11_07_15_29_37_';


frameThermal            = imread(strcat(timeCurrent,'thermal.jpg'));
load(strcat(timeCurrent,'celcius.mat'));
load(strcat(timeCurrent,'kelvin.mat'));
frameCelcius = thermalCelcius;
frameKelvin  = thermalKelvin;

frameLeft               = imread(strcat(timeCurrent,'left.jpg'));
frameRight              = imread(strcat(timeCurrent,'right.jpg'));

% Undistorting Images 
frameThermalRect        = undistortImage(frameThermal,...
                                                    thermalParams);
frameCelciusRect        = undistortImage(frameCelcius,...
                                                    thermalParams);
frameKelvinRect         = undistortImage(frameKelvin,...
                                                    thermalParams);                                                

% Rectifying Thermal Images                                                  
[frameLeftRect, frameRightRect] = rectifyStereoImages(frameLeft,...
                                                        frameRight,...
                                                            stereoParamsLeftAndRight);

frameLeftGray  = rgb2gray(frameLeftRect);
frameRightGray = rgb2gray(frameRightRect);
    

disparityMap = disparitySGM(frameLeftGray,frameRightGray);
points3D = reconstructScene(disparityMap, stereoParamsLeftAndRight);

% Gaining only the depth 
distanceImage = points3D(:, :, 3);


outputView = imref2d(size(frameLeftRect));

% Figuring out depths for each pixel and appliying a given calibration 

mask{1}                    = uint8(distanceImage < cutoffs(1));
maskCelclius{1}            = double(distanceImage < cutoffs(1));
maskKelvin{1}              = uint16(distanceImage < cutoffs(1));

thermalImage{1}            = imwarp(frameThermalRect,...
                                        transformParametors{1},...
                                            'OutputView',outputView);
                                        
celciusImage{1}            = imwarp(frameCelciusRect,...
                                        transformParametors{1},...
                                            'OutputView',outputView);                                        
                                        
kelvinImage{1}            = imwarp(frameKelvinRect,...
                                        transformParametors{1},...
                                            'OutputView',outputView);                                        
                                                                                
                                        
maskedThermalImage{1}      = mask{1}.*thermalImage{1};
maskedCelciusImage{1}      = maskCelclius{1}.*celciusImage{1};
maskedKelvinImage{1}       = maskKelvin{1}.*kelvinImage{1};

finalThermalImage = maskedThermalImage{1};
finalCelciusImage = maskedCelciusImage{1};
finalKelvinImage  = maskedKelvinImage{1};
 
for n = 2 : length(calibrations) -1 
   
   mask{n}                    = uint8(distanceImage > cutoffs(n-1) & distanceImage < cutoffs(n));
   maskCelclius{n}            = double(distanceImage > cutoffs(n-1) & distanceImage < cutoffs(n));
   maskKelvin{n}              = uint16(distanceImage > cutoffs(n-1) & distanceImage < cutoffs(n));
  
   
   thermalImage{n}            = imwarp(frameThermalRect,...
                                        transformParametors{n},...
                                            'OutputView',outputView); 

   celciusImage{n}            = imwarp(frameCelciusRect,...
                                        transformParametors{n},...
                                            'OutputView',outputView);                                         
   
   kelvinImage{n}            = imwarp(frameKelvinRect,...
                                        transformParametors{n},...
                                            'OutputView',outputView);                                         
                                                                             
   maskedThermalImage{n}      = mask{n}.*thermalImage{n};
   maskedCelciusImage{n}      = maskCelclius{n}.*celciusImage{n};
   maskedKelvinImage{n}       = maskKelvin{n}.*kelvinImage{n};
   
   finalThermalImage  = finalThermalImage +  maskedThermalImage{n};
   finalCelciusImage  = finalCelciusImage +  maskedCelciusImage{n};
   finalKelvinImage   = finalKelvinImage  +  maskedKelvinImage{n};
   
end 

mask{length(calibrations)}               = uint8(distanceImage > cutoffs(end));
maskCelclius{length(calibrations)}       = double(distanceImage > cutoffs(end));
maskKelvin{length(calibrations)}         = uint16(distanceImage > cutoffs(end));

thermalImage{length(calibrations)}       = imwarp(frameThermalRect,...
                                                    transformParametors{length(calibrations)},...
                                                    'OutputView',outputView);
                                                
celciusImage{length(calibrations)}       = imwarp(frameCelciusRect,...
                                                    transformParametors{length(calibrations)},...
                                                    'OutputView',outputView);
                                                
kelvinImage{length(calibrations)}       = imwarp(frameKelvinRect,...
                                                    transformParametors{length(calibrations)},...
                                                    'OutputView',outputView);
                                                
maskedThermalImage{length(calibrations)} = mask{length(calibrations)}.*thermalImage{length(calibrations)};                                               
maskedCelciusImage{length(calibrations)} = maskCelclius{length(calibrations)}.*celciusImage{length(calibrations)};
maskedKelvinImage{length(calibrations)}  = maskKelvin{length(calibrations)}.*kelvinImage{length(calibrations)};

finalThermalImage = finalThermalImage +  maskedThermalImage{length(calibrations)};
finalCelciusImage = finalCelciusImage +  maskedCelciusImage{length(calibrations)};
finalKelvinImage  = finalKelvinImage +  maskedKelvinImage{length(calibrations)};


% Displaying Results 

close all 

figure(1);
imshow(finalCelciusImage, [20,40]);
title('Temperature Map');
colormap jet
colorbar
hold off 

figure(2)
imshow(distanceImage, [0,3000]);
title('Disparity Map');
colormap jet
colorbar
hold off 

figure(3);
C = imfuse(frameLeftRect,finalThermalImage);
imshow(C)
title('Fused image');
hold off 

% writing the resulting images 

save(...
            strcat('../dataProducts/',timeCurrent,'Result'),...
            'frameLeftRect',...
             'finalCelciusImage',...
               'distanceImage'...
                      )


