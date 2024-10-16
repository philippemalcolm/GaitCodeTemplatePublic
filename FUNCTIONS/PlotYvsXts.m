function f = PlotYvsXts(yPcntSubCond, xPcntSubCond, PlotProperties, AxisLimits)
% This function plots means +/- sem of stridenormalized timeseries of conditions in different colors.
% This requires PopAvg data organized with stridetime in 1st dimension, subjects in 2nd and conditions in 3rd dimension
% Example code: F_PlotStrideTsPerCondition(RAnkle_Angle_X, 'CondPlotStyleProps.mat', [-Inf Inf -Inf Inf], [1,3,5])
% Updated 2023-06-02, Philippe Malcolm

%% Calculating mean and sem
SubjDim = 2; % Dimension in which the subjects or samples exist.
NrSubjs = size(yPcntSubCond,SubjDim); % Obtains number of subjects for calculating median
yMean = permute(mean(yPcntSubCond,SubjDim,'omitnan'),[1,3,SubjDim]); % Calculates the mean from all the participants (by taking average across 2nd dimension)
ySem = permute(std(yPcntSubCond,[],SubjDim,'omitnan'),[1,3,SubjDim]) / sqrt(NrSubjs);  % calculates s.e.m.

%% Handling of optional inputs
if exist('xPcntSubCond', 'var') && ~isempty(xPcntSubCond)
    xMean = permute(mean(xPcntSubCond,SubjDim,'omitnan'),[1,3,SubjDim]);
    xName = strrep(inputname(2),'_',' ');
else
    xMean = reshape(1:size(yMean,1),[],1) * ones(1,size(yMean,2));
    xName = 'Stride time (%)';
end

if ~exist('AxisLimits', 'var')
    AxisLimits = [-Inf, Inf, min(yMean(:) - ySem(:),[],'omitnan'), max(yMean(:) + ySem(:),[],'omitnan')];
end

if ~exist('PlotProperties', 'var')
    PlotProperties = [];
end
if numel(PlotProperties) < size(yMean,2)
    clear PlotProperties
    Colors = lines;
    for d = 1:size(yMean,2)
        PlotProperties(1,d).Color = Colors(d,:);
    end
end
if ~isfield(PlotProperties, 'FontSize'); PlotProperties(1).FontSize = 10; end

% Removal of styles that are not applicable to line plots
StyleNames = fieldnames(PlotProperties);
NotApplicableStyles = setdiff(StyleNames, {'DisplayName','Color','LineStyle','LineWidth','Marker','MarkerSize','MarkerFaceColor','MarkerEdgeColor'});
GraphProperties = rmfield(PlotProperties, NotApplicableStyles);

%% Plotting
f = gcf;  % Get current figure

if AxisLimits(3) <= 0 && AxisLimits(4) >0 || AxisLimits(3) < 0 && AxisLimits(4) >= 0
    plot([min(xMean(:)),max(xMean(:))] ,[0 0],'k') % Plot horizontal axis
end

% Plot standard error bands
for d = 1:size(yMean,2)
    [xNoNan, yNoNan, sdNoNan] = RemoveNans(xMean(:,d), yMean(:,d), ySem(:,d));
    patch([xNoNan;flipud(xNoNan)], [yNoNan+sdNoNan; flipud(yNoNan-sdNoNan)], GraphProperties(d).Color, 'EdgeColor', 'none', 'FaceAlpha',0.25)
end

% Plot means
hold on;
p = nan(size(yMean,2),1);
n = 0;
for d = 1:size(yMean,2)
    n = n+1;
    p(n) = plot(xMean(:,d), yMean(:,d), GraphProperties(d),'Marker','none');
end

% Formatting
legend(p) % Plots legend for n last lines
set(f,'color','w')
xlabel(xName)
ylabel(strrep(inputname(1),'_',' '))
try axis(AxisLimits); catch; end; % try-catch statement is to avoid that this returns error for data that contains horizontal lines only. 
set(findall(gcf,'-property','FontSize'),'FontSize',  PlotProperties(1).FontSize, 'FontName', 'Arial', 'FontWeight', 'Normal')
end
