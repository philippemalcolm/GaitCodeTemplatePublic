% Runs functions to calculate additional timeseries (e.g. cumulative time, etc.)
% PLACE ADDITIONAL FUNCTIONS THAT CALCULATE ADDITIONAL DERIVED TIMESERIES
% HERE (E.G. CALCULATING CERTAIN COM TIMESERIES LIKE EXTRAPOLATED COM)

% Example command line: G1_RunAllCalcTsFuns

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
PcntStrideSubCondGroupFileName = 'PcntStrideSubCondGroup';

%% MAIN FUNCTION:
%% G1) CalcCumulativeTime
% Calculates a new time variable that contains cumulative time over the protocol (e.g. condition 2 does not start from 0s but from 2min, etc.)
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName),'RTime');
CUMUL_RTime = CalcCumulativeTime(PcntStrideSubCondGroup.RTime);
save(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName),'CUMUL_RTime','-append'); % Saves metrics as 3d matrices with dimensions: 1: strides, 2: subjects, 3: conditions

%% 2) Add other derived timeseries calculations here ...
try Metabolic_Rate = 16.58 * PcntStrideSubCondGroup.VO2/60 + 4.51 * PcntStrideSubCondGroup.VCO2/60; % Brockway 1987. VO2 and CO2 are divided by 60 because cosmed export is per minute (60 s).
save(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName),'Metabolic_Rate','-append'); % Saves metrics as 3d matrices with dimensions: 1: strides, 2: subjects, 3: conditions
catch warning('Cosmed variables not available.')
end
