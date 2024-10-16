function varargout = RemoveNans(varargin)
    % Check for at least one input vector
    if nargin < 1
        error('At least one input vector is required.');
    end

    % Check if the first vector is a row vector
    isRow = isrow(varargin{1});

    % If the first vector is a row vector, transform all vectors into column vectors
    if isRow
        for k = 1:nargin
            varargin{k} = varargin{k}.';
        end
    end

    % Get the length of the first vector
    vecLength = length(varargin{1});

    % Check that all vectors have the same length
    for k = 2:nargin
        if length(varargin{k}) ~= vecLength
            error('All input vectors must have the same length.');
        end
    end

    % Combine all vectors into a matrix
    matrix = [varargin{:}];

    % Create a mask that indicates where there are NaNs in any row
    mask = any(isnan(matrix), 2);

    % Remove rows containing NaNs
    matrix(mask, :) = [];

    % Create logical vector of kept elements
    logicalVec = ~mask;
    if isRow
        logicalVec = logicalVec.';
    end

    % If the original vectors were row vectors, transpose the output vectors
    if isRow
        matrix = matrix.';
    end

    % Split the matrix back into separate output vectors
    for k = 1:nargin
        if isRow
            varargout{k} = matrix(k, :);  % Fetch output vectors from rows
        else
            varargout{k} = matrix(:, k);  % Fetch output vectors from columns
        end
    end

    % Set the last output to be the logical vector
    if nargout > nargin
        varargout{nargout} = logicalVec;
    end
end