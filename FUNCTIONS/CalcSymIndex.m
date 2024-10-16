function StrideSubCondGroupSI = CalcSymIndex(StrideSubCondGroupStruct)
% Calculates symmetry index of all scalars that exist both for the right
% and left side.

% INPUTS StrideSubCondStruct = structure that contains stridescalars
% organized as StrideSubCondGroup.

% OUTPUT StrideSubCondGroupSI = structure that contains symmetry-index
% scalars Symmetry-index is calculated as a percentage using
% (right - left) / (mean of right and left) * 100

% Example command line: StrideSubCondGroupSI =
% CalcSymIndex(StrideSubCondGroupStruct) 2023-08-02 pmalcolm@unomaha.edu

VarNames = fieldnames(StrideSubCondGroupStruct);
RightVarNames = VarNames(~cellfun('isempty', regexpi(VarNames, 'R*')));
for n = 1:numel(RightVarNames)
    try
        MatchingLeftVar = ['L',RightVarNames{n}(2:end)];
        SymIndex = ( StrideSubCondGroupStruct.(RightVarNames{n}) - StrideSubCondGroupStruct.(MatchingLeftVar) ) ./ ...
            ((StrideSubCondGroupStruct.(RightVarNames{n}) + StrideSubCondGroupStruct.(MatchingLeftVar))/2) * 100;

        StrideSubCondGroupSI.([RightVarNames{n}(2:end),'_SI']) = SymIndex;
    catch
    end
end

