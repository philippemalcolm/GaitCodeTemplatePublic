% This script makes the datasets more manageable by removing a configurable 
% list of variables that can be specified as a cellstring inside this script
% (e.g. frontal plane kinmatics, etc.)

% Example command line: E1_RunRemoveOrKeepSpecVars

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline, mfilename]);

%% SETTINGS 
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE

KeepVarWwildcards = {'Foot_Y', 'Time', 'Hip_Angle_X',... % ENTER LIST OF VARIABLES THAT WE WANT TO KEEP. MODIFY AS DESIRED
    'Hip_Moment_X', 'Hip_Power_X', ...
    'Ankle_Moment_X', 'Ankle_Power_X', 'Force_Y','Force_Z'}; 
% KeepVarWwildcards = {'Foot_Y', 'Time', 'COP_Y'};

RemoveVarWwildcards = {'Knee'}; % ENTER LIST OF VARIABLES THAT WE WANT TO REMOVE. MODIFY AS DESIRED

%% MAIN FUNCTION: RemoveOrKeepSpecVars
RemoveOrKeepSpecVars(ProcessedFolder, KeepVarWwildcards, 'keep'); % Main function that removes all the variables that do not match the KeepVarWwildcards.

RemoveOrKeepSpecVars(ProcessedFolder, RemoveVarWwildcards, 'remove');  % Main function that removes all the variables that match the KeepVarWwildcards.
