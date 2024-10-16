function [lme,ResultEquation] = FitStepwiseLme(Table, Equation)

%% Get x, y, z, subjects, etc from table
arrayfun(@(col) assignin('caller', col{:}, Table{:, col{:}}), Table.Properties.VariableNames, 'UniformOutput', false);

%% Split equation in response variable, fixed terms, and random factor
% response variable
Equation = strsplit(Equation,{'~', '+(', '+ (', '+  ('});
ResponseVar = eval(Equation{1});
% fixed terms
Terms = strsplit(Equation{2},'+');
for n = 1:numel(Terms)
    FixedFactors(:,n) = eval(Terms{n});
end
% random factor
RandFactor = eval(strrep(Equation{3},')',''));
RandFactor = categorical(RandFactor); % PMALCOLM 2024-07-25 considers subject nrs as categorical variable. Now it no longer matters whether the numbers start from 1 or which participant has which number...

%% Run Lin mixed effects
lme = StepwiseMatrixLme(FixedFactors, ResponseVar, RandFactor);

%% Get result equation
TermIdx = str2double(string(strrep(lme.CoefficientNames,'x','')));
ResultEquation = [];
for n = 1:length(TermIdx)
    NewPart = ['+ ',num2str(lme.Coefficients.Estimate(n,1)),' *', Terms{TermIdx(n)}];
    ResultEquation = [ResultEquation, NewPart];
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Subfunction
function lme = StepwiseMatrixLme(FixedFactors, ResponseVar, RandFactor)
lme = fitlmematrix(FixedFactors, ResponseVar,[],RandFactor); % PMALCOLM 2024-07-25 uses subject nrs as categorical variable
pValues = lme.Coefficients.pValue;
OrigColIdx = 1:size(FixedFactors,2);
OrigColNames = lme.CoefficientNames;

while max(pValues) > 0.05 && length(pValues) > 1
    [~,MaxPidx] = max(pValues);
    FixedFactors = FixedFactors(:,[1:MaxPidx-1, MaxPidx+1:end]);
    OrigColIdx = OrigColIdx([1:MaxPidx-1, MaxPidx+1:end]);
    lme = fitlmematrix(FixedFactors, ResponseVar,[],RandFactor, 'FixedEffectPredictors',OrigColNames(OrigColIdx)); % PMALCOLM 2024-07-25 uses subject nrs as categorical variable
    pValues = lme.Coefficients.pValue;
end
end