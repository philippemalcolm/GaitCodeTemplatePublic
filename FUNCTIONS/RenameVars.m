function PcntStrideSubCond = RenameVars(FolderORfolderAndFileName, OrigNames, NewNames)
% Need documentation
% Example command line input:
% 2023-08-02 pmalcolm@unomaha.edu

% Check if FileNameAndLocation is a directory
if isfolder(FolderORfolderAndFileName)
    matFiles = dir(fullfile(FolderORfolderAndFileName, '*.mat')); % get all .mat files in the directory
    for k = 1:length(matFiles)
        PcntStrideSubCond = processFile(fullfile(matFiles(k).folder, matFiles(k).name), OrigNames, NewNames);
    end
else
    PcntStrideSubCond = processFile(FolderORfolderAndFileName, OrigNames, NewNames);
end
end

% Main processing function that does the removal
function PcntStrideSubCond = processFile(fileName, OrigNames, NewNames)

PcntStrideSubCond = load(fileName);

% Get the fieldnames of the structure
fields = fieldnames(PcntStrideSubCond);

% Loop over each pattern
for i = 1:length(OrigNames)
    for n = 1:length(fields)
        if strcmp(fields{n},OrigNames{i})
            PcntStrideSubCond.(NewNames{i}) = PcntStrideSubCond.(OrigNames{i});
            PcntStrideSubCond = rmfield(PcntStrideSubCond, OrigNames{i});
        end
    end
end

save(fileName, '-struct', 'PcntStrideSubCond')
end
