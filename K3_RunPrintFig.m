% Converts figure files to formats that we often use for presenting and
% publishing: jpeg and vector

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS','CONFIG');
FigFolder = 'Figs';
disp([newline,mfilename]);

%% Loading
load("PrintProperties.mat"); % loads structure with configurable settings like resolution, size, formats, etc ...
FigNames = dir(fullfile(FigFolder,'*.fig'));

%% Printing figures as jpeg and vector format
for n = 1:numel(FigNames)
    f = open(fullfile(FigFolder,FigNames(n).name));
    PrintFig(f,fullfile(FigFolder,FigNames(n).name),PrintProperties)
    close
end