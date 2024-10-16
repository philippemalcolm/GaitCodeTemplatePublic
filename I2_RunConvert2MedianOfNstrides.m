% Calculates the median of all strides and saves as PcntSubCondGroup.mat
% and the median of all scalars and saves as SubCondGroup.mat (e.g. for
% plotting normalized stride of each condition).

% Most projects that do not involve analysing adaptation over time will
% only need these two files PcntSubCondGroup.mat and SubCondGroup.mat and
% they will be simple 3D and 2D data if there is only one group. 

% Example command line: H2_RunConvert2MedianOfNstrides

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
PcntStrideSubCondGroupFileName = 'PcntStrideSubCondGroup.mat'; % ENTER NAME OF FILE WITH TIMESERIES HERE
StrideSubCondGroupFileName = 'StrideSubCondGroup.mat'; % ENTER NAME OF FILE WITH SCALARS HERE

%% MAIN FUNCTION: Convert2MedianOfNstrides
PcntStrideSubCondGroup = load(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName));
nStrides = 10; FirstLastOrBoth = 'Last';
PcntSubCondGroup = Convert2MedianOfNstrideTs(PcntStrideSubCondGroup,nStrides,FirstLastOrBoth);

StrideSubCondGroup = load(fullfile(ProcessedFolder,'StrideSubCondGroup'));
nStrides = 10;
FirstLastOrBoth = 'Last';
SubCondGroup = Convert2MedianMeanSdOfNscalars(StrideSubCondGroup,nStrides,FirstLastOrBoth);

%% Saving
save(fullfile(ProcessedFolder,'PcntSubCondGroup'),'-struct','PcntSubCondGroup');
save(fullfile(ProcessedFolder,'SubCondGroup'),'-struct','SubCondGroup');

%% Deleting files that we no longer need
% After we calculated median stride and obtained the evolution versus time
% we usually no longer need the files with the individual strides so these
% are removed here for the sake of simplifying the data. 
if ~isfolder('archive'); mkdir('archive'); end
movefile(fullfile(ProcessedFolder,PcntStrideSubCondGroupFileName), fullfile('archive',PcntStrideSubCondGroupFileName));
movefile(fullfile(ProcessedFolder,StrideSubCondGroupFileName),fullfile('archive',StrideSubCondGroupFileName));
