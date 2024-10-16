function [CleanedPcntStrideSubCond, RemovedDataList] = RemoveZeroColumns(UncleanedPcntStrideSubCond)
disp([mfilename,'(',inputname(1),')']);

%% Loop through all variables
VarNames = fieldnames(UncleanedPcntStrideSubCond);

for n = 1:numel(VarNames)
    OrigVar = UncleanedPcntStrideSubCond.(VarNames{n});
    RemovalListOfVar = ones(size(OrigVar)); % Generates a matrix that will be used to designate where outliers are with NaNs. To clean the data this matrix is then multiplied by all the original data.

    %% Removing columns that contains only zeros
    for Dim2 = 1:size(OrigVar,2)
        for Dim3 = 1:size(OrigVar,3)
            for Dim4 = 1:size(OrigVar,4)
                if all(OrigVar(:,Dim2,Dim3,Dim4) == 0)
                    RemovalListOfVar(:,Dim2,Dim3,Dim4) = NaN; % This designates columns that contain only 0 as outliers.
                end
            end
        end
    end

    %% Saving
    CleanedPcntStrideSubCond.(VarNames{n}) = OrigVar .* RemovalListOfVar; % This cleans the data by multiplying cases where only zeros were found with NaN
    RemovedDataList.(VarNames{n}) = RemovalListOfVar;
end
