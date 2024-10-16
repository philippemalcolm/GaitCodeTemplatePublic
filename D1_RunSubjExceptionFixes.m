% Script to handle project-specific or subject-specific exceptions, such as
% conditions that were missed or repeated.
% Add custom scripts for fixing subject-specitic or project-specific
% exceptions here rather than manually fixing these exceptions. By doing
% these fixes in a script you will enable others who look at your project
% to keep track of what was done.
% THE PRESENT FILE CONTAINS AN EXAMPLE OF FIXES FOR A SPECIFIC PROJECT. 
% THIS NEEDS TO BE REPLACED BY OTHER CODE FOR OTHER PROJECTS. 

% Example command line: C1_RunSubjExceptionFixes

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
close all; clear; clc;
addpath('FUNCTIONS');
disp([newline,mfilename]);

%% Settings
ProcessedFolder = 'PROCESSED'; % ENTER PATH TO FOLDER WITH PROCESSED DATA HERE

%% MAIN CODE
%% Fixes for S09: THIS IS AN EXAMPLE OF FIXES FOR A SPECIFIC PROJECT. THIS NEEDS TO BE REPLACED BY OTHER CODE FOR OTHER PROJECTS. 
try
UncorrectPcntStrideCond = load('PROCESSED/S09/PcntStrideCond');
if size(UncorrectPcntStrideCond.RTime,3) == 6 % Checks if the fix has not yet been performed. If it is already done then the size will be smaller than 6 and the fix should not be performed twice because that would result in incorrectly merged and shifted data.

    % Special correction for the time column so that the added time of the new condition will not start from zero
    ElapseTime = max([UncorrectPcntStrideCond.RTime(100,:,2), UncorrectPcntStrideCond.LTime(100,:,2)],[],'omitnan'); % Calculates elapsed time of condition 2
    UncorrectPcntStrideCond.RTime(:,:,3) = UncorrectPcntStrideCond.RTime(:,:,3) + ElapseTime;
    UncorrectPcntStrideCond.LTime(:,:,3) = UncorrectPcntStrideCond.LTime(:,:,3) + ElapseTime;

    % Correction of other variables
    MaxStridesCond2 = find(~isnan(sum([UncorrectPcntStrideCond.RTime(100,:,2); UncorrectPcntStrideCond.LTime(100,:,2)])),1,'last');
    VarNames = fieldnames(UncorrectPcntStrideCond);
    for n = 1:numel(VarNames)
        % Cond 1 remains
        PcntStrideCond.(VarNames{n})(:,:,1) = UncorrectPcntStrideCond.(VarNames{n})(:,:,1);

        % Merging ORIGINAL conditions 2 and 3 into NEW condition 1
        Merged = [UncorrectPcntStrideCond.(VarNames{n})(:,1:MaxStridesCond2,2), UncorrectPcntStrideCond.(VarNames{n})(:,:,3)];
        PcntStrideCond.(VarNames{n})(:,:,2) = Merged(:,1:600);

        % Shifting other conditions one back
        for c = 3:5
            PcntStrideCond.(VarNames{n})(:,:,c) = UncorrectPcntStrideCond.(VarNames{n})(:,:,c+1);
        end
    end
    save('PROCESSED/S09/PcntStrideCond','-struct','PcntStrideCond')
end
catch 
    disp('S09 not in folder') 
end
clear PcntStrideCond Merged

%% Fixes for S14
try
UncorrectPcntStrideCond = load('PROCESSED/S14/PcntStrideCond');
if size(UncorrectPcntStrideCond.RTime,3) == 6
    % Special correction for the time column of condition #4 so that the added time of the new condition will not start from zero
    ElapseTime = max([UncorrectPcntStrideCond.RTime(100,:,4), UncorrectPcntStrideCond.LTime(100,:,4)],[],'omitnan');
    UncorrectPcntStrideCond.RTime(:,:,5) = UncorrectPcntStrideCond.RTime(:,:,5) + ElapseTime;
    UncorrectPcntStrideCond.LTime(:,:,5) = UncorrectPcntStrideCond.LTime(:,:,5) + ElapseTime;

    % Correction of other variables
    MaxStridesCond4 = find(~isnan(sum([UncorrectPcntStrideCond.RTime(100,:,4); UncorrectPcntStrideCond.LTime(100,:,4)])),1,'last');
    VarNames = fieldnames(UncorrectPcntStrideCond);
    for n = 1:numel(VarNames)
        % Cond 1 to 3 remains
        PcntStrideCond.(VarNames{n})(:,:,1:3) = UncorrectPcntStrideCond.(VarNames{n})(:,:,1:3);

        % Merging ORIGINAL conditions 4 and 5 into NEW condition 4
        Merged = [UncorrectPcntStrideCond.(VarNames{n})(:,1:MaxStridesCond4,4), UncorrectPcntStrideCond.(VarNames{n})(:,:,5)];
        PcntStrideCond.(VarNames{n})(:,:,4) = Merged(:,1:600);

        % Shifting other conditions one back
        PcntStrideCond.(VarNames{n})(:,:,5) = UncorrectPcntStrideCond.(VarNames{n})(:,:,6);
    end
    save('PROCESSED/S14/PcntStrideCond','-struct','PcntStrideCond')
end
catch 
    disp('S14 not in folder') 
end