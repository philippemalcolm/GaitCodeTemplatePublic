% ...

% Example command line: ...

% 2023-... pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline, mfilename]);

%% SETTINGS 
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE

OrigAndNewVarNames = {'RopeTension_N_Ch1_tare','RFront_Tension';
    'RopeTension_N_Ch2_tare','RRear_Tension';
    't','CosmedTime';
    'EMG1','RTibialis';...
    'EMG2','RSoleus';...
    'EMG3','RGastroc';...
    'EMG4','RVastus';...
    'EMG5','RRectFem';...
    'EMG6','RBicFem';...
    'EMG7','RGlute'};
OrigVarNames =  {OrigAndNewVarNames{:,1}};
NewVarNames =  {OrigAndNewVarNames{:,2}};

%% MAIN FUNCTION: RemoveOrKeepSpecVars
RenameVars(ProcessedFolder,  OrigVarNames, NewVarNames);
