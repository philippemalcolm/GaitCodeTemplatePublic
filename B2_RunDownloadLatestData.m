% This script finds the latest version of the data and downloads it
% Example command line: B1_DownLoadRawData
% 2023-09-10, pmalcolm@unomaha.edu

%% Initialization
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline, mfilename]);

%% Removing old data
if isfolder('DATA'); rmdir('DATA','s'); end
if isfolder('FIGS'); rmdir('FIGS','s'); end
if isfolder('PROCESSED'); rmdir('PROCESSED','s'); end

%% Copy latest data
DataLocation = uigetdir([],'Select research drive folder with latest data version. The content of this folder will be copied into the "RAW" folder.');
mkdir('DATA');
CopyLatestWoutArchiveOrBackup(DataLocation,'DATA') 
