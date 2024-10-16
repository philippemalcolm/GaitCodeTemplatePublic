function StrideSubCondGroupCROSSCORR = CalcCrossCorrel(PcntStrideSubCondGroupStruct)
% Calculates cross correlation index of all scalars that exist both for the right
% and left side.

% INPUTS StrideSubCondStruct = structure that contains stridescalars
% organized as StrideSubCondGroup.

% OUTPUT StrideSubCondGroupSI = structure that contains symmetry-index
% scalars Symmetry-index is calculated as a percentage using
% (right - left) / (mean of right and left) * 100

% Example command line: StrideSubCondGroupSI =
% CalcSymIndex(StrideSubCondGroupStruct) 2023-08-02 pmalcolm@unomaha.edu

VarNames = fieldnames(PcntStrideSubCondGroupStruct);
RightVarNames = VarNames(~cellfun('isempty', regexpi(VarNames, 'R*')));
for n = 1:numel(RightVarNames)
    try
        MatchingLeftVar = ['L',RightVarNames{n}(2:end)];

        for Stride = 1:size(PcntStrideSubCondGroupStruct,2)
            for Sub = 1:size(PcntStrideSubCondGroupStruct,3)
                for Cond = 1:size(PcntStrideSubCondGroupStruct,4)
                    for Group = 1:size(PcntStrideSubCondGroupStruct,5)
                        Corr = corrcoef( PcntStrideSubCondGroupStruct.(RightVarNames{n})(:,Stride,Sub,Cond,Group),PcntStrideSubCondGroupStruct.(MatchingLeftVar)(:,Stride,Sub,Cond,Group) ) * 100;
                        StrideSubCondGroupCROSSCORR.([RightVarNames{n}(2:end),'_SI'])(Stride,Sub,Cond,Group) = Corr(2);
                    end
                end
            end
        end
    catch
    end
end

