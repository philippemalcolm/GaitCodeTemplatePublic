% This script initializes the code and folder structure. If the folder
% structure does not yet exist then the script will initialize the entire
% github repository for processing gait data by cloning it. If the folder
% structure already exists then the script will limit to only downloading
% the most recent FUNCTIONS subfolder from github. After cloning or downloading the
% script will remove the scripts from the files that are tracked by git.
% The scripts are project-dependent so they should not be updated on github
% unless some major update happens.

%% Settings
AccountName = 'philippemalcolm';
RepositoryName = 'GaitCodeTemplate';
% ZIP_FILE_NAME = 'GaitCodeTemplate.zip';
REPO_ZIP_URL = ['https://github.com/',AccountName,'/',RepositoryName,'/archive/refs/heads/main.zip'];
AccesToken = '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';
DEST_SUBFOLDER = 'FUNCTIONS';

%% Main Execution
if isfolder(DEST_SUBFOLDER)
    disp('Project folder already exists. Updating only the FUNCTIONS folder')
    updateFunctionFolder(REPO_ZIP_URL, AccesToken, [RepositoryName,'.zip'], DEST_SUBFOLDER);
else
    disp('Project does not exist yet. Cloning entire folder structure')
    initializeFolderStructure(AccountName,RepositoryName);
end
untrackScripts();

%% SUBFUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Download and update the function folder with the most recent version from GitHub.
function updateFunctionFolder(repoZipUrl, pat, zipFileName, destSubfolder)
options = weboptions('HeaderFields', {'Authorization', ['token ' pat]}, 'Timeout', 30);
zipFilePath = websave(zipFileName, repoZipUrl, options);
unzip(zipFilePath)
movefile(fullfile(strrep(zipFilePath, '.zip', '-main'), destSubfolder, '*'), destSubfolder);
delete(zipFilePath); rmdir(strrep(zipFilePath, '.zip', '-main'), 's')
end

%% Clone the GitHub repository to initialize the folder structure.
function initializeFolderStructure(AccountName,RepositoryName)
system(['git clone https://github.com/',AccountName,'/',RepositoryName]);
cd(RepositoryName)
end

%% Remove the scripts in the root folder from the tracked files. Only updates tto the function folder need to be tracked
function untrackScripts()
files = dir('*.m');
for i = 1:length(files)
    filename = files(i).name;
    system(['git rm --cached ' filename]);
end
system(['git rm --cached -r ' 'DATA/*']);
system(['git rm --cached -r ' 'PROCESSED/*']);
system(['git rm --cached -r ' 'FIGS/*']);
system(['git rm --cached -r ' 'CONFIG/*']);
system(['git rm --cached -r ' 'archive/*']);
end
