function [StrideSubCondGroup] = CalcMeanMaxEtc(PcntStrideSubCondGroup, varargin)
% This function allows to calculate scalars for each stride defined by
% specific strings such as 'MAX', 'MEAN', etc.

% INPUTS 
% PcntStrideSubCondGroup = struct with the original timeseries data
% organized as 5D matrices with dimensions PcntStrideSubCondGroup

% varargin = a variable number of strings that define all the scalars that
% you want to obtain. The options 'MAX', 'MIN', 'ROM', MEAN', 'STD'
% respectively calculate the stridemaximum, minimum, range between max and
% min, mean, within-stride standard deviation.

% OUTPUT 
% PcntStrideSubCondGroup = struct with the calculated scalars
% organized as 4D matrices with dimensions StrideSubCondGroup. Since only
% one scalar per stride is calculated the percent-stride dimension is
% removed and the new data is 4D instead of 5D.

% Example command line: [StrideSubCondGroup] =
% CalcMeanMaxEtc(PcntStrideSubCondGroup, varargin)

% 2023-08-02 pmalcolm@unomaha.edu

%% Initializing
OrigVarNames = fieldnames(PcntStrideSubCondGroup);

%% Main
metricTypes = varargin;
for n = 1:numel(OrigVarNames)
    for m = 1:numel(metricTypes)
        metricType = metricTypes{m};
        switch metricType
            case 'MAX'
                StrideSubCondGroup.([OrigVarNames{n},'_MAX']) = permute(max(PcntStrideSubCondGroup.(OrigVarNames{n}),[],'omitnan'), [2,3,4,5,1]);
            case 'MIN'
                StrideSubCondGroup.([OrigVarNames{n},'_MIN']) = permute(min(PcntStrideSubCondGroup.(OrigVarNames{n}),[],'omitnan'), [2,3,4,5,1]);
            case 'ROM'
                StrideSubCondGroup.([OrigVarNames{n},'_ROM']) = permute(max(PcntStrideSubCondGroup.(OrigVarNames{n}),[],'omitnan') - min(PcntStrideSubCondGroup.(OrigVarNames{n}),[],'omitnan'), [2,3,4,5,1]);
            case 'MEAN'
                StrideSubCondGroup.([OrigVarNames{n},'_MEAN']) = permute(mean(PcntStrideSubCondGroup.(OrigVarNames{n}),'omitnan'), [2,3,4,5,1]);
            case 'STD'
                StrideSubCondGroup.([OrigVarNames{n},'_WITHINSTRIDESTD']) = permute(std(PcntStrideSubCondGroup.(OrigVarNames{n}),'omitnan'), [2,3,4,5,1]);
            case 'POS'
                StrideSubCondGroup.([OrigVarNames{n},'_POS']) = permute(mean(max(PcntStrideSubCondGroup.(OrigVarNames{n}),0,'includenan')), [2,3,4,5,1]);
            case 'NEG'
                StrideSubCondGroup.([OrigVarNames{n},'_NEG']) = permute(mean(min(PcntStrideSubCondGroup.(OrigVarNames{n}),0,'includenan')), [2,3,4,5,1]);
            otherwise
                error('Invalid metric type.');
        end
    end
end
