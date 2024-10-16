% This trims seconds where the treadmill is speeding up. The number of
% seconds needs to be specified in this script. 

% Example command line: E2_RunRemoveFirstXseconds

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
SecondsToTrim = 10; % MODIFY THIS AS DESIRED. 

%% MAIN FUNCTION: RemoveFirstXseconds
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,'PcntStrideSubCondGroup.mat')); % UPDATE: 2024-09-18: we now name files with group as last dimension for consistency.  
[PcntStrideSubCondGroup, ~] = RemoveFirstXseconds(PcntStrideSubCondGroup, PcntStrideSubCondGroup.RTime, SecondsToTrim); % Main trimming function
save(fullfile(ProcessedFolder,'PcntStrideSubCondGroup'),'-struct','PcntStrideSubCondGroup'); % Overwrites PopStrides with cleaned data
