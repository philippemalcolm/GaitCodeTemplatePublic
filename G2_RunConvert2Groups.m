% Converts data to 5D file: PcntStrideSubCondGoup.mat (if there is only 1
% group data remains 4D).

% Once the data is organized like this it is very easy to calculate metrics
% and generate plots. E.g. to calculate the peak of each stride of
% R_Ankle_Angle_X you simply have to run max(R_Ankle_Angle_X). To calculate
% the mean ankle angle of all strides and all subjects in the first group
% you simply have to run the mean function across the 2nd and 3rd dimension
% e.g. mean(R_Ankle_Angle_X, [2,3]). To obtain jus the first condition in
% the second group you simply have to specify the correct index, e.g.
% R_Ankle_Angle_X(:,:,1,2). To obtain simply 2D tables that can be plotted
% you just have use the squeeze function to remove the dimensions that
% contain only one sheet of data, e.g. squeeze R_Ankle_Angle_X(:,:,1,2).

% Example command line: F2_RunOrganizeByGroups
% 2023/../.. Philippe Malcolm

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);
if ~isfolder('Archive'); mkdir('Archive'); end

%% SETTINGS
ProcessedFolder = 'PROCESSED';
PcntStrideSubCondFileName = 'PcntStrideSubCondGroup.mat';
load(fullfile(ProcessedFolder,'Sub.mat'),'Group'); % MODIFY THIS AS NEEDED WITH CODE THAT GENERATES A COLUMN VECTOR THAT CONTAINS THE GROUP NUMBERS. 

%% Loading 
PcntStrideSubCond = load(fullfile(ProcessedFolder,PcntStrideSubCondFileName)); % Loads data

%% MAIN FUNCTION: Convert2Groups
PcntStrideSubCondGroup = Convert2Groups(PcntStrideSubCond, Group); % Main function that creates new data with extra dimension for different groups 
save(fullfile(ProcessedFolder,'PcntStrideSubCondGroup'),'-struct','PcntStrideSubCondGroup'); % saving