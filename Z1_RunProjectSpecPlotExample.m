% Example code that shows how to combine plots to answer project-specific
% questions. It is best to
% - choose plots to answer hypotheses.
% - make the code modular so that the same hypothesis can be evaluated for
% variable after variable.

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS','CONFIG');
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
disp([newline,mfilename]);

%% Loading
PcntSubCondGroup = load(fullfile(ProcessedFolder,'PcntSubCondGroup')); % Enter the path to the folder with the data here
load('CondPlotStyles');

%% Aim 1: Investigate if step lenght affects mean joint power measurements in N/kg or W/kg
Sub = load("PROCESSED/Sub.mat");
SubCondGroup = load("PROCESSED/SubCondGroup.mat");
StepLength = mean(SubCondGroup.RStep_Length,3,'omitnan');

FieldNames = fieldnames(SubCondGroup);
JointPowNames = FieldNames(~cellfun('isempty', regexpi(FieldNames, 'Power_Y')) & cellfun('isempty', regexpi(FieldNames, 'SI*')));

for n = 1:numel(JointPowNames)
    close
    JointPowWkg = mean(SubCondGroup.(JointPowNames{n}),3,'omitnan') ./ Sub.BodyMassKg;
    PlotYvsXscatter(JointPowWkg, StepLength, CondPlotStyles, [-Inf Inf -Inf Inf])
    [pValue, rSquared] = CorrPlot(StepLength, JointPowWkg)
    FigSaveName = fullfile('FIGS',[num2str(n, '%02d'),'_',JointPowNames{n}]);
    savefig(FigSaveName)
end
