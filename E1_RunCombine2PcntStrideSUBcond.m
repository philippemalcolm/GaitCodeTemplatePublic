% Combines data from individual subjects into 4D file with dimensions
% listed in the filename: PcntStrideSubCond.mat

% Once the data is organized like this it is very easy to calculate metrics
% and generate plots. E.g. to calculate the peak of each stride of
% R_Ankle_Angle_X you simply have to run max(R_Ankle_Angle_X). To calculate
% the mean ankle angle of all strides and all subjects you simply have to run the mean
% function across the 2nd and 3rd dimension which contain the strides and
% subjects: mean(R_Ankle_Angle_X, [2,3]). To convert this in a 2D table
% with the conditions in columns you then have to remove the dimensions
% that have no more data (strides and subjects) using the squeeze function.
% squeeze(mean(R_Ankle_Angle_X, [2,3])). In a similar way you can also
% easily compare and plot subjects within the same condition, etc. 

% Example command line: D1_RunCombine2PcntStrideSUBcond;

% 2023-08-02, hrazavi@unomaha.edu, pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);
diary(['archive/',char(datetime('now', 'Format', 'yyyy-MM-dd_HH-mm-ss'))]) % Keep a log of all the actions 

%% Settings
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
SubjFolderAndFilePattern = '/s*/*.mat'; % ENTER THE PATTERN OF WHERE THE INDIVIDUAL 
% SUBJECT FILES (PcntStrideCond.mat) WILL BE LOCATED. THIS NEEDS TO BE
% MODIFIED TO MATCH THE FORMAT OF THE FOLDERS AND FILES THAT IS USED.

%% Removing previously processed data
arrayfun(@(x) delete(fullfile(ProcessedFolder, x.name)), dir(fullfile(ProcessedFolder, '*.mat')));% Removes all the previous .mat files to start with a clean slate
if isfolder('FIGS'); 
    arrayfun(@(x) delete(fullfile('FIGS', x.name)), dir(fullfile('FIGS', '*.*')));% Removes all the previous .mat files to start with a clean slate
end

%% MAIN FUNCTION: Combine2PcntStrideSUBcond
Temp = dir([ProcessedFolder,SubjFolderAndFilePattern]); % Obtains list of subject data files
PcntStrideCondFilePaths = cellfun(@(folder, name) fullfile(folder, name), {Temp.folder}, {Temp.name}, 'UniformOutput', false)'; % Makes a single list

PcntStrideSubCond = Combine2PcntStrideSUBcond(PcntStrideCondFilePaths); % THIS FUNCTION PERFORMS THE COMBINING OF SUBJECTS

%% Saving
save(fullfile(ProcessedFolder,'PcntStrideSubCondGroup'),'-struct','PcntStrideSubCond'); % SAVES DATA IN TimeStridesSubsCondGroup.mat WITH PERCENT STRIDETIME IN 1ST, STRIDES IN 2ND, SUBJECTS IN 3RD DIMENSION, CONDITIONS 4TH DIMENSION
% UPDATE 2024-09-18: WE NOW NAME THE FILE WITH "GROUP" AS THE 5TH DIMENSION. THIS FACILITATES CONSISTENCY IN THE CODE BETWEEN PROJECTS THAT HAVE GROUPS AND PROJECTS THAT DO NOT HAVE GROUPS (in those projects the 5th dimension is simply empty)