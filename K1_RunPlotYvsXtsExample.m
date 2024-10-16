% Example code that shows how to plot and save timeseries. Code can be
% modified to plot specific subjects, conditions groups, as well as for
% plotting timeseries with respect to each other. This example contains a
% first part that shows how all timeseries can be plotted and a second part
% that shows how one timeseries can be plotted versus another one.

% The present script is merely intended as an example. This needed to be
% customized to generate the specific plots that answer the
% project-specific aims.

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS','CONFIG');
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
disp([newline,mfilename]);
mkdir('FIGS')

%% Loading
PcntSubCondGroup = load(fullfile(ProcessedFolder,'PcntSubCondGroup')); % Enter the path to the folder with the data here
TsNames = fieldnames(PcntSubCondGroup);
load('CondPlotStyles')
load('GroupPlotStyles')

%% 1) EXAMPLE OF PLOTTING NORMALIZED STRIDE TIMESERIES USING PlotYvsXts
% Example of how you can plot specific subjects, conditions
Subjs = 1:size(PcntSubCondGroup.(TsNames{1}),2);
Conds = 1:size(PcntSubCondGroup.(TsNames{1}),3);
Groups = 1:size(PcntSubCondGroup.(TsNames{1}),4);
% If the data is TimeSubsConds and you want to compare Subjects and average conditions then Dim should be set to 3
for n = 1:numel(TsNames)

    Y = mean(PcntSubCondGroup.(TsNames{n})(:,Subjs,Conds,Groups),4,'omitnan');
    f = PlotYvsXts(Y, [], CondPlotStyles); % MAIN FUNCTION DOES THE PLOTTING

    ylabel(strrep(TsNames{n},'_',' '), 'FontSize', CondPlotStyles(1).FontSize);
    FigSaveName = fullfile('FIGS',[num2str(n, '%02d'),'_',TsNames{n}]);
    savefig(FigSaveName);
    close
end

%% 2) EXAMPLE OF PLOTTING VS TIME USING PlotYvsXts
try close all; clear; clc;
    load('PROCESSED/TimeSubCondGroup.mat')
    load('CondPlotStyles')

    Y = mean(Step_Length_SI,4,'omitnan');
    X = mean(INTERPOLATED_Time,4,'omitnan')/60-22.5;
    f = PlotYvsXts(Y, X, CondPlotStyles);

    % Saving
    FigSaveName = fullfile('FIGS','Step_Length_SI');
    savefig(FigSaveName);
    close

catch 
    warning('Plotting from PROCESSED/TimeSubCondGroup.mat was not available.')
end