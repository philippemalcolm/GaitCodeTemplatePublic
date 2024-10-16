function [CleanPcntStrideSubCond, OutLiers] = RemoveOutliers(UncleanedPcntStrideSubCond, OutlierDim, IqrCoef, TolerancePrcnt, PlotYesNo)
disp([mfilename,'(',inputname(1),')']);

%% Optional inputs
if ~exist('OutlierDim', 'var'); OutlierDim = 2; end % dimension that will be used to detect outliers. E.g. if dimension 2 and if dimension 2 contains "strides" is chosen then outliers will be detected based on strides that fall outside of q1 or q3 +/- 1.5 times the interquartile range
if ~exist('IqrCoef', 'var'); IqrCoef = 1.5; end % number of times interquartile range that will be used to detect outliers
if ~exist('TolerancePrcnt', 'var'); TolerancePrcnt = 5; end % Tolerance percent for how much of the strides is permitted to briefly exit boundaries. E.g. if TolrncPrcnt is set to 5 then strides that cross the IQR boundaries for less than 5% of the time will not be considered outliers.
if ~exist('PlotYesNo', 'var'); PlotYesNo = false; end

%% Loop through all variables
VarNames = fieldnames(UncleanedPcntStrideSubCond);
for n = 1:numel(VarNames)
    OrigVar = UncleanedPcntStrideSubCond.(VarNames{n});
    OutlierList = ones(size(OrigVar)); % Generates a matrix that will be used to designate where outliers are with NaNs. To clean the data this matrix is then multiplied by all the original data.
    nRows = size(OrigVar,1);
    nSubs = size(OrigVar,3);
    nConds = size(OrigVar,4);

    %% Removing outliers using q1 or q3 +/- ... times iqr
    for Sub = 1:nSubs
        for Cond = 1:nConds
            LowerBound = prctile(OrigVar(:,:,Sub,Cond),25,OutlierDim) - IqrCoef * iqr(OrigVar(:,:,Sub,Cond),OutlierDim); % Generates vector that defines q1 - 1.5 interquartile range
            UpperBound = prctile(OrigVar(:,:,Sub,Cond),75,OutlierDim) + IqrCoef * iqr(OrigVar(:,:,Sub,Cond),OutlierDim); % same but upper bound
            if PlotYesNo && OutlierDim == 2
                subplot(nSubs,nConds,Cond + (Sub-1)*nConds)
                plot(OrigVar(:,:,Sub,Cond),'Color',[.5 .5 .5]); hold on;
                plot(LowerBound,'g','LineWidth',1.5); hold on; plot(UpperBound,'g','LineWidth',1.5); hold on;
                if Sub == nSubs; xlabel(['Dim4: ',num2str(Cond)]); end
                if Cond == 1; ylabel(['Dim3: ',num2str(Sub)]); end
            end

            if OutlierDim == 2 % Outlier removal for stride-based data. This will identify outliers that deviate from the other strides from the same subject or other subjects
                IsWithinBounds = OrigVar(:,:,Sub,Cond) < LowerBound | OrigVar(:,:,Sub,Cond) > UpperBound; % Checks if data falls within iqr bounds
                Idx = logical(prctile(IsWithinBounds, 100-TolerancePrcnt)); % Additional step that tolerates cases where the data only deviates from bounds for a small portion of the stride
                OutlierList(:,Idx,Sub,Cond) = NaN;
                if PlotYesNo
                    for Stride = find(Idx == 1)
                        plot3(1:nRows,OrigVar(:,Stride,Sub,Cond),ones(nRows,1)*Stride,'r','DisplayName',['(:,',num2str(Stride),',',num2str(Sub),',',num2str(Cond),')'])
                    end
                    title(['Dim2: ',num2str(find(Idx == 1))],'Color','r')
                end

            elseif OutlierDim == 1 % Optional second mode that removes outliers for scalar data where the data is provided in a column
                for Dim2 = 1:size(OutlierList,2)
                    Idx = OrigVar(:,Dim2,Sub,Cond) < LowerBound(Dim2) | OrigVar(:,Dim2,Sub,Cond) > UpperBound(Dim2);
                    OutlierList(Idx,Dim2,Sub,Cond) = NaN;
                end
            end
        end
    end

    %% Saving
    CleanPcntStrideSubCond.(VarNames{n}) = OrigVar .* OutlierList;
    OutLiers.(VarNames{n}) = OutlierList;

    if PlotYesNo
        savefig(['FIGS/',num2str(n,'%2d'),VarNames{n},'_OUTLIERS'])
        close all;
    end
end
