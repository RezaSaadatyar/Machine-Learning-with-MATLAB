%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [str,FF,Data,values] = load_data(Lals,inp,text1,list)
% This function loads data from a file selected by the user and processes it based on the file type.

% Initialize output variables to default values
Data = 0; str = ''; FF = 0; values = 0;

% Open a file selection dialog for the user to choose a file
[F, P] = uigetfile({'*.mat','Data file';'*.txt','Data file';'*.xlsx','Excel file';'*.mdl',...
    'Model file';'*.*','All Files'}, 'File Selection', 'multiselect', 'on');

% Clear the data in the list box
set(list, 'Data', []);

% Check if the user canceled the file selection dialog
if F == 0
    % Display an error message if no file was selected
    msgbox('Please Load Data', 'Error Load Data', 'error');
    % Clear the text field and exit the function
    set(text1, 'string', ''); return;
end

% Set the text field to display the selected file name
set(text1, 'string', F);
% Store the selected file name and path in variables
FF = F; PP = P;
% Extract the file extension from the file name
ind = strfind(F, '.'); str = F(ind+1:end);

% Check if the selected file is an Excel file
if strcmp(str, 'xlsx')
    % Get the list of sheets in the Excel file
    [~, sheet] = xlsfinfo(FF);
    % Create a cell array to store sheet names with a default option
    u = cell(length(sheet) + 1, 1); u{1} = 'Select:';
    % Populate the cell array with sheet names
    for i = 1:length(sheet)
        u(i+1, 1) = sheet(i);
    end
    % Set the list box to display the sheet names
    set(Lals, 'String', u);
    % Update the input selection list with the same sheet names
    u{1} = 'Select:'; set(inp, 'string', u);
    % Load data from the first sheet if there are multiple sheets
    if length(u) > 1
        Data = xlsread(FF, char(u(2)));
    end

% Check if the selected file is a MATLAB .mat file
elseif strcmp(str, 'mat')
    % Load the data from the .mat file
    values = load([PP, FF]);
    % Get the field names from the loaded structure
    fields = fieldnames(values);
    % Create a cell array to store field names with a default option
    u = cell(length(fields) + 1, 1); u{1} = 'Select:';
    % Populate the cell array with field names
    for i = 1:length(fields)
        u(i+1, 1) = fields(i);
    end
    % Convert the structure to a cell array and extract the first field's data
    Val = struct2cell(values); Data = cell2mat(Val(1));
    % Set the list box to display the field names
    set(Lals, 'value', 1, 'String', u);
    % Update the input selection list with the same field names
    u{1} = 'Select:'; set(inp, 'value', 1, 'string', u);

% Check if the selected file is a text file
elseif strcmp(str, 'txt')
    % Load the data from the text file
    values = load([PP, FF]);
    % Store the loaded data in the output variable
    Data = values;
    % Set the list box to display default options for text files
    set(Lals, 'String', {'Select:'; 'Inputs'});
    % Update the input selection list with default options
    set(inp, 'string', {'Select:'; 'Inputs'});
end

% Check the dimensions of the loaded data and transpose if necessary
[handles.a, handles.b] = size(Data);
if (handles.a < handles.b)
    Data = Data';
end

end