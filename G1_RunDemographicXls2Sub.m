% Adds matfile with demographics based on xls file

% Example command line: F1_RunDemographicXls2Sub

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% Settings
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
RawDataFolder = 'DATA'; % PATH TO DATA FOLDER
DemographicsFileName = 'Demographics'; % MODIFY AS NEEDED

%% Main function: table2struct
SaveFileName = 'Sub';
Sub = table2struct(readtable(fullfile(RawDataFolder,[DemographicsFileName,'.xlsx'])),'ToScalar',true); % MAIN FUNCTION THAT CONVERTS XLS INTO .MAT TABLE
% Note, this has not been turned into a function since there is already a
% matlab function that does this: table2struct.

%% Saving
if ~isfolder(ProcessedFolder); mkdir(ProcessedFolder); end
save(fullfile(ProcessedFolder,SaveFileName),'-struct','Sub');

%% Removing variables that are not immediately needed
RemoveOrKeepSpecVars(fullfile(ProcessedFolder,'Sub.mat'), {'AgeY', 'BandStiffNperM','BodyMassKg','FemaleMale','Group','HeightM','SubjNr'}, 'keep') % THESE ARE USUALLY THE MAIN VARIABLES NEEDED FOR A MANUSCRIPT
