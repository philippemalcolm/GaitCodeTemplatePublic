function PcntStrideCond = Mocap2PcntStrideCond(Vis3dFileName, CondCol, nStrides)
% Converts vis3 data to 3d matlab format from Jackson and Collins, 2015. (Jackson, R. W., & Collins, S. H. (2015). An experimental comparison of the relative benefits of work and torque assistance in ankle exoskeletons. Journal of applied physiology, 119(5), 541-557. https://drive.google.com/file/d/1KLgyF6xIWpNyo44zsZoJmeJQKdQJHIu5/view)
% Data is saved as NormData wherein every variable has stridetime in the 1st dimension, strides in the 2nd dimension and conditions in the 3rd dimension.
% Requires .mat export from visual 3d and a vector with condition number sequence.
% Example command line: PcntStrideCond =
% Mocap2PcntStrideCond('s01\Vis3d.mat', [1;2;3;4;5]); % Navigates to 's01' and  converts data according to the condition sequence defined by [1;2;3;4;5]
% 2023-04-14, Hiva Razavi, Philippe Malcolm

%% Optional inputs
if ~exist('nStrides','var'); nStrides = NaN; end % nStrides fixes max size of 3rd dimension of matrix, e.g. 200 strides. Strides that do not exist will be NaNs.

%% Importing
disp([newline,mfilename,'(',Vis3dFileName,')']);
SubData = load(Vis3dFileName);
VarNames = fieldnames(SubData); % Obtains variablenames

%% Loop evaluating type of variable, left/right, etc.
for v = 1:numel(VarNames) % Loop through variablenames
    try
        Var = VarNames{v};
        Ts = SubData(:).(Var);
        Side = Var(1); % Obtains the first letter from the variable which says it if its associated with right or left leg.
        Hs = SubData(:).([Side,'HS']);
        %% The actual stridenormalization
        if size(Ts{1},2) >= 3
            [PcntStrideCond.([Var,'_X']), PcntStrideCond.([Var,'_Y']), PcntStrideCond.([Var,'_Z']), PcntStrideCond.([Side,'Time'])] = StrideNormalize(Ts, Hs, CondCol, nStrides); % Generates 3d-matrices for X, Y, Z and time component with stridetime in the 1st dimension, strides in the 2nd dimension and conditions in the 3rd dimension.
        else
            [PcntStrideCond.(Var), ~, ~, PcntStrideCond.([Side,'Time'])] = StrideNormalize(Ts, Hs, CondCol, nStrides);
        end
    catch
        disp([Var,' not recognized as timeseries.'])
    end
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SUBFUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [NormTs_X, NormTs_Y, NormTs_Z, NormTime] = StrideNormalize(Ts, Hs, CondCol, nStrides)
% This subfunction generates 3d-matrices for X, Y, Z and time component with stridetime in the 1st dimension, strides in the 2nd dimension and conditions in the 3rd dimension.
FrameRate = mode(floor( cellfun(@length,Ts)./cellfun(@max,Hs) /100)*100); % Finds the most likely framerate based on max Hs divided by lenght of data ASSUMING INTEGER NUMBER OF 100S
if isnan(nStrides)
    nStrides = ceil(max(cellfun(@length,Hs))/100)*100;  % Finds max number of strides and rounds this up for preallocating
end
XyzDims = size(Ts{1},2); % Finds whether data has 3 dimensions (e.g. x, y and z)
NormTime = nan(100, nStrides, max(CondCol)); % Preallocate
NormTs = nan(100, nStrides, max(CondCol),3); % Preallocate
for d = 1:XyzDims % loops through X, Y and Z dimensions
    for c = 1:numel(Ts) % loops through conditions
        TsCol = Ts{c}(:,d); % Timeseries that will be normalized
        TimeCol = linspace(0,length(TsCol)/FrameRate,length(TsCol))'; % Corresponding timevector
        HsTims = Hs{c}; % List of heel strikes
        for h = 1:length(HsTims)-1
            NormTime(:,h,CondCol(c)) = linspace(HsTims(h),HsTims(h+1),100)'; % Creates list of 100 times for every stride
            NormTs(:,h,CondCol(c),d) = interp1(TimeCol, TsCol, NormTime(:,h,CondCol(c))); % PERFORMS THE STRIDENORMALIZATION
        end
    end
end
NormTs_X = NormTs(:,:,:,1); NormTs_Y = NormTs(:,:,:,2); NormTs_Z = NormTs(:,:,:,3);
end