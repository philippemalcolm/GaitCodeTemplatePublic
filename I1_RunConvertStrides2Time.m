% Converts scalars sorted versus strides to scalars sorted versus time and
% saves as TimeSubCondGroup.mat. This is useful e.g. for comparing
% evolution vs. time of protocol). This is not needed for most projects
% that do not involve studying adaptation over time.

% Example command line: H1_RunConvertStrides2Time

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
StrideSubCondGroupFileName = 'StrideSubCondGroup.mat';

%% Loading inputs
StrideSubCondGroup = load(fullfile(ProcessedFolder, StrideSubCondGroupFileName));

%% MAIN FUNCTION: ConvertStrides2Time
TimeBasis = StrideSubCondGroup.CUMUL_RTime_MEAN; % STRIDESCALAR THAT WILL BE USED FOR REORGANIZING DATA VERSUS TIME

[TimeSubCondGroup] = ConvertStrides2Time(StrideSubCondGroup, TimeBasis); % MAIN FUNCTION THAT DOES THE REORGANIZING

save(fullfile(ProcessedFolder,'TimeSubCondGroup'),'-struct','TimeSubCondGroup'); 

% %% Delete unused file 
% if ~isfolder('archive'); mkdir('archive'); end
% movefile(fullfile(ProcessedFolder,StrideSubCondGroupFileName), fullfile('archive',StrideSubCondGroupFileName)); 
