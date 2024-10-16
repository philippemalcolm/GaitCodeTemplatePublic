function CopyLatestWoutArchiveOrBackup(src, dest)
% Copies folder from source to destination.
% If the source contains folders that are dated as yyyy-mm-dd, then only
% the most recent subfolder gets copied.
% If the source contains files or folders that contain "archive" or "backup" as
% part of their names then those are ignored.

% Ensure the source exists
if ~exist(src, 'file')
    error('Source does not exist');
end

% Create the destination directory if it doesn't exist
if ~exist(dest, 'dir')
    mkdir(dest);
end

% List the contents of the source directory
contents = dir(src);
%% If the contents are folders with datestrings then copy only the most recent one
try
    % Convert to datetime. Invalid dates will be NaT (Not-a-Time)
    dates = datetime({contents(3:end).name}, 'Format', 'yyyy-MM-dd');
    % Find the latest date
    [~, idx] = max(dates);
    % for
    i = idx +2;
    name = contents(i).name;
    fullPathSrc = fullfile(src, name);

    fullPathDest = fullfile(dest); % fullPathDest = fullfile(dest, name);

    % If it's a directory, recursively copy
    if contents(i).isdir
        CopyLatestWoutArchiveOrBackup(fullPathSrc, fullPathDest);
    else
        % If it's a file, simply copy
        copyfile(fullPathSrc, fullPathDest);
    end
catch

    %% If the contents are folders without datestrings then copy everything except archive or backup folders
    for i = 1:length(contents)
        name = contents(i).name;
        fullPathSrc = fullfile(src, name);

        % Skip the '.' and '..' entries
        if strcmp(name, '.') || strcmp(name, '..')
            continue;
        end

        % Check if name contains 'backup' or 'archive' (case insensitive)
        if ~contains(lower(name), 'backup') && ~contains(lower(name), 'archive')
            fullPathDest = fullfile(dest, name);

            % If it's a directory, recursively copy
            if contents(i).isdir
                CopyLatestWoutArchiveOrBackup(fullPathSrc, fullPathDest);
            else
                % If it's a file, simply copy
                copyfile(fullPathSrc, fullPathDest);
            end
        end
    end

end
end