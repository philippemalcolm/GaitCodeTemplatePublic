% Calculates exponential fit of each condition in the protocol versus protocol time.
% This can be used for evaluating learning (e.g. adaptation and posteffect
% to split belt walking) or even for estimating steady state metabolic cost
% using as little as 2 minutes of metabolic data (as in Selinger et al., 2014).

% Example command line: I1_RunFitExpProtocol

% 2023-08-02: pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% SETTINGS
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE
TimeSubCondGroupFileName = 'TimeSubCondGroup'; % IN EXAMPLE PROJECT THIS IS THE TIMESUBCONDGROUP FILE WITH CONDITIONS MERGED, THIS IS CALLED TimeSubCondGroup2.mat
SubCondGroupFileName = 'SubCondGroup'; % IN EXAMPLE PROJECT THIS IS THE TIMESUBCONDGROUP FILE WITH CONDITIONS MERGED, THIS IS CALLED TimeSubCondGroup2.mat
TimeVariableForExpFitting = 'INTERPOLATED_Time'; % Needs to be cumulative time variable created when running H1_RunConvertStrides2Time

%% Loading
% Custom code that finds all the symmetry index variables and performs
% exponential fitting on these.
TimeSubCondGroup = load(fullfile(ProcessedFolder,TimeSubCondGroupFileName)); % Enter the path to the folder with the data here
vars = fieldnames(TimeSubCondGroup);  % list all variables
SI_VarNames = vars(endsWith(vars, '_SI') | endsWith(vars, '_CROSSCORR'));  % select symmetry variables that end with '_SI'

%% MAIN FUNCTION: FitExpProtocol
for v = 1:numel(SI_VarNames)
    for s = 1:size(TimeSubCondGroup.(SI_VarNames{v}),2)
        for c = 1:size(TimeSubCondGroup.(SI_VarNames{v}),3)
            for g = 1:size(TimeSubCondGroup.(SI_VarNames{v}),4)
                Time = TimeSubCondGroup.(TimeVariableForExpFitting)(:,s,c,g);
                Y = TimeSubCondGroup.(SI_VarNames{v})(:,s,c,g);
                [SubCondGroupResults.([SI_VarNames{v},'_ASYMPTOTE'])(s,c,g ),...
                    TimeSubCondGroupResults.([SI_VarNames{v},'_FIT'])(:,s,c,g ),...
                    SubCondGroupResults.([SI_VarNames{v},'_INTERCEPT'])(s,c,g ),...
                    SubCondGroupResults.([SI_VarNames{v},'_FITEND'])(s,c,g ),...
                    SubCondGroupResults.([SI_VarNames{v},'_TCONST'])(s,c,g ),...
                    SubCondGroupResults.([SI_VarNames{v},'_T95PCNT'])(s,c,g ),...
                    SubCondGroupResults.([SI_VarNames{v},'_RSQUARED'])(s,c,g )]  = FitBestExp(Time, Y); % This can be run with a fixed timeconstant, e.g. 42 for metabolic cost. Or an uncontstrained timeconstant for doing learning fits.
            end
        end
    end
end

save(fullfile(ProcessedFolder,SubCondGroupFileName),'-struct','SubCondGroupResults');
save(fullfile(ProcessedFolder,TimeSubCondGroupFileName),'-struct','TimeSubCondGroupResults', '-append');

