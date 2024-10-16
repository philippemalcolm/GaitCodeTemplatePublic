function [HcIdx, HcTimes] = FindHeelContacts(Time,Grf)
%% SETTINGS
FrameRate = round(1/median(diff(Time),'omitnan'),0);
CutOff = 6;
N = 4;

if median(Grf,'omitnan') < 0
    Grf = - Grf;
end

BodyWeight = mean(Grf,'omitnan')*2;

EstimatedDutyFactor = 0.65;
FineThreshold = prctile(Grf,100-(EstimatedDutyFactor+0.10)*100);

clear EstimatedDutyFactor

%% FILTERING BEFORE COARSE DETECTION
Wn = CutOff/(FrameRate/2);
[B,A] = butter(N,Wn);
Grf(isnan(Grf)) = 0;
FiltrdGrf = filtfilt(B,A,Grf);
clear Wn B A N CutOff FrameRate

%% COARSE DETECTION
CoarseHeelContactIndices = nan(size(FiltrdGrf));
for n = 2:length(FiltrdGrf)
    if FiltrdGrf(n-1) < BodyWeight/3 && FiltrdGrf(n) >= BodyWeight/3
        CoarseHeelContactIndices(n) = n;
    end
end
CoarseHeelContactIndices = unique(CoarseHeelContactIndices(~isnan(CoarseHeelContactIndices)));

clear n FiltrdGrf BodyWeight

%% FINE DETECTION
GrfBelowFineThreshold = 1:length(Time);
GrfBelowFineThreshold(Grf > FineThreshold) = NaN;
FineHeelContactIndices = nan(size(CoarseHeelContactIndices));
for n = 1:length(CoarseHeelContactIndices)
    FineHeelContactIndices(n) = nanmax(GrfBelowFineThreshold(nanmax([1,CoarseHeelContactIndices(n)-1000]):CoarseHeelContactIndices(n)));
end

%% FINDING CORRESPONDING INDEX
HcIdx = FineHeelContactIndices(~isnan(FineHeelContactIndices));
HcTimes = Time(HcIdx);

HcIdx = HcIdx(:);
HcTimes = HcTimes(:);

% plot(grf_z_r_VECTOR); hold on; plot(HeelContactIndices,zeros(size(HeelContactIndices)),'*'); plot(ToeOffIndices,zeros(size(ToeOffIndices)),'*')




