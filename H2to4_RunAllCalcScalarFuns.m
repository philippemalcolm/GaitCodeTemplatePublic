% Runs functions to calculate stridemetrics (e.g. max of each stride, etc.)
% and saves as 4D file: StrideSubCondGroup.mat. Since there is only one
% scalar (e.g. max, mean, etc.) of every stride the percent-stridetime
% dimension is now removed and the result is saved as 4D instead of 5D data. 

% Example command line: G2to3_RunAllCalcScalarFuns

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
PcntStrideSubCondGroupFileName = 'PcntStrideSubCondGroup';

%% MAIN: 
try
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName));
catch
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,strrep(PcntStrideSubCondGroupFileName,'Group','')));
end   
%% 2) CalcMeanMaxEtc
% Adds a number of standard metrics defined by strings: e.g. the 'max' of each stride, or the 'mean', etc ...
[StrideSubCondGroup] = CalcMeanMaxEtc(PcntStrideSubCondGroup, 'MEAN'); % Adds a number of types of metrics defined by strings: e.g. the 'MAX' of each stride, or the 'MEAN', the 'ROM" etc ...
% E.g. CalcMeanMaxEtc(PcntStrideSubCondGroup, 'MIN', 'STD', 'ROM'); % Calculates the minimum, standard deviation and the range between the max and min. 
save(fullfile(ProcessedFolder,'StrideSubCondGroup'),'-struct','StrideSubCondGroup'); 

%% 3) CalcSpatioTemp
TreadmillSpeed = 1.25;
% Adds spatiotemporal metrics
[StrideSubCondGroup.RStep_Time, StrideSubCondGroup.RStep_Length, StrideSubCondGroup.LStep_Time, StrideSubCondGroup.LStep_Length] = CalcSpatioTemp(PcntStrideSubCondGroup.RTime, PcntStrideSubCondGroup.RFoot_Y, PcntStrideSubCondGroup.LTime, PcntStrideSubCondGroup.LFoot_Y, TreadmillSpeed);
% COP-based step length
try
[~, StrideSubCondGroup.RStep_Length_COPbased, ~, StrideSubCondGroup.LStep_Length_COPbased] = CalcSpatioTemp(PcntStrideSubCondGroup.RTime, PcntStrideSubCondGroup.Right_COP_Y, PcntStrideSubCondGroup.LTime, PcntStrideSubCondGroup.Left_COP_Y, TreadmillSpeed);
catch
warning('Right_COP_Y and other COP variables might not be available?')
end
save(fullfile(ProcessedFolder,'StrideSubCondGroup'),'-struct','StrideSubCondGroup', '-append'); 

%% 4) CalcSymIndex
% Adds symemtry index
StrideSubCondGroup = CalcSymIndex(StrideSubCondGroup);
save(fullfile(ProcessedFolder,'StrideSubCondGroup'),'-struct','StrideSubCondGroup', '-append'); 

%% 5) Add other codes to calculate scalars here ...
% E.g. continuous relative phase, cross correlation, etc ... 

