function [SubCondGroupResults, TimeSubCondGroupFit] = FitExpProtocol(CumulTime, TimeSubCondGroupVar)

%% Initilizing
[SubCondGroupResults.([VarName,'TIMECONSTANT']),SubCondGroupResults.([VarName,'T95PERCENT']), SubCondGroupResults.([VarName,'INTERCEPT']), SubCondGroupResults.([VarName,'FITEND']), SubCondGroupResults.([VarName,'ASSYMPTOTE']), SubCondGroupResults.([VarName,'RSQUARED'])] ...
    =deal(nan(size(squeeze(mean(TimeSubCondGroupVar)))));
TimeSubCondGroupFit.([VarName,'FIT']) = nan(size(((TimeSubCondGroupVar))));
