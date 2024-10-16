function PcntStrideSubCond = RemoveOrKeepSpecVars(FolderORfolderAndFileName, VarWwildcards, Mode)
% This function allows you to quickly select and remove variables from the
% matfiles with results. Most functions such as the "AddMetrics.m" function
% and others are designed to calculate all possible variables which results
% in files that are hard to oversee. 
% This function allows to quickly select or remove a list of variabbles within a
% specific file or folder. 
% if FolderORfolderAndFileName is a path to a specific file then the
% variables will only be removed from that matfile. If
% FolderORfolderAndFileName is a folder then all matfiles in the folder
% will be updated. 
% VarsWwildcards can be just a single variable or a string of variables
% with wildcards. 
% mode should be set to "keep" or "remove" 

% Example command line input: 
% RemoveOrKeepSpecVars('processed/', {'Ankle*', 'Hip'}, 'remove') % Removes
% all variables that contain "Ankle" or "Hip" in all matfiles in the
% processed folder. 

% 2023-08-02 pmalcolm@unomaha.edu, mostly chatgpt generated code

    % Check if FileNameAndLocation is a directory
    if isfolder(FolderORfolderAndFileName)
        matFiles = dir(fullfile(FolderORfolderAndFileName, '*.mat')); % get all .mat files in the directory
        for k = 1:length(matFiles)
            PcntStrideSubCond = processFile(fullfile(matFiles(k).folder, matFiles(k).name), VarWwildcards, Mode);
        end
    else
        PcntStrideSubCond = processFile(FolderORfolderAndFileName, VarWwildcards, Mode);
    end
end

% Main processing function that does the removal
function PcntStrideSubCond = processFile(fileName, VarsWwildcards, mode)

    PcntStrideSubCond = load(fileName);

    % Get the fieldnames of the structure
    fields = fieldnames(PcntStrideSubCond);

    % Initialize an empty logical array to track matches
    matches = false(size(fields));

    % Loop over each pattern
    for i = 1:length(VarsWwildcards)
        % Replace wildcard '*' with '.*' for regex
        pattern = strrep(VarsWwildcards{i}, '*', '.*');

        % Check each field against the pattern and update matches
        matches = matches | ~cellfun('isempty', regexp(fields, pattern));
    end

    % If mode is 'keep', keep only matching fields
    % If mode is 'remove', keep only non-matching fields
    if strcmp(mode, 'keep')
        PcntStrideSubCond = rmfield(PcntStrideSubCond, fields(~matches));
    elseif strcmp(mode, 'remove')
        PcntStrideSubCond = rmfield(PcntStrideSubCond, fields(matches));
    end

    save(fileName, '-struct', 'PcntStrideSubCond')
end
