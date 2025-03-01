%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2019-2020 ============================================

function [Inputch, DataFilter] = select_input_03(Data, input, inp, str, values, list, radio, FF)
% This function processes the selected input data based on the file type and user selections.
% It performs normalization and updates the GUI with the processed data.

% Initialize output variables
Inputch = 0; DataFilter = 0;

% Check if data is loaded
if Data == 0
    % Display an error message if no data is loaded
    msgbox('Please Load Data in Block Load Data', 'Error Load Data', 'error');
    return;
end

% Check if the user has selected an input in the GUI
if get(inp, 'value') == 1
    % Display a warning message if no input is selected
    msgbox('Please Select Input in Block Load Data', '', 'warn');
    % Clear the list box and exit the function
    set(list, 'Data', []); return;
end

% Get the selected input type and value from the GUI
Sinp = get(inp, 'String'); Vinp = get(inp, 'Value'); typinp = Sinp(Vinp);

% Load data based on the file type
if strcmp(str, 'xlsx')
    % If the file is an Excel file, read the selected sheet
    Data = xlsread(FF, char(typinp));
elseif strcmp(str, 'mat')
    % If the file is a MATLAB file, extract the selected field from the structure
    Val = struct2cell(values); Data = cell2mat(Val(Vinp - 1));
elseif strcmp(str, 'txt')
    % If the file is a text file, use the loaded data directly
    Data = values;
end

% Transpose the data if the number of rows is less than the number of columns
[handles.a, handles.b] = size(Data);
if (handles.a < handles.b)
    Data = Data';
end

% Convert data to double precision if it is in single precision
[handles.a, handles.b] = size(Data);
if isa(Data, 'single')
    Data = double(Data);
end

% Display the data in the list box, limiting to the first 100,000,000 rows if necessary
if length(Data) > 100000000
    set(list, 'Data', Data(1:100000000, :), 'ForegroundColor', 'r');
else
    set(list, 'Data', Data, 'ForegroundColor', 'r');
end

% Prepare the list of channel names for the input selection dropdown
Cell = cell(handles.b + 3, 1); list.ColumnWidth = 'auto';
Cell(1:3) = {'Select:'; 'All Ch'; 'Multi Ch'};

% Update the input selection dropdown based on the number of channels
if handles.b == 1
    % If there is only one channel, set the dropdown options
    set(input, 'value', 1); set(input, 'string', {'Select:'; 'Ch1'});
else
    % If there are multiple channels, create options for each channel
    for i = 4:handles.b + 3
        Cell{i} = ['Ch', num2str(i - 3)];
    end
    set(input, 'value', 1); set(input, 'string', Cell);
end

% Check if normalization is enabled
Vradi = get(radio, 'value');
if Vradi == 1
    % Normalize the data (mean = 0, standard deviation = 1)
    mu = mean(Data, 1); mu1 = repmat(mu, size(Data, 1), 1); sd = std(Data, 0, 1);
    Data = (Data - mu1) ./ repmat(sd, size(Data, 1), 1);

    % Update the list box with the normalized data
    if length(Data) > 100000000
        set(list, 'Data', Data(1:100000000, :), 'ForegroundColor', 'r');
    else
        set(list, 'Data', Data, 'ForegroundColor', 'r');
    end
end

% Adjust the column width of the list box if there is only one column
if size(Data, 2) < 2
    list.ColumnWidth = {161};
end

% Assign the processed data to the output variable
Inputch = Data;

% (Commented out) Alternative normalization method
% if Vradi == 1
%     mu = max(Data, [], 1); sd = min(Data, [], 1); mami = mu - sd;
%     mu1 = repmat(mami, size(Data, 1), 1); mi = repmat(sd, size(Data, 1), 1);
%     Data = (Data - mi) ./ mu1;
% end
% set(list, 'string', num2str(Data))
end