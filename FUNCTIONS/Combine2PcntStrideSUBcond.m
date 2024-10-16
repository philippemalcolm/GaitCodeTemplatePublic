function PcntStrideSubCond = Combine2PcntStrideSUBcond(PcntStrideSubCondFilepaths)
% Combines data from subject folders into single .mat-file in format from Jackson and Collins, 2015.
% COMPLETE DATA IS SAVED AS POPDATA WITH STRIDETIME IN 1ST, STRIDES IN 2ND, CONDITIONS IN 3RD AND SUBJECTS IN 4TH DIMENSION
% AVERAGE STRIDEDATA IS ALSO SAVED AS POPAVG WITH STRIDETIME IN 1ST, SUBJECTS IN 2ND, AND CONDITIONS IN 3RD DIMENSION
% Requires subject folders 's01', 's02', etc with stridenormalized subject data saved as 'SubData.mat'.
% Example command line: [TimeStridesSubsConds, TimeSubsConds] = CombineTimeStridesCondsFiles(TimeStridesCondsFiles)
% 2023-04-14, Hiva Razavi, Philippe Malcolm

%% Initialization
disp([newline,mfilename]);
VarNames = who(matfile(PcntStrideSubCondFilepaths{1})); % Gets list of variables from first subject. Note: if subject 01 does not have all variables then this line needs to be modified to get the complete list from another subject.

%% Importing entire data (all strides)
for Sub = 1:numel(PcntStrideSubCondFilepaths) % loops through subjects
    disp(PcntStrideSubCondFilepaths{Sub});
    SubData = load(PcntStrideSubCondFilepaths{Sub});
    for v = 1:numel(VarNames) % loops through variables
        for Stride = 1:size(SubData.(VarNames{v}),2)
            for Cond = 1:size(SubData.(VarNames{v}),3)
                try
                    PcntStrideSubCond.(VarNames{v})(:,Stride,Sub,Cond) = SubData.(VarNames{v})(:,Stride,Cond);
                catch
                    disp([VarNames{v},' does not exist in ',PcntStrideSubCondFilepaths{s}]);
                end
            end
        end
        % try
        %     PcntStrideSubCond.(VarNames{v})(:,:,s,:) = permute(SubData.(VarNames{v}),[1 2 4 3]); % ADDS SUBJDATA TO 4D MATRIX POPDATA WITH STRIDETIME IN 1ST, STRIDES IN 2ND, SUBJECTS IN 3RD DIMENSION, CONDITIONS 4TH
        % catch
        %     disp([VarNames{v},' does not exist in ',PcntStrideSubCondFilepaths{s}]);
        % end
    end
end