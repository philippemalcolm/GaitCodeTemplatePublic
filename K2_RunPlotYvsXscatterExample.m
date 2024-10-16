% Example code that shows how to plot and save plots of scalars and add
% statistics to these plots. Code can be modified to plot specific
% subjects, conditions groups, as well as for plotting scalars with respect
% to each other. This example contains a first part that shows how all
% scalars can be plotted versus conditions (e.g. like a bar plot) and a
% second part that shows how one scalar can be plotted versus another one
% (e.g. to analyze correlation).

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
SubCondGroup = load(fullfile(ProcessedFolder,'SubCondGroup')); % Enter the path to the folder with the data here
MetricNames = fieldnames(SubCondGroup);
load('CondPlotStyles')
load('GroupPlotStyles')

%% MAIN PLOTTING EXAMPLE
Subjs = 1:size(SubCondGroup.(MetricNames{1}),1); % Allows to plot only subjects of a specific group ...
Conds = 1:size(SubCondGroup.(MetricNames{1}),2); % Allows to only plot certain conditions
Groups = 1:size(SubCondGroup.(MetricNames{1}),3);
for n = 1:numel(MetricNames)
    Y = mean(SubCondGroup.(MetricNames{n})(Subjs,Conds,Groups),3,'omitnan');
    f = PlotYvsXscatter(Y, [], CondPlotStyles); % THIS FUNCTION DOES THE PLOTTING
    ylabel(strrep(MetricNames{n},'_',' '),'FontSize',CondPlotStyles(1).FontSize);

    % Saving
    FigSaveName = fullfile('Figs',[num2str(n, '%02d'),'_',MetricNames{n}]);
    savefig(FigSaveName);
    close
end
