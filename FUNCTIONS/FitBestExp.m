function [Assymptote, FitWithNans, FitIntercept, FitEnd, TimeConstant, T95Percent, rSquared] = FitBestExp(Time,Y, TimeConstant)
%% Remove NaNs
% FitWithNans = nan(size(Time));
[TimeWoutNans, yWoutNans] = deal(Time(~isnan(Time) & ~isnan(Y)), Y(~isnan(Time) & ~isnan(Y)));

%% Deal with optional inputs
if max(~isnan(Y)) == 1
    if ~exist('TimeConstant', 'var')
        % Find best fitting time constant
        fun = @(Tau) ObtainSquaredError(TimeWoutNans, yWoutNans, Tau);
        InitGuess = 42; % Initial guess
        options = optimset('TolFun', 1e-9, 'TolX', 1e-9, 'MaxFunEvals', 1e6, 'MaxIter', 1e6);
        LowerBound = 1; % LowerBound for fminbound is set to 1s since we typically do not record strides at a rate of less than 1s.
        UpperBound = 100000; % Upperbound set to 100 000s since we typically do not record experiments of more than a few hours.
        [TimeConstant,~] = fminbnd(fun, LowerBound,UpperBound, options);
    end
    T95Percent = -TimeConstant * log(1 - 0.95);

    %% Calculate outputs
    [Assymptote, Fit] = metabolic_rate_estimation(TimeWoutNans,yWoutNans,TimeConstant); % function from : https://drive.google.com/file/d/1UYaNR809JnC8ozoh2cj_uAycL72F-FP4/view

    % interpolating gaps
    % tFit = Time(~isnan(Y));
    % InterpExp1Fun = fit(tFit, Fit, 'exp2');
    % FitWithNans = InterpExp1Fun(Time);

    % % interpolating gaps
    FitWithNans = interp1(Time(~isnan(Y)), Fit, Time,'linear','extrap'); % Linear fit is probably safest in most instances where we have missing data
    % avoiding extrapolation
    % FirstYid = find(~isnan(Y),1,'first');
    % LastYid = find(~isnan(Y),1,'last');
    % FitWithNans([1:FirstYid-1,LastYid:end]) = NaN;

    FitIntercept = Fit(1);
    FitEnd = Fit(end);

    temp = corrcoef(Fit, yWoutNans);
    rSquared = temp(2);

else
    warning('Y of current condition only contains NaNs')
    [Assymptote, FitIntercept, FitEnd, TimeConstant, T95Percent, rSquared]  = deal(NaN);
    FitWithNans = nan(size(Y));
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Subfunctions
function SquaredError = ObtainSquaredError(x, y, tau)
[~,~,SquaredError] = metabolic_rate_estimation(x,y,tau);
end
