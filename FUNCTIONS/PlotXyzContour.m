function [f, lme] = PlotXyzContour(xSubCond, ySubCond, zSubCond, Equation, PlotProperties, AxisLimits)
%% Handling inputs
if ~exist('PlotProperties', 'var')
    PlotProperties.MarkerSize = 10;
    PlotProperties(1).FontSize = 10;
end
if ~exist('Equation', 'var')
    Equation = 'z ~ x.^2 + x + y.^2 + y + (s)';
end
% load('CONFIG\CondPlotStyles.mat'); PlotProperties = CondPlotStyles;
% load('PROCESSED\SubCond.mat')
% xSubCond = ones(10,1) * [1:5, 1:5, NaN, 0];
% ySubCond = ones(10,1) * [ones(1,5),ones(1,5)*2, NaN, 0];
% zSubCond = AnkleMoment_MEAN.* xSubCond;
% Equation = 'z ~ x.^2.*y + x.*y + 1 +(s)';
% clearvars -except xSubCond ySubCond zSubCond PlotProperties Equation
SubjDim = 1;
nSubs = size(xSubCond,1);
%% Calculating mean and sem
[xMean, yMean, zMean] = deal(mean(xSubCond,1,'omitnan'), mean(ySubCond,1,'omitnan'), mean(zSubCond,1,'omitnan')); 
[xStd, yStd, ~] = deal(std(xSubCond,[],1,'omitnan'), std(ySubCond,[],1,'omitnan'), std(zSubCond,[],1,'omitnan'));  
[xStd, yStd] = deal(xStd/sqrt(nSubs), yStd/sqrt(nSubs));
%% Formatting
ax = gca; % Get current axes
f = gcf;  % Get current figure
% Axis limits
if ~exist('AxisLimits', 'var')
    AxisLimits = [min(xMean(:) - xStd(:),[],'omitnan'), max(xMean(:) + xStd(:),[],'omitnan'), min(yMean(:) - yStd(:),[],'omitnan'), max(yMean(:) + yStd (:),[],'omitnan')];
end

%% Scatter plot
errorbar(xMean, yMean, yStd,'vertical','k','Marker','none','LineStyle','none'); hold on;
errorbar(xMean, yMean, xStd,'horizontal','k','Marker','none','LineStyle','none')
scatter(xMean, yMean, PlotProperties(1).MarkerSize*3, zMean, 'filled'); 
%% Stats
sSubCond = (1:size(zSubCond,1))' * ones(1,size(zSubCond,2));
[x, y, z, s] = deal(xSubCond(:), ySubCond(:), zSubCond(:), sSubCond(:));
[x, y, z, s] = RemoveNans(x, y, z, s);

Table = table(x,y,z,s);
try
[lme,ResultEquation] = FitStepwiseLme(Table, Equation)

%% Contour plot
[Xfit, Yfit] = meshgrid(linspace(AxisLimits(1),AxisLimits(2),100), linspace(AxisLimits(3),AxisLimits(4),100));
[x,y] = deal(Xfit(:),Yfit(:));
Zfit = reshape(eval(ResultEquation).*ones(size(x)), size(Xfit));

if length(unique(Zfit)) > 1
    contour(Xfit,Yfit,Zfit)
else
    Zfit = NaN;
end
colormap('turbo')
clim([min([zMean(~isnan(xMean) & ~isnan(yMean)),Zfit(:)']), max([zMean(~isnan(xMean) & ~isnan(yMean)),Zfit(:)'])]); % 

catch

end;
colorbar

%% Formatting
set(gcf,'color','w')
xlabel(strrep(inputname(1),'_',' '))
ylabel(strrep(inputname(2),'_',' '))
title(strrep(inputname(3),'_',' '))
set(findall(gcf,'-property','FontSize'),'FontSize',  PlotProperties(1).FontSize, 'FontName', 'Arial')
try axis(AxisLimits); catch; end;
