function [RStepTime, RStepLength, LStepTime, LStepLength] = CalcSpatioTemp(RTime, RFoot_Y, LTime, LFoot_Y, TREADMILL_SPEED, PCNTFOOTPLACED)
% Calculates step lenght and time

% INPUTS
% RTime, RFoot_Y, LTime, LFoot_Y = Time and anterior-posterior position timeseries of
% the foot in 5D format with dimensions PcntStrideSubCondGroup.

% TREADMILL_SPEED = scalar that defines treadmill speed

% OUTPUT
% RStepTime, RStepLength, LStepTime, LStepLength = scalars of right and
% left step time and length. Since only one scalar is calculated per step
% the percent-stride dimension is now removed. 

% Example command line: [RStepLength, LStepLength, RStepTime, LStepTime] = CalcSpatioTemp(RTime, RFoot_Y, LTime, LFoot_Y, 1.25);
% 2023-04-17 pmalcolm@unomaha.edu

if ~exist("PCNTFOOTPLACED","var"); PCNTFOOTPLACED = 7; end

%% For loop through conditions and strides
[RStepTime, RStepLength, LStepTime, LStepLength] = deal(nan(size(RTime,2),size(RTime,3),size(RTime,4), size(RTime,5)));

for sub = 1:size(RTime,3)
    for cond = 1:size(RTime,4)
        for group = 1:size(RTime,5)

            for str = 1:size(RTime,2)-1
                %% Right
                % Step time
                Rhs = RTime(1,str,sub,cond,group); % Gets heel strike (i.e. the first time of each stride)
                NextRhs = RTime(1,str+1,sub,cond,group);
                NextLeftIdx = find(LTime(1,:,sub,cond,group)>Rhs & LTime(1,:,sub,cond,group)<NextRhs, 1, 'first'); % Finds the index of the corresponding left heel strike by finding the first left heel strike that comes after the current one
                Lhs = LTime(1,NextLeftIdx,sub,cond,group);
                if ~isempty(Lhs) && ~isnan(Lhs) && ~isnan(Rhs)
                    RStepTime(str,sub,cond,group) = Lhs - Rhs; % a "right" step is typically defined as a step that starts with heel contact of the right leg and ends with heel contact of the left leg.

                    % Step length
                    TreadmillDisp =  TREADMILL_SPEED * RStepTime(str,sub,cond,group);
                    RStepLength(str,sub,cond,group) = LFoot_Y(PCNTFOOTPLACED,NextLeftIdx,sub,cond,group) - RFoot_Y(PCNTFOOTPLACED,str,sub,cond,group) + TreadmillDisp;
                end

                %% Left
                % Step time
                Lhs = LTime(1,str,sub,cond,group); % Gets heel strike (i.e. the first time of each stride)
                NextLhs = LTime(1,str+1,sub,cond,group);
                NextRightIdx = find(RTime(1,:,sub,cond,group)>Lhs & RTime(1,:,sub,cond,group)<NextLhs, 1, 'first'); % Finds the index of the corresponding left heel strike by finding the first left heel strike that comes after the current one
                Rhs = RTime(1,NextRightIdx,sub,cond,group);
                if ~isempty(Rhs) && ~isnan(Lhs) && ~isnan(Lhs)
                    LStepTime(str,sub,cond,group) = Rhs - Lhs; % a "left" step is typically defined as a step that starts with heel contact of the right leg and ends with heel contact of the left leg.

                    % Step length
                    TreadmillDisp =  TREADMILL_SPEED * LStepTime(str,sub,cond,group);
                    LStepLength(str,sub,cond,group) = RFoot_Y(PCNTFOOTPLACED,NextRightIdx,sub,cond,group) - LFoot_Y(PCNTFOOTPLACED,str,sub,cond,group) + TreadmillDisp;
                end
            end

        end
    end
end