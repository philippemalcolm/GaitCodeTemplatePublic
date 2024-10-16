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
SI_TsNames = fieldnames(PcntSubCondGroup);
load('CondPlotStyles');
CondPlotStyles(3) = []; CondPlotStyles(end) = []; CondPlotStyles(2).DisplayName = 'Adapt'; CondPlotStyles(end).DisplayName = 'Post'; % Modifying names because there are only 3 condition elements
load('GroupPlotStyles')

%% Aim 1: Investigate if conditions cause adaptation followed by post-effect on step length SI, step time SI, (and other SI variables)
TimeSubCondGroup_MERGED = load("processed/TimeSubCondGroup_MERGED.mat");
TsNames = fieldnames(TimeSubCondGroup_MERGED);
SI_TsNames = TsNames(~cellfun('isempty', regexpi(TsNames, '_SI*')));

for n = 1:numel(SI_TsNames)
    try
    close all
    Y = TimeSubCondGroup_MERGED.(SI_TsNames{n});
    Yfit = TimeSubCondGroup_MERGED.([SI_TsNames{n},'_FIT']);
    X = TimeSubCondGroup_MERGED.CUMUL_RTime_MEAN;
    for Group = 1%:3
        subplot(3,1,Group) % Group 1
        SI = mean(Y(:,:,:,Group),4,'omitnan');
        Time = mean(X(:,:,:,Group),4,'omitnan');
        CondPlotStyles(1:3) = arrayfun(@(x) setfield(x, 'LineWidth', .1), CondPlotStyles(1:3));
        PlotYvsXts(SI, Time, CondPlotStyles, [0 Inf, -20 20]); hold on

        SIfit = mean(Yfit(:,:,:,Group),4,'omitnan');
        Time = mean(X(:,:,:,Group),4,'omitnan');
        CondPlotStyles(1:3) = arrayfun(@(x) setfield(x, 'LineWidth', 3), CondPlotStyles(1:3));
        PlotYvsXts(SIfit, Time, CondPlotStyles, [0 Inf, -20 20]); hold on;

        title(['Group ',num2str(Group)])
    end
    FigSaveName = fullfile('FIGS',[num2str(n, '%02d'),'_',SI_TsNames{n}]);
    savefig(FigSaveName)
    catch
        warning('Variable already plotted')
    end
end