function writetable(T,filename,varargin)
%WRITETABLE Write a table to a file.
%   WRITETABLE(T) writes the table T to a comma-delimited text file. The file name is
%   the workspace name of the table T, appended with '.txt'. If WRITETABLE cannot
%   construct the file name from the table input, it writes to the file 'table.txt'.
%   WRITETABLE overwrites any existing file.
%
%   WRITETABLE(T,FILENAME) writes the table T to the file FILENAME as column-oriented
%   data. WRITETABLE determines the file format from its extension. The extension
%   must be one of those listed below.
%
%   WRITETABLE(T,FILENAME,'FileType',FILETYPE) specifies the file type, where
%   FILETYPE is one of 'text' or 'spreadsheet'.
%
%   WRITETABLE writes data to different file types as follows:
%
%   .txt, .dat, .csv:  Delimited text file (comma-delimited by default).
%
%          WRITETABLE creates a column-oriented text file, i.e., each column of each
%          variable in T is written out as a column in the file. T's variable names
%          are written out as column headings in the first line of the file.
%
%          Use the following optional parameter name/value pairs to control how data
%          are written to a delimited text file:
%
%          'Delimiter'      The delimiter used in the file. Can be any of ' ',
%                           '\t', ',', ';', '|' or their corresponding names 'space',
%                           'tab', 'comma', 'semi', or 'bar'. Default is ','.
%
%          'WriteVariableNames'  A logical value that specifies whether or not
%                           T's variable names are written out as column headings.
%                           Default is true.
%
%          'WriteRowNames'  A logical value that specifies whether or not T's
%                           row names are written out as first column of the file.
%                           Default is false. If the 'WriteVariableNames' and
%                           'WriteRowNames' parameter values are both true, T's first
%                           dimension name is written out as the column heading for
%                           the first column of the file.
%
%          'QuoteStrings'   A logical value that specifies whether to write
%                           text out enclosed in double quotes ("..."). If
%                           'QuoteStrings' is true, any double quote characters that
%                           appear as part of a text variable are replaced by two
%                           double quote characters.
%
%          'DateLocale'     The locale that writetable uses to create month and
%                           day names when writing datetimes to the file. LOCALE must
%                           be a character vector or scalar string in the form xx_YY.
%                           See the documentation for DATETIME for more information.
%
%          'Encoding'       The encoding to use when creating the file.
%                           Default is 'UTF-8'.
%
%          'WriteMode'      Append to an existing file or overwrite an
%                           existing file.
%                             'overwrite' - Overwrite the file, if it
%                                           exists. This is the default option.
%                             'append'    - Append to the bottom of the file,
%                                           if it exists.
%
%   .xls, .xlsx, .xlsb, .xlsm, .xltx, .xltm:  Spreadsheet file.
%
%          WRITETABLE creates a column-oriented spreadsheet file, i.e., each column
%          of each variable in T is written out as a column in the file. T's variable
%          names are written out as column headings in the first row of the file.
%
%          Use the following optional parameter name/value pairs to control how data
%          are written to a spreadsheet file:
%
%          'WriteVariableNames'  A logical value that specifies whether or not
%                           T's variable names are written out as column headings.
%                           Default is true.
%
%          'WriteRowNames'  A logical value that specifies whether or not T's row
%                           names are written out as first column of the specified
%                           region of the file. Default is false. If the
%                           'WriteVariableNames' and 'WriteRowNames' parameter values
%                           are both true, T's first dimension name is written out as
%                           the column heading for the first column.
%
%          'DateLocale'     The locale that writetable uses to create month and day
%                           names when writing datetimes to the file. LOCALE must be
%                           a character vector or scalar string in the form xx_YY.
%                           Note: The 'DateLocale' parameter value is ignored
%                           whenever dates can be written as Excel-formatted dates.
%
%          'Sheet'          The sheet to write, specified the worksheet name, or a
%                           positive integer indicating the worksheet index.
%
%          'Range'          A character vector or scalar string that specifies a
%                           rectangular portion of the worksheet to write, using the
%                           Excel A1 reference style.
%
%          'UseExcel'      A logical value that specifies whether or not to create the
%                          spreadsheet file using Microsoft(R) Excel(R) for Windows(R). Set
%                          'UseExcel' to one of these values:
%                               false -  Does not open an instance of Microsoft Excel
%                                        to write the file. This is the default setting.
%                                        This setting may cause the data to be
%                                        written differently for files with
%                                        live updates (e.g. formula evaluation or plugins).
%                               true  -  Opens an instance of Microsoft Excel to write
%                                        the file on a Windows system with Excel installed.
%
%          'WriteMode'     Perform an in-place write, append to an existing
%                          file or sheet, overwrite an existing file or
%                          sheet.
%                             'inplace'         - In-place replacement of
%                                                 the data in the sheet.
%                                                 This is the default
%                                                 option.
%                             'overwritesheet'  - If sheet exists,
%                                                 overwrite contents of sheet.
%                             'replacefile'     - Create a new file. Prior
%                                                 contents of the file and
%                                                 all the sheets are removed.
%                             'append'          - Append to the bottom of
%                                                 the occupied range within
%                                                 the sheet.
%
%   In some cases, WRITETABLE creates a file that does not represent T exactly, as
%   described below. If you use READTABLE(FILENAME) to read that file back in and create
%   a new table, the result may not have exactly the same format or contents as the
%   original table.
%
%   *  WRITETABLE writes out numeric variables using long g format, and
%      categorical or character variables as unquoted text.
%   *  For non-character variables that have more than one column, WRITETABLE
%      writes out multiple delimiter-separated fields on each line, and constructs
%      suitable column headings for the first line of the file.
%   *  WRITETABLE writes out variables that have more than two dimensions as two
%      dimensional variables, with trailing dimensions collapsed.
%   *  For cell-valued variables, WRITETABLE writes out the contents of each cell
%      as a single row, in multiple delimiter-separated fields, when the contents are
%      numeric, logical, character, or categorical, and writes out a single empty
%      field otherwise.
%
%   Save T as a mat file if you need to import it again as a table.
%
%   See also TABLE, READTABLE, WRITETIMETABLE, WRITEMATRIX, WRITECELL.

