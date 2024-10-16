This project contains code and a folder structure for processing and analyzing cyclical gait data. 

Run this command in MATLAB to clone the code and folder structure.

restoredefaultpath

!git clone https://github.com/philippemalcolm/GaitCodeTemplate

cd GaitCodeTemplate
  
 
Use the root folder for running scripts.

Always keep the following folders:

archive: Use this to store files that you might still need. 

DATA: Original data files organized in folders with names such as S01, S02.

PROCESSED: Processed matfiles with data. Use filenames that explain what the dimensions of the variables are. E.g. PcntSubCond means stridenormalized data with percent stride in the first dimension, subjects in the second, and conditions in the third.

FUNCTIONS: Matlab functions from shared GitHub repository. Try to make functions that work for all datasets.

CONFIG: Use this to store structures that contain lists of properties for thinks like line plots. Using this with a properties struct drastically shortens code.

FIGS: Save figures to this folder.

pipelines: visual3d pipelines

doc: Documentation

testdata: small test datasets for verifying if code works. 

Scripts should contain the settings for processing your data. In contrast to the functions, scripts are always somewhat custom, depending on your project. Modify these as needed. There is no need to make your script function for every data. 
Number your scripts with letters (e.g. A1, B1, B2, etc...) according to the sequence they must be run. 
Always keep one "MASTER" script that shows how all the individual scripts should be run for your project. 

Requirements: most functions require the following toolboxes
Deep Learning Toolbox
Global Optimization Toolbox
Optimization Toolbox
Signal Processing Toolbox
Statistics and Machine Learning Toolbox

Documentation video
https://unomail-my.sharepoint.com/:v:/g/personal/pmalcolm_unomaha_edu/EQaeit8S0ENOki0cuPlW-gsBMiELnyGlNG3NZXASdIXr9g?e=DIcHp8
