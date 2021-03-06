
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


%% main_0002- Final Function for C++ Conversion 


function [frameLeftRect,...
                finalCelciusImage,...
                        distanceImage...
                        ] = F_02_getImageData(stereoParamsStruct,...
                                                thermalParamsStruct,...
                                                    transformParametors)



persistent stereoParamsLeftAndRight 
persistent thermalParams 

stereoParamsLeftAndRight = stereoParameters(stereoParamsStruct);
thermalParams            = cameraParameters(thermalParamsStruct);


    lengths =      {...
                    '040', ...
                    '050', ...
                    '060', ...
                    '070', ...
                    '080', ...
                    '090', ...
                    '100', ...
                    '110', ...
                    '120', ...
                    '130', ...
                    '140', ...
                    '150', ...
                    '160', ...
                    '170', ...
                    '180', ...
                    '190', ...
                    '200', ...
                    '210', ...
                    '220', ...
                    '230', ...
                    '240', ...
                    '250', ...
                    '260', ...
                    '270', ...
                    '280', ...
                    '290', ...
                    };



    calibrations = {'040_11_05_17_56_27_', ...
                    '050_11_05_17_58_28_', ...
                    '060_11_05_17_58_56_', ...
                    '070_11_05_17_59_24_', ...
                    '080_11_05_17_59_52_', ...
                    '090_11_05_18_00_28_', ...
                    '100_11_05_18_00_56_', ...
                    '110_11_05_18_01_17_', ...
                    '120_11_05_18_01_52_', ...
                    '130_11_05_18_02_27_', ...
                    '140_11_05_18_02_48_', ...
                    '150_11_05_18_03_23_', ...
                    '160_11_05_18_03_44_', ...
                    '170_11_05_18_04_41_', ...
                    '180_11_05_18_05_02_', ...
                    '190_11_05_18_05_44_', ...
                    '200_11_05_18_06_12_', ...
                    '210_11_05_18_07_08_', ...
                    '220_11_05_18_07_36_', ...
                    '230_11_05_18_08_05_', ...
                    '240_11_05_18_08_33_', ...
                    '250_11_05_18_09_29_', ...
                    '260_11_05_18_10_04_', ...
                    '270_11_05_18_10_32_', ...
                    '280_11_05_18_11_21_', ...
                    '290_11_05_18_11_57_', ...
                    };

    boundries=[ 390, 490 , 590 , 690 , 790, 880,...
        985 , 1080, 1180 ,1280, 1380 , 1475, 1580, ...
        1695 ,1795, 1895 ,2000, 2090 , 2190, 2340, ...
        2385 ,2540, 2600 ,2760, 2810 , 3020 ...
        ];

    cutoffs = [440,540,640,740,835,932.5,...
               1032.5,1130,1230,1330,1427.5,...
               1527.5,1637.5,1745,1845,1947.5,...
               2045,2140,2265,2362.5,2462.5,...
               2570,2680,2785,2915]

    %% Getting the distance map 

    thermalCelciusLoaded  =  coder.load('2019_11_07_15_29_37_celcius.mat');


    frameCelcius = thermalCelciusLoaded.thermalCelcius;
    frameLeft               = imread('2019_11_07_15_29_37_left.jpg');
    frameRight              = imread('2019_11_07_15_29_37_right.jpg');


    frameCelciusRect        = undistortImage(frameCelcius,...
                                                        thermalParams);
    [frameLeftRect, frameRightRect] = rectifyStereoImages(frameLeft,...
                                                            frameRight,...
                                                                stereoParamsLeftAndRight);


    frameLeftGray  = rgb2gray(frameLeftRect);
    frameRightGray = rgb2gray(frameRightRect);


    disparityMap = disparitySGM(frameLeftGray,frameRightGray);
    points3D = reconstructScene(disparityMap, stereoParamsLeftAndRight);

    distanceImage = points3D(:, :, 3);


    outputView = imref2d(size(frameLeftRect));

    maskCelclius = cell(26);
    celciusImage  = cell(26);
    maskedCelciusImage = cell(26);


    maskCelclius{1}            = double(distanceImage < cutoffs(1));

    celciusImage{1}            = imwarp(frameCelciusRect,...
                                            transformParametors{1},...
                                                'OutputView',outputView);                                        

    maskedCelciusImage{1}      = maskCelclius{1}.*celciusImage{1};

    finalCelciusImage = maskedCelciusImage{1};

    for n = 2 : length(calibrations) -1 

        maskCelclius{n}            = double(distanceImage > cutoffs(n-1) & distanceImage < cutoffs(n));
        celciusImage{n}            = imwarp(frameCelciusRect,...
                                                transformParametors{n},...
                                                    'OutputView',outputView);                                         
        maskedCelciusImage{n}      = maskCelclius{n}.*celciusImage{n};
        finalCelciusImage  = finalCelciusImage +  maskedCelciusImage{n};

    end 

    maskCelclius{length(calibrations)}       = double(distanceImage > cutoffs(end));
    celciusImage{length(calibrations)}       = imwarp(frameCelciusRect,...
                                                        transformParametors{length(calibrations)},...
                                                        'OutputView',outputView);

    maskedCelciusImage{length(calibrations)} = ...
            maskCelclius{length(calibrations)}.*celciusImage{length(calibrations)};

    finalCelciusImage = finalCelciusImage +  maskedCelciusImage{length(calibrations)};

end

