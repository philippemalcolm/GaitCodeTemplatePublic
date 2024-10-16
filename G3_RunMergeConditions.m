% Merges certain conditions. 

% Example command line: I3_RunMergeConditions

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
PcntStrideSubCondGroupFileName = 'PcntStrideSubCondGroup.mat'; % ENTER NAME OF FILE WITH TIMESERIES HERE

OrigConds = [1 NaN; 2:3; 4:5]; % SPECIFY WHICH ORIGINAL CONDITIONS WILL BE COMBINED INTO WHICH NEW CONDITIONS USING THESE TWO VECTORS
NewConds =  [1;     2;   3];

%% MAIN FUNCTION: Convert2MedianOfNstrides
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName));
PcntStrideSubCondGroup = MergeConditions(PcntStrideSubCondGroup, OrigConds, NewConds); % MAIN FUNCTION

%% Saving
save(fullfile(ProcessedFolder,'PcntStrideSubCondGroup'),'-struct','PcntStrideSubCondGroup');
