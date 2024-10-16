function PcntStrideCond = Humotech2PcntStrideSubCond(HuMoTechFilePath, CondSequence, StridenormRTime, SyncSignalName, TimeSignalName)
% Loads humotech data under the variable names from the signalNames inside
% the humotech mat file. The second input needs to be a simple vector with
% the sequence of the conditions. The third input needs to be
% stridenormalized time from the previously stridenormalized motion capture
% file.

% Example command line: PcntStrideCond =
% Humotech2PcntStrideSubCond(HuMoTechFilePath, CondSequence,
% StridenormRTime)

% 2023-09-20 hrazavi@unomaha.edu, pmalcolm@unomaha.edu

%% Settings and optional settings
if ~exist("SyncSignalName",'var'); SyncSignalName = 'Signal3'; end
if ~exist("TimeSignalName",'var'); TimeSignalName = 'Time'; end
CondDim = 3;

%% Loading
load(HuMoTechFilePath,"signalNames","data")
disp([newline,mfilename,'(',HuMoTechFilePath,')']);
SubData = table2struct(array2table(data,'VariableNames',signalNames'),"ToScalar",true);

HumotechTime = SubData.(TimeSignalName);
Sync = SubData.(SyncSignalName);

%% Detect triggers
Sync = round((Sync - prctile(Sync,1))/(prctile(Sync,99)-prctile(Sync,1))); % Rounds the sync signal to a binary signal between 0 to 1
[~,StartIdxs] = findpeaks(diff(Sync)); % Finds the rising edges

%% StrideNormalization
signalNames = fieldnames(SubData);
for n = 1:numel(signalNames)
    for c = 1:size(StridenormRTime,CondDim)
        ConditionRank = find(CondSequence == c); % Finds the rank of the current condition in the protocol. E.g. was this the 1st condition, or the second condition, etc ..
        SyncedTime = HumotechTime - HumotechTime(StartIdxs(ConditionRank));
        PcntStrideCond.(signalNames{n})(:,:,c) = interp1(SyncedTime, SubData.(signalNames{n}), StridenormRTime(:,:,c));
    end
end