%   Copyright 2012-2019 The MathWorks, Inc.

import matlab.io.internal.utility.suggestWriteFunctionCorrection
import matlab.io.internal.validators.validateWriteFunctionArgumentOrder
import matlab.virtualfileio.internal.validators.validateCloudEnvVariables;
import matlab.internal.datatypes.validateLogical

if nargin == 0
    error(message("MATLAB:minrhs"));
elseif nargin == 1
    tablename = inputname(1);
    if isempty(tablename)
        tablename = 'table';
    end
    filename = [tablename '.txt'];
end

validateWriteFunctionArgumentOrder(T, filename, "writetable", "table", @istable);
[T, filename, varargin{:}] = convertStringsToChars(T,filename,varargin{:});

if ~istable(T)
    suggestWriteFunctionCorrection(T, "writetable");
end

if isempty(filename)
    error(message('MATLAB:virtualfileio:path:cellWithEmptyStr','FILENAME'));
end

% second input is not really optional with NV-pairs.
if nargin > 2 && mod(nargin,2) > 0
    error(message('MATLAB:table:write:NoFileNameWithParams'));
end


try
    if nargin < 2 || isempty(filename)
        type = 'text';
        tablename = inputname(1);
        if isempty(tablename)
            tablename = class(T);
        end
        filename = [tablename '.txt'];
        suppliedArgs = {'WriteVariableNames',true,'WriteRowNames',false};
    else
        pnames = {'FileType'};
        dflts =  {   [] };
        [type,supplied,suppliedArgs] = matlab.internal.datatypes.parseArgs(pnames, dflts, varargin{:});
        [~,name,ext] = fileparts(filename);

        if isempty(name)
            error(message('MATLAB:table:write:NoFilename'));
        end

        if ~supplied.FileType
            if isempty(ext)
                ext = '.txt';
                filename = [filename ext];
            end
            switch lower(ext)
                case {'.txt' '.dat' '.csv'}, type = 'text';
                case {'.xls' '.xlsx' '.xlsb' '.xlsm' '.xltx' '.xltm'}, type = 'spreadsheet';
                otherwise
                    error(message('MATLAB:table:write:UnrecognizedFileExtension',ext));
            end
        elseif ~ischar(type) && ~(isstring(type) && isscalar(type))
            error(message('MATLAB:textio:textio:InvalidStringProperty','FileType'));
        else
            fileTypes = {'text' 'spreadsheet'};
            itype = find(strncmpi(type,fileTypes,strlength(type)));
            if isempty(itype)
                error(message('MATLAB:table:write:UnrecognizedFileType',type));
            elseif ~isscalar(itype)
                error(message('MATLAB:table:write:AmbiguousFileType',type));
            end
            type = fileTypes{itype};
            % Add default extension if necessary
            if isempty(ext)
                dfltFileExts = {'.txt' '.xls'};
                ext = dfltFileExts{itype};
                filename = [filename ext];
            end
        end
    end

    % Check WriteMode to determine whether the file should be
    % appended or overwritten
    pnames = {'WriteMode','WriteVariableNames','WriteRowNames'};
    if type == "text"
        dflts =  {'overwrite',true,false};
        validModes = ["overwrite","append"];
    else
        dflts = {'inplace',true,false};  % validation of WriteMode values
        validModes = ["inplace","overwritesheet","append","replacefile"];
    end
    [sharedArgs.WriteMode, sharedArgs.WriteVarNames, sharedArgs.WriteRowNames, supplied, remainingArgs]...
        = matlab.internal.datatypes.parseArgs(pnames, dflts, suppliedArgs{:});

    sharedArgs.WriteMode = validatestring(sharedArgs.WriteMode,validModes);
    sharedArgs.WriteRowNames = validateLogical(sharedArgs.WriteRowNames,'WriteRowNames') && ~isempty(T.Properties.RowNames);
    sharedArgs.WriteVarNames = validateLogical(sharedArgs.WriteVarNames,'WriteVariableNames');

    % Setup LocalToRemote object with a remote folder.
    % check if the file exists remotely, we need to download since we
    % will append to file
    try
        if (type == "text" && sharedArgs.WriteMode == "append") || ...
                (type == "spreadsheet" && ...
                any(sharedArgs.WriteMode == ["inplace", "append", "overwritesheet"]))
            remote2Local = matlab.virtualfileio.internal.stream.RemoteToLocal(filename);
            tempFile = remote2Local.LocalFileName;
        else
            remote2Local = [];
            tempFile = filename;
        end
    catch ME
        if contains(ME.identifier,'EnvVariablesNotSet')
            throwAsCaller(ME);
        end
        remote2Local = [];
        tempFile = filename;
    end

    validURL = matlab.virtualfileio.internal.validators.isIRI(filename);
    if validURL
        filenameWithoutPath = matlab.virtualfileio.internal.validators.IRIFilename(filename);
        remoteFolder = extractBefore(filename,filenameWithoutPath);
        ext = strfind(filenameWithoutPath,".");
        if ~isempty(ext)
            index = ext(end)-1;
            ext = extractAfter(filenameWithoutPath,index);
            filenameWithoutPath = extractBefore(filenameWithoutPath,index+1);
        end
        % check whether credentials are set
        
        validateCloudEnvVariables(filename);
        % remote write
        ltr = matlab.virtualfileio.internal.stream.LocalToRemote(remoteFolder);
        if ~isempty(remote2Local) && any(type == ["spreadsheet","text"])
            % file exists in remote location, append to file
            ltr.CurrentLocalFilePath = tempFile;
            ltr.setRemoteFileName(filenameWithoutPath, ext);
        else
            % file does not exist in remote location
            setfilename(ltr,filenameWithoutPath,ext);
        end
        fname = ltr.CurrentLocalFilePath;
        validateRemotePath(ltr);
    elseif matlab.virtualfileio.internal.validators.hasIriPrefix(filename) && ~validURL
        % possibly something wrong with the URL such as a malformed Azure
        % URL missing the container@account part
        error(message("MATLAB:virtualfileio:stream:invalidFilename", filename));
    else
        [path, ~, ext] = fileparts(filename);
        if isempty(path)
            % If no path is passed in, we should assume the current
            % directory is the one we're using. Later on, some more general
            % code will look for the existing file, but it does path lookup
            % to match the file name. It's doubtful that's the user's
            % intent.
            fname = fullfile(pwd,filename);
        else
            % In the case of a full/partial path, no path lookup will
            % happen.
            fname = filename;
        end
    end

    sharedArgs.SuppliedWriteVarNames = supplied.WriteVariableNames;
    switch lower(type)
        case "text"
            matlab.io.internal.writing.writeTextFile(T,fname,sharedArgs,remainingArgs);
        case "spreadsheet"
            matlab.io.internal.writing.writeXLSFile(T,fname,ext(2:end),sharedArgs,remainingArgs);
        otherwise
            error(message('MATLAB:table:write:UnrecognizedFileType',type));
    end

    if validURL
        % upload the file to the remote location
        upload(ltr);
    end
catch ME
    if strcmp(ME.identifier,'MATLAB:fileparts:MustBeChar')
        throwAsCaller(MException(message('MATLAB:virtualfileio:path:cellWithEmptyStr','FILENAME')));
    elseif strcmp(ME.identifier,'MATLAB:virtualfileio:stream:CannotFindLocation')
        throwAsCaller(ME);
    elseif exist('ltr','var')
        error(matlab.virtualfileio.internal.util.convertStreamException(ME, remoteFolder));
    else
        throwAsCaller(ME)
    end
end
