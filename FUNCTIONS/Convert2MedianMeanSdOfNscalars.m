function [SUBCondGroupMEDIAN, SUBCondGroupMEAN, SUBCondGroupSTD] = Convert2MedianMeanSdOfNscalars(STRIDEsubCondGroup, nStrides, FirstLastOrBoth)
warning(['We made a major update to the Convert2MedianOfNstrideTs() function.' ...
'The 3rd output now requires to use a string that indicates whether the First, Last or Both the first and the last xxx strides are averaged' ...
'This is part of a 2 major simplifications to prevent that the scripts and filenames need to be adjusted depending on whether the project uses groups merging of conditions. ' ...
'See Github page for the suggested usage. Old projects may need to manually download a version of the function before 2024-09-19.'])

%% Settings
StrideDim = 1;
CondDim = 3;

%% Initializing
VarNames = fieldnames(STRIDEsubCondGroup);
NanSizeVec = size(permute(mean(STRIDEsubCondGroup.(VarNames{1}),StrideDim),[2 3 4 StrideDim]));

%% Main mode that averages ALL the strides
for v = 1:numel(VarNames)
    Variable = STRIDEsubCondGroup.(VarNames{v})(:,:,:,:);

    if ~exist('nStrides','var')
        SUBCondGroupMEDIAN.(VarNames{v}) = permute(median(Variable,StrideDim,'omitnan'), [2 3 4 StrideDim]);
        SUBCondGroupMEAN.(VarNames{v}) = permute(mean(Variable,StrideDim,'omitnan'), [2 3 4 StrideDim]);
        SUBCondGroupSTD.(VarNames{v}) = permute(std(Variable,[],StrideDim,'omitnan'), [2 3 4 StrideDim]);
    else

        %% special mode: if the number of strides is defined then only the median of those strides is calculated
        if strcmp(FirstLastOrBoth,'Both')
            [SUBCondGroupMEDIAN.(VarNames{v}),SUBCondGroupMEAN.(VarNames{v}),SUBCondGroupSTD.(VarNames{v})]  = deal(nan([NanSizeVec(1),NanSizeVec(2)*2,NanSizeVec(3:end)]));
        else
            [SUBCondGroupMEDIAN.(VarNames{v}),SUBCondGroupMEAN.(VarNames{v}),SUBCondGroupSTD.(VarNames{v})]  = deal(nan(NanSizeVec));
        end

        for Sub = 1:size(Variable,2)
            for Cond = 1:size(Variable,3)
                for Group = 1:size(Variable,4)

                    NoNanStrides = find(~isnan(Variable(:,Sub,Cond,Group)));
                    if ~isempty(NoNanStrides)
                        if strcmp(FirstLastOrBoth,'Both')
                        SUBCondGroupMEDIAN.(VarNames{v})(Sub,Cond*2-1,Group) = permute(median(Variable(NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupMEAN.(VarNames{v})(Sub,Cond*2-1,Group) = permute(mean(Variable(NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupSTD.(VarNames{v})(Sub,Cond*2-1,Group) = permute(std(Variable(NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),[],StrideDim,'omitnan'), [2 3 4 StrideDim]);

                        SUBCondGroupMEDIAN.(VarNames{v})(Sub,Cond*2,Group) = permute(median(Variable(NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupMEAN.(VarNames{v})(Sub,Cond*2,Group) = permute(mean(Variable(NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupSTD.(VarNames{v})(Sub,Cond*2,Group) = permute(std(Variable(NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),[],StrideDim,'omitnan'), [2 3 4 StrideDim]);

                        elseif strcmp(FirstLastOrBoth,'First')
                        SUBCondGroupMEDIAN.(VarNames{v})(Sub,Cond,Group) = permute(median(Variable(NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupMEAN.(VarNames{v})(Sub,Cond,Group) = permute(mean(Variable(NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupSTD.(VarNames{v})(Sub,Cond,Group) = permute(std(Variable(NoNanStrides(1:1+nStrides-1),Sub,Cond,Group),[],StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        elseif  strcmp(FirstLastOrBoth,'Last')
                        SUBCondGroupMEDIAN.(VarNames{v})(Sub,Cond,Group) = permute(median(Variable(NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupMEAN.(VarNames{v})(Sub,Cond,Group) = permute(mean(Variable(NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        SUBCondGroupSTD.(VarNames{v})(Sub,Cond,Group) = permute(std(Variable(NoNanStrides(end-nStrides+1:end),Sub,Cond,Group),[],StrideDim,'omitnan'), [2 3 4 StrideDim]);
                        end
                    end
                end
            end
        end
    end
end


