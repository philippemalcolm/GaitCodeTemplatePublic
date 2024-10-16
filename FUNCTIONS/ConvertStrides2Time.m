function [TimeSubCondGroup] = ConvertStrides2Time(StrideSubCondGroup, TimeBasis)
VarNames = fieldnames(StrideSubCondGroup);
for v = 1:numel(VarNames)
    TimeSubCondGroup.(VarNames{v}) = nan(size(StrideSubCondGroup.(VarNames{1})));
    for c = 1:size(TimeBasis,3)
        BeginTime = max(min(mean(TimeBasis(:,:,c,:),4,'omitnan'),[],1,'omitnan'));
        EndTime = min(max(mean(TimeBasis(:,:,c,:),4,'omitnan'),[],1,'omitnan'));
        for g = 1:size(TimeBasis,4)
            %             BeginTime = mean(min(TimeBasis(:,:,c,g),[],'omitnan'),'omitnan');
            %             EndTime = mean(max(TimeBasis(:,:,c,g),[],'omitnan'),'omitnan');
            TimeSubCondGroup.INTERPOLATED_Time(:,:,c,g) = reshape(linspace(BeginTime,EndTime,size(TimeBasis,1)),[],1) * ones(1,size(TimeBasis,2));
            for s = 1:size(TimeBasis,2)
                [x, y] = RemoveNans(TimeBasis(:,s,c,g), StrideSubCondGroup.(VarNames{v})(:,s,c,g));
                [~,idx] = unique(x);
                [x,y] = deal(x(idx),y(idx));

                if ~ (isempty(x) || length(x)<2)
                    TimeSubCondGroup.(VarNames{v})(:,s,c,g) = interp1(x, y, TimeSubCondGroup.INTERPOLATED_Time(:,s,c,g),'linear');
                end
            end
        end
    end
end

% Debugging notes: small error in subject 12, group 1, cond 5
% only 1 datapoint available