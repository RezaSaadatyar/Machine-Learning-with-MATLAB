%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [Input, FVal, Fstr, SW, SS] = select_channels(Inputch, Chi, Chj, input, inp, display, inputf, ...
    list2, inputw, inputCC)
% This function selects specific channels from the input data based on user selections in the GUI.
% It also performs validation and updates the GUI accordingly.

% Initialize output variables
Input = 0; FVal = []; Fstr = ''; SW = []; SS = [];

% Reset GUI elements to their default values
set(inputf, 'value', 1); set(inputw, 'value', 1); set(inputCC, 'value', 1);
set(list2, 'value', 1);
if length(list2.String) > 1
    set(list2, 'string', 'Select:');
end

% Check if the user has selected an input in the GUI
if get(inp, 'value') == 1
    % Display a warning message if no input is selected
    msgbox('Please Select Input in Block Load Data', '', 'warn');
    return;
end

% Convert input data to double precision if it is in single precision
if isa(Inputch, 'single')
    Inputch = double(Inputch);
end

% Disable channel selection fields initially
set(Chj, 'Enable', 'off'); set(Chi, 'Enable', 'off');

% Get the selected value from the input dropdown
VInput = get(input, 'Value');

% Check if no channel is selected
if VInput == 1
    % Display a warning message if no channel is selected
    msgbox('Please Select Input Channels in Block Load Data', '', 'warn');
    return;
end

% Handle multi-channel selection
if (VInput == 3) && (size(Inputch, 2) > 1)
    % Enable the channel selection fields for multi-channel selection
    set(Chi, 'Enable', 'on'); set(Chj, 'Enable', 'on');

    % Get the values for Chi and Chj from the GUI
    Vchi = str2double(get(Chi, 'string')); Vchj = str2double(get(Chj, 'string'));

    % Validate Chi
    if isnan(Vchi)
        % Display a warning if Chi is not a valid number
        msgbox('Please Enter Chi', '', 'warn'); return;
    end
    if Vchi < 1
        % Display a warning if Chi is out of range
        msgbox(['0 < Chi < ', num2str(size(Inputch, 2) - 1)], '', 'warn'); return;
    end

    % Validate Chj
    if isnan(Vchj) || (Vchj <= Vchi)
        % Display a warning if Chj is not a valid number or is less than or equal to Chi
        msgbox('Please Enter Chj and  Chj > Chi', '', 'warn'); return;
    end
    if Vchj > size(Inputch, 2)
        % Display a warning if Chj is out of range
        msgbox([num2str(Vchi), '< Chj <', num2str(size(Inputch, 2) + 1)], '', 'warn'); return;
    end

    % Select the specified range of channels
    Input = Inputch(:, Vchi:Vchj);

% Handle "All Channels" selection
elseif (VInput == 2)
    % Select all channels
    Input = Inputch;
    % Disable the channel selection fields
    set(Chi, 'Enable', 'off'); set(Chj, 'Enable', 'off');

% Handle single-channel selection
else
    % Select a single channel based on the dropdown value
    Input = Inputch(:, VInput - 3);
    % Disable the channel selection fields
    set(Chi, 'Enable', 'off'); set(Chj, 'Enable', 'off');
end

% Reset the display value in the GUI
set(display, 'Value', 0);
end