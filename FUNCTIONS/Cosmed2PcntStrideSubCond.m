function PcntStrideCond = Cosmed2PcntStrideSubCond(CosmedFilePath, CondSequence, StridenormRTime)
% Loads Cosmed data under the variable names from the column names inside
% the cosmed file. The second input needs to be a simple vector with the
% sequence of the conditions. The third input needs to be stridenormalized
% time from the previously stridenormalized motion capture file. The cosmed
% file needs to have a text marker at the beginning of each
% condition. If certain text markers are missing these can be manually
% added in the recorded file. 

% Example command line: PcntStrideCond =
% Cosmed2PcntStrideSubCond(CosmedFilePath, CondSequence,
% StridenormRTime)

% 2023-09-20 pmalcolm@unomaha.edu

%% Settings
CondDim = 3;

%% Importing
disp([newline,mfilename,'(',CosmedFilePath,')']);
SubData = readtable(CosmedFilePath,'Range','J:BA'); % Read columns starting with timecolumn and ending with marker column.
SubData = SubData(:,{'t', 'VO2', 'VCO2', 'Marker'}); % Keep only relevant columns
SubData = table2struct(SubData,"ToScalar",true); % Convert to struct
%% Segmenting into conditions
CosmedTimeSeconds = SubData.t *24*60*60; % Converts cosmed time which is originally expressed in # days into seconds. 
MarkerIdxs = find(~cellfun(@isempty, SubData.Marker)); % Detect when a marker was placed that indicates the beginning of a condition. 
SubData = rmfield(SubData,"Marker");

%% StrideNormalization
ColNames = fieldnames(SubData);
for n = 1:numel(ColNames)
    for c = 1:size(StridenormRTime,CondDim)
        ConditionRank = find(CondSequence == c); % Finds the rank of the current condition in the protocol. E.g. was this the 1st condition, or the second condition, etc ..
        SyncedTime = CosmedTimeSeconds - CosmedTimeSeconds(MarkerIdxs(ConditionRank));
        [SyncedTime, UniqueIdx] = unique(SyncedTime); % SOLUTION FOR IF TIMEVECTOR HAS REPEATED TIMES
        Data = SubData.(ColNames{n})(UniqueIdx);
        PcntStrideCond.(ColNames{n})(:,:,c) = interp1(SyncedTime, Data, StridenormRTime(:,:,c)); % The actual stridenormalization happens here. 
    end
end


