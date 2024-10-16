function PcntSUBCondGroup = Convert2MedianOfNstrideTs(PcntSTRIDEsubCondGroup, nStrides, FirstLastOrBoth)
warning(['We made a major update to the Convert2MedianOfNstrideTs() function.' ...
'The 3rd output now requires to use a string that indicates whether the First, Last or Both the first and the last xxx strides are averaged' ...
'This is part of a 2 major simplifications to prevent that the scripts and filenames need to be adjusted depending on whether the project uses groups merging of conditions. ' ...
'See Github page for the suggested usage. Old projects may need to manually download a version of the function before 2024-09-19.'])

%% Settings
StrideDim = 2;
CondDim = 4;

%% Initializing
VarNames = fieldnames(PcntSTRIDEsubCondGroup);
NanSizeVec = size(permute(mean(PcntSTRIDEsubCondGroup.(VarNames{1}),StrideDim),[1 3 4 5 StrideDim]));

%% Main mode that averages ALL the strides
for v = 1:numel(VarNames)
    Variable = PcntSTRIDEsubCondGroup.(VarNames{v})(:,:,:,:,:);

    if ~exist('nStrides','var')
        PcntSUBCondGroup.(VarNames{v}) = permute(median(Variable,StrideDim,'omitnan'), [1 3 4 5 StrideDim]);
    else

        %% special mode: if the number of strides is defined then only the median of those strides is calculated
        if strcmp(FirstLastOrBoth,'Both')
            PcntSUBCondGroup.(VarNames{v}) = nan([NanSizeVec(1:2),NanSizeVec(3)*2,NanSizeVec(4:end)]);
        else
        PcntSUBCondGroup.(VarNames{v}) = nan(NanSizeVec);
        end

        for Sub = 1:size(Variable,3)
            for Cond = 1:size(Variable,4)
                for Group = 1:size(Variable,5)

                    NoNanStrides = find(~isnan(Variable(1,:,Sub,Cond,Group)));
                    if ~isempty(NoNanStrides)
                        if strcmp(FirstLastOrBoth,'Both') 
                            PcntSUBCondGroup.(VarNames{v})(:,Sub,Cond*2-1,Group) = permute(median(Variable(:,NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'),[1 3 4 5 StrideDim]); % Calculates median of first nStrides
                            PcntSUBCondGroup.(VarNames{v})(:,Sub,Cond*2,Group) = permute(median(Variable(:,NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),StrideDim,'omitnan'),[1 3 4 5 StrideDim]); % Calculates median of the last nStrides

                        elseif strcmp(FirstLastOrBoth,'First')
                            PcntSUBCondGroup.(VarNames{v})(:,Sub,Cond,Group) = permute(median(Variable(:,NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'),[1 3 4 5 StrideDim]); % Calculates median of the first nStrides
                        elseif  strcmp(FirstLastOrBoth,'Last')
                            PcntSUBCondGroup.(VarNames{v})(:,Sub,Cond,Group) = permute(median(Variable(:,NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'),[1 3 4 5 StrideDim]); % Calculates the median of the last nStrides
                        end
                    end
                end
            end
        end
    end
end

