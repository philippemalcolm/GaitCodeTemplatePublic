% This script finds all the folders with subject data and applies the
% Mocap2PcntStrideCond-function to convert data to 3D matrices with
% Time, Strides, and Conditions as dimensions 1, 2 and 3.
% Once the data is organized like this it is very easy to calculate metrics
% and generate plots. % E.g. to calculate the peak of each stride of
% R_Ankle_Angle_X you simply have to run max(R_Ankle_Angle_X). To calculate
% the mean ankle angle of all strides you simply have to run the mean
% function across the 2nd dimension which contains the strides by running
% mean(R_Ankle_Angle_X,2).

% Example command line: B1_RunMocap2PcntStrideCond

% 2023-08-01, pmalcolm@unomaha.edu

%% Initialization
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline, mfilename]);
diary(['archive/',char(datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss'))]) % Keep a log of all the actions 

%% SETTINGS
% MODIFY THESE TO MATCH HOW YOU NAMED YOUR FOLDERS AND FILES. 
DataFolder = 'DATA'; 
ProcessedFolder = 'PROCESSED'; 
SubjectFolderFormat = '/S*'; 
vis3dExportName = 'Vis3d.mat'; 
ProtocolFileName = 'Protocol.xlsx'; % THIS PROTOCOL FILE SHOULD CONTAIN A VECTOR WITH THE SEQUENCE OF THE CONDITION NUMBERS AND NOTHING ELSE

%% Identify subject data folders
SubNames = dir([DataFolder, SubjectFolderFormat]);

%% MAIN FUNCTION: Mocap2PcntStrideCond
for Sub = 1:numel(SubNames) % Loops over each subject

    subjectFolderPath = fullfile(SubNames(Sub).folder, SubNames(Sub).name);
    Vis3dFileName = fullfile(subjectFolderPath, vis3dExportName); 
    CondSequence = readmatrix(fullfile(subjectFolderPath, ProtocolFileName));

    % MAIN IMPORTING FUNCTION
    PcntStrideCond =  Mocap2PcntStrideCond(Vis3dFileName, CondSequence); 

    % Saving
    mkdir(fullfile(ProcessedFolder,SubNames(Sub).name));
    save(fullfile(ProcessedFolder,SubNames(Sub).name,'PcntStrideCond'),'-struct','PcntStrideCond'); % Saves as PcntStrideCond.mat
end

