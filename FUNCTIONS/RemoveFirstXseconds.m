function [TrimmedPcntStrideSubCond, RemovedDataList] = RemoveFirstXseconds(UnTrimmedPcntStrideSubCond, TimeVar, SecondsToTrim)
disp([mfilename,'(',inputname(1),')']);

%% Loop through all variables
VarNames = fieldnames(UnTrimmedPcntStrideSubCond);

for n = 1:numel(VarNames)
    OrigVar = UnTrimmedPcntStrideSubCond.(VarNames{n});
    RemovalListOfVar = nan(size(OrigVar)); % Generates a matrix that will be used to designate where outliers are with NaNs. To clean the data this matrix is then multiplied by all the original data.

    %% Keeping only columns that are past the trimmed seconds
    for Dim2 = 1:size(OrigVar,2)
        for Dim3 = 1:size(OrigVar,3)
            for Dim4 = 1:size(OrigVar,4)
                if min(TimeVar(:,Dim2,Dim3,Dim4),[],'omitnan') > SecondsToTrim
                    RemovalListOfVar(:,Dim2,Dim3,Dim4) = 1; % 
                end
            end
        end
    end

    %% Saving
    TrimmedPcntStrideSubCond.(VarNames{n}) = OrigVar .* RemovalListOfVar; % This cleans the data by multiplying cases where only zeros were found with NaN
    RemovedDataList.(VarNames{n}) = RemovalListOfVar;
end
