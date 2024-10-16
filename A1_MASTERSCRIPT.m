% Master script performing all steps for data importing, organization,
% plotting and statistics.

% Keeping all the steps in this type of masterscript allows others to keep
% track of how data was processed. Make sure to put the individual steps in
% subscripts and functions rather than making this an excessivel long
% script. these script the settings and the sequence in which they will be
% run will be dependent on the project and data and should be customized as
% needed. the functions in the function folder on the other hand should not
% be customized but they should rather be revised and updated such that
% they work with all types of projects and data.
  
% Example command line: A1_MASTERSCRIPT
% 2023-08-01 pmalcolm@unomaha.edu

%% b: Get latest code from github and latest dataversion
B1_CloneFolderStructureAndCode % GET LATEST VERSION OF FOLDER STRUCTURE AND MATLAB CODE
% B2_RunDownloadLatestData % OPTIONAL: Copies files from source repository (e.g. research drive) into DATA folder. Copy function ignores all archive and backup subfolders with outdated files.
% 
%% C: Data Importing
C1_RunMocap2PcntStrideCond % Loads vis3d files and converts to 3d-matrix format: PcntStrideCond.mat
% C2to3_RunHumotechCosmed2PcntStrideSubCond % OPTIONAL: Add additional importing scripts for cosmed, humotech, etc here.

%% D: Exception Handling Scripts
% D1_RunSubjExceptionFixes % CUSTOM: ADD PROJECT-SPECIFIC FIXES HERE. THE PRESENT FILE CONTAINS AN EXAMPLE OF SUCH FIXES. THIS OBVIOUSLY NEEDS TO BE MODIFIED DEPENDING ON YOUR DATA.

%% E: Data Combination
E1_RunCombine2PcntStrideSUBcond % Combines data from individual subjects into 4D file: PcntStrideSubCond.mat

%% F: Trimming and Error Handling
% F1_RunRenameVars % OPTIONAL: Renames variables
% F2_RunRemoveOrKeepSpecVars % OPTIONAL: Reduces the dataset by removing a configurable list of variables specified under the settings in this script (e.g. frontal plane kinmatics, etc.)
% F3_RunRemoveFirstXseconds % OPTIONAL: Trims seconds where the treadmill is speeding up or slowing down. The number of seconds needs to be specified under settings in this script.
% F4to5_RunAllRemoveErrorFuns % OPTIONAL: Remove erroneous data based on certain criteria specified under settings (e.g. 1.5 times IQR)

%% G: Demographics and grouping
G1_RunDemographicXls2Sub % Imports demographics data
% G2_RunConvert2Groups % OPTIONAL: Converts data to 5D file: PcntStrideSubCondGroup.mat (if there is only 1 group data remains 4D)
% G3_RunMergeConditions % OPTIONAL: Merges conditions that were recorded as separate files but actually belong together.

%% H: Metrics Calculation
H1_RunAllCalcTsFuns % Runs functions to calculate additional timeseries (e.g. cumulative time, etc.)
H2to4_RunAllCalcScalarFuns % Runs functions to calculate stridemetrics (e.g. max of each stride, etc.) and saves as 4D file: StrideSubCondGroup.mat

%% I: Data Reorganizing
% I1_RunConvertStrides2Time % OPTIONAL: Converts scalars sorted versus strides to scalars sorted versus time and saves as TimeSubCondGroup.mat (e.g. for comparing evolution vs. time of protocol)
I2_RunConvert2MedianOfNstrides % Calculates the median of all strides and saves as PcntSubCondGroup.mat and the median of all scalars and saves as SubCondGroup.mat (e.g. for plotting normalized stride of each condition)

%% J: Statistics
% J1_RunFitExpProtocol % OPTIONAL: Calculates exponential fit of each condition in the protocol versus protocol time. This can be run with a fixed timeconstant, e.g. 42 for metabolic cost. Or an uncontstrained timeconstant for doing learning fits.

%% K: Plotting
K1_RunPlotYvsXtsExample % Example code that plots all timeseries. Code can be modified to plot specific subjects, conditions groups, as well as for plotting timeseries with respect to each other.
K2_RunPlotYvsXscatterExample % Example code that plots all scalars. Code can be modified to plot specific subjects, conditions groups, as well as for plotting metrics with respect to each other and plotting stats.
% K3_RunPrintFig; % OPTIONAL: Code that converts figures to format that we use for presenting and manuscripts: jpeg and vector.

%% Project specific code
% Place project specific code here
% Z1_RunProjectSpecPlotExample
% Z2_RunProjectSpecPlotExample