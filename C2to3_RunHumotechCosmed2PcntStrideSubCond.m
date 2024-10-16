% This script loads all humotech data files and stridenormalizes
% the columns using the Humotech2PcntStrideSubCond function based
% information from the time variable from the stridenormalized motion
% capture file.

% Example command line: C2_RunHumotech2PcntStrideSubCond

% 2023-08-01, pmalcolm@unomaha.edu

%% Initialization
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline, mfilename]);

%% SETTINGS
% MODIFY THESE TO MATCH HOW YOU NAMED YOUR FOLDERS AND FILES.
DataFolder = 'DATA';
ProcessedFolder = 'PROCESSED';
SubjectFolderFormat = '/S*';
ProtocolFileName = 'Protocol.xlsx'; % THIS PROTOCOL FILE SHOULD CONTAIN A VECTOR WITH THE SEQUENCE OF THE CONDITION NUMBERS AND NOTHING ELSE
HumotechExportName = 'Humotech.mat';
CosmedExportName = 'Cosmed.xlsx';
PcntStrideCondFileName = 'PcntStrideCond.mat';

%% Find subject data folders
SubNames = dir([DataFolder, SubjectFolderFormat]);

%% MAIN FUNCTION: Humotech2PcntStrideSubCond
for Sub = 1:numel(SubNames) % Loops over each subject

    % Load folder and files
    subjectFolderPath = fullfile(SubNames(Sub).folder, SubNames(Sub).name);
    HumotechFileName = fullfile(subjectFolderPath, HumotechExportName);
    CosmedFileName = fullfile(subjectFolderPath, CosmedExportName);
    CondSequence = readmatrix(fullfile(subjectFolderPath, ProtocolFileName)); % This needs to load a simple vector that specifies the sequence in which the conditions are presented. This is necessary for organizing the file.
    load(fullfile(ProcessedFolder,SubNames(Sub).name,'PcntStrideCond'),'RTime'); % Stridenormalized timevariable from the previously normalized motion capture data. This will be used for stridenormalizing the data.
    NormalizedTime = RTime;

    % MAIN IMPORTING FUNCTIONS
    try            PcntStrideCond =  Humotech2PcntStrideSubCond(HumotechFileName, CondSequence, NormalizedTime); % Humotech importing function
        save(fullfile(ProcessedFolder,SubNames(Sub).name,'PcntStrideCond'),'-struct','PcntStrideCond','-append'); % Saves as PcntStrideCond.mat
    catch
        warning(['Unable to load humotechfile for ', SubNames(Sub).name])
    end

    try            PcntStrideCond =  Cosmed2PcntStrideSubCond(CosmedFileName, CondSequence, NormalizedTime); % Cosmed importing function
        save(fullfile(ProcessedFolder,SubNames(Sub).name,'PcntStrideCond'),'-struct','PcntStrideCond','-append'); % Saves as PcntStrideCond.mat
    catch
        warning(['Unable to load cosmedfile for ', SubNames(Sub).name])
    end

    % ADD OTHER IMPORTING FUNCTIONS HERE.
end

