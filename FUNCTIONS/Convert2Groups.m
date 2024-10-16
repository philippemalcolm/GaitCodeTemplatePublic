function [PcntStrideSubCondGROUP] = Convert2Groups(PcntStrideSubCond, GroupCol)
% This function allows converts original data (e.g. TimeSubsConds) into
% data organized into different groups (e.g. TimeSubsCondsGroups).
% Code works for different dimensions of original data (2D, 3D, etc)
% Example command line: [TimeSubsCondsGroups] = OrganizeByGroups(TimeSubsConds, SubjDim, GroupList)
% 2023/../.. Philippe Malcolm

%% Settings
if ~isnan(GroupCol);
    SubjDim = 3;

    %% Initializing and optional inputs
    VarNames = fieldnames(PcntStrideSubCond);

    if ~exist("GroupCol",'var')
        GroupCol = ones(size(PcntStrideSubCond.(VarNames{1}),SubjDim),1);
    end

    nGroups = max(GroupCol);
    NanSizeVec = [size(PcntStrideSubCond.(VarNames{1})), nGroups];

    %% MAIN
    for v = 1:numel(VarNames)
        PcntStrideSubCondGROUP.(VarNames{v})(:,:,:,:,:) = nan(NanSizeVec);

        for g = 1:max(GroupCol)
            SubjsInGroup = find(GroupCol == g);
            PcntStrideSubCondGROUP.(VarNames{v})(:,:,SubjsInGroup,:,g) = PcntStrideSubCond.(VarNames{v})(:,:,SubjsInGroup,:);
        end
    end

else
        PcntStrideSubCondGROUP = PcntStrideSubCond; % If group column does not exist do noting.
end



