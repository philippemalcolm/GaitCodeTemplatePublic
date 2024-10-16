function f = PlotYvsXscatter(ySubCond, xSubCond, PlotProperties, AxisLimits)
%% Settings
SubjDim = 1;

%% Handling inputs
if ~exist('xSubCond', 'var') || isempty(xSubCond)
    xSubCond = ones(size(ySubCond,1),1) * (1:size(ySubCond,2));
end
if size(xSubCond,2) == 1 && size(ySubCond,2) >1
    xSubCond = xSubCond * ones(1,size(ySubCond,2));
    xSubCond(isnan(ySubCond)) = NaN;
end
if ~exist('PlotProperties', 'var')
    PlotProperties = [];
end
if numel(PlotProperties) < size(ySubCond,2)
    clear PlotProperties
    Colors = lines;
    for d = 1:size(xSubCond,2)
        PlotProperties(1,d).Color = Colors(d,:);
        PlotProperties(1,d).Marker = 'o';
    end
end
if ~isfield(PlotProperties, 'FontSize'); PlotProperties(1).FontSize = 10; end
StyleNames = fieldnames(PlotProperties);
NotApplicableStyles = setdiff(StyleNames, {'DisplayName','Color','LineStyle','LineWidth','Marker','MarkerSize','MarkerFaceColor','MarkerEdgeColor'});
GraphProperties = rmfield(PlotProperties, NotApplicableStyles);

%% Calculating mean and sem
xMean = mean(xSubCond,SubjDim,'omitnan'); % Calculates the mean from all the participants (by taking average across 2nd dimension)
xStd = std(xSubCond,[],SubjDim,'omitnan');  % calculates stdev
yMean = mean(ySubCond,SubjDim,'omitnan');
yStd = std(ySubCond,[],SubjDim,'omitnan');

% Axis limits
if ~exist('AxisLimits', 'var')
    AxisLimits = [min(xMean(:) - xStd(:)-1,[],'omitnan'), max(xMean(:) + xStd(:)+1,[],'omitnan'), min(yMean(:) - yStd(:),[],'omitnan'), max(yMean(:) + yStd (:),[],'omitnan')];
end

%% Plotting
ax = gca; % Get current axes
f = gcf;  % Get current figure

if AxisLimits(3) <= 0 && AxisLimits(4) >0 || AxisLimits(3) < 0 && AxisLimits(4) >= 0
    plot([AxisLimits(1), AxisLimits(2)],[0,0],'k') % Plot horizontal axis
end

% Plot standard error bands
hold on;
errorbar(xMean, yMean, yStd,'vertical','k','Marker','none','LineStyle','none')
errorbar(xMean, yMean, xStd,'horizontal','k','Marker','none','LineStyle','none')

% Plot means
hold on;
p = nan(length(yMean),1);
n = 0;
for k = 1:length(yMean)
    n = n+1;
    p(n) = plot(xMean(k),yMean(k),GraphProperties(k));
end

% Formatting
legend(p) % Plots legend for n last lines
set(gcf,'color','w')
xlabel(strrep(inputname(2),'_',' '))
ylabel(strrep(inputname(1),'_',' '))
if xSubCond == ones(size(ySubCond,1),1) * (1:size(ySubCond,2))
    xticks(ax, xMean);
    try xticklabels(ax,{PlotProperties.DisplayName}); catch; end;
    legend off
end
set(findall(gcf,'-property','FontSize'),'FontSize',  PlotProperties(1).FontSize, 'FontName', 'Arial')
try axis(AxisLimits); catch; end;
end
