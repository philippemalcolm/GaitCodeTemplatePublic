function [ComPow, Collision, Rebound, Preload, PushOff, VertVel, ApAccel] = CalcComPower(Time,RightApGrf,RightVertGrf,TreadmillSpeed)


% Calculates ...

% INPUTS
%...

% OUTPUT
% ...

% Example command line: ...
% 2023-04-17 pmalcolm@unomaha.edu
% clear; load temp.mat

%% SETTINGS
TreadmillSpeed = reshape(TreadmillSpeed(:),1,1,length(TreadmillSpeed)); % Places subjDim in the 3rd dimension (assuming that the file is of the type PcntStrideSubCondEtc...)

%%
TotVertGrf = RightVertGrf + RightVertGrf([51:end,1:50],:,:,:,:);
BodyMass = mean(TotVertGrf(:),1,'omitnan')/9.81;

NetVertForce = TotVertGrf - mean(TotVertGrf);
VertAccel = NetVertForce ./ BodyMass;

VertVel = cumtrapz(VertAccel).*mean(diff(Time));
VertVel = VertVel - mean(VertVel);
% VertPos = cumtrapz(VertAccel).*mean(diff(Time));
% VertPos = VertPos - mean(VertPos)

VertComPow = VertVel.* RightVertGrf;

%%
TotApGrf = RightApGrf + RightApGrf([51:end,1:50],:,:,:,:);

NetApForce = TotApGrf - mean(TotApGrf);
ApAccel = NetApForce ./ BodyMass;

ApVel = cumtrapz(ApAccel).*mean(diff(Time));
ApVel = ApVel - mean(ApVel) + TreadmillSpeed;
% ApPos = cumtrapz(ApAccel).*mean(diff(Time));
% ApPos = ApPos - mean(ApPos)

ApComPow = ApVel.* RightApGrf;

ComPow = VertComPow + ApComPow;

%%
for Stride = 1:size(ComPow,2)
    for Sub = 1:size(ComPow, 3)
        for Cond = 1:size(ComPow, 4)
            for Group = 1:size(ComPow, 5)
                NegComPow = min(ComPow(:,Stride,Sub,Cond, Group),0);
                PosComPow = max(ComPow(:,Stride,Sub,Cond, Group),0);

                NegIdx = find(NegComPow < 0);
                PosIdx = find(PosComPow > 0);
                tRebStart = min(PosIdx(PosIdx >=7));
                tPreStart = min(NegIdx(NegIdx >=20));
                tPushStart = min(PosIdx(PosIdx >=40));

                Temp = NegComPow; Temp(tRebStart:end) = 0;
                Collision(Stride,Sub,Cond, Group) = mean(Temp);

                Temp = PosComPow; Temp([1:tRebStart-1,tPreStart:end]) = 0;
                Rebound(Stride,Sub,Cond, Group) = mean(Temp);

                Temp = NegComPow; Temp([1:tPreStart-1,tPushStart:end]) = 0;
                Preload(Stride,Sub,Cond, Group) = mean(Temp);

                Temp = PosComPow; Temp([1:tPushStart-1,95:end]) = 0;
                PushOff(Stride,Sub,Cond, Group) = mean(Temp);

                if any(isnan(ComPow(:,Stride,Sub,Cond, Group)))
                    [Collision(Stride,Sub,Cond, Group), Rebound(Stride,Sub,Cond, Group), Preload(Stride,Sub,Cond, Group), PushOff(Stride,Sub,Cond, Group)] = deal(nan);
                end
            end
        end
    end
end
