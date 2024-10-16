% Runs different functions designed to remove errors or gaps:
% RemoveZeroColumns and RemoveOutliers.

% Example command line: E3to4_RunAllRemoveErrorFuns

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS:
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
PcntStrideSubCondGroupFileName = 'PcntStrideSubCondGroup'; % UPDATE: 2024-09-18: we now name files with group as last dimension for consistency.  
OutlierDim = 2; % The dimension in which outliers will be determined. Set this to 2 if you want outliers to be determined as strides that are too different form the other strides. 
IrqCoef = 1.5; % IRQ coefficient. Usually this is set to 1.5 or 3 (https://en.wikipedia.org/wiki/Interquartile_range#Outliers)
TolerancePrcnt = 5; % For timeseries we can set a tolerance for how much we allow a stride to briefly exit the boundaries 

%% Loading data
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName)); % Loads 4D data with invidivual strides (dimensions: stridetime, strides, subjects, conditions)

%% MAIN FUNCTIONS
%% 3) RemoveZeroColumns
% Removes columns that contain only zero. These are usually due to gaps or
% importing errors
[PcntStrideSubCondGroup, ~] = RemoveZeroColumns(PcntStrideSubCondGroup); 

%% 4) RemoveOutliers
% Removes strides that fall outside of q1 q3 +/- ... times interquartile
% range for more than ...% of the stride
[PcntStrideSubCondGroup, Outliers] = RemoveOutliers(PcntStrideSubCondGroup, OutlierDim, IrqCoef, TolerancePrcnt); % Removes outlying strides

%% Saving
save(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName),'-struct',PcntStrideSubCondGroupFileName); % Overwrites PopStrides with cleaned data
save(fullfile(ProcessedFolder,'Outliers'),'-struct','Outliers'); % Saves matfile that contains a list of where outliers were found. Matrices have the same dimension as data but have NaN in positions were outliers were found.
