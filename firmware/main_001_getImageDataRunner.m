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


%% main_0001 - Final Matlab Implementation 
clc 
clear all
close all

addpath("../dataProducts/")

load('thermalParametorsNov06th.mat')
load('leftAndRightParametorsNov06th.mat')


 [frameLeftRect,...
                finalCelciusImage,...
                        distanceImage...
                        ] =  ...
                                F_01_getImageData(...
                                  '2019_11_07_15_29_37',...
                                        stereoParamsLeftAndRight,...
                                            thermalParams,...
                                                transformParametors);
                                        
                                        
                                        