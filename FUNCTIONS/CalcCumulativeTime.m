function [PcntStrideSubCondGroup_CUMUL_time] = CalcCumulativeTime(PcntStrideSubCondGroup_TIME, CondSeqVec)
% This function calculates a new timeseries with cumulative time.

% INPUTS
% PcntStrideSubCondGroup_TIME = Original time as 4D matrix with the
% following dimensions PcntStrideSubCondGroup

% CondSeqVec = optional vector that contains the sequence of conditions. This will
% be used to accumulate the time of conditions that follow after each
% other. If this input is not provided the function will assume that the
% conditions happened in the sequence given by their dimension.

% OUTPUT PcntStrideSubCondGroup_CUMUL_time = Cumulative time as 4D matrix
% with the following dimensions PcntStrideSubCondGroup

% Example command line: [PcntStrideSubCondGroup_CUMUL_time] =
% CalcCumulativeTime(PcntStrideSubCondGroup_TIME, CondSeqVec) 
% 2023-08-02 pmalcolm@unomaha.edu

%% Settings
PcntDim = 1;
StrideDim = 2;
CondDim = 4;

%% Handling optional inputs
if ~exist('CondSeqVec', 'var'); CondSeqVec = 1:size(PcntStrideSubCondGroup_TIME,CondDim); end

%% First condition: cumul time = just time
PcntStrideSubCondGroup_CUMUL_time(:,:,:,1,:) = PcntStrideSubCondGroup_TIME(:,:,:,CondSeqVec(1),:);

%% Main: Next conditions: cumul time = time plus sum of elapsed time so far
for n = 2:numel(CondSeqVec)
    ElapsedTimePreviousConditions = max(max(PcntStrideSubCondGroup_CUMUL_time(:,:,:,CondSeqVec(n-1),:),[],PcntDim,'omitnan'),[],StrideDim,'omitnan');
    PcntStrideSubCondGroup_CUMUL_time(:,:,:,CondSeqVec(n),:) =  PcntStrideSubCondGroup_TIME(:,:,:,CondSeqVec(n),:) + ElapsedTimePreviousConditions;
end
