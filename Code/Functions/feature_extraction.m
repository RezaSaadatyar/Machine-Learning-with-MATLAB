%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================= E-mail: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [Inpuf, typTDom, Lwin, SlidWSize] = feature_extraction(Data, DataFilter, Input, ax2, ...
    inputf, Novelab, TFDomain, Windw, thr, SlidW, TDomain, FDomain, input, Chi, Chj, cm, CM, cmm, display1, ...
    inputw, inputCC)
% This function performs feature extraction on the input signal based on user-selected parameters.
% It supports both time-domain and frequency-domain features and updates the GUI with the results.

% Initialize variables
Lwin = str2double(get(Novelab, 'String')); Inpuf = nan; SlidWSize = 0; typTDom = ''; Inputf = 0;

% Retrieve the display flag and clear the plot in the GUI
dis = get(display1, 'value'); subplot(1, 1, 1, 'replace', 'Parent', ax2); set(inputw, 'value', 1);

% Retrieve the selected input type and value from the GUI
Sinputf = get(inputf, 'string'); Vinputf = get(inputf, 'value'); SVinputf = Sinputf(Vinputf);

% Retrieve the selected domain (time or frequency) and window type
VFDom = get(TFDomain, 'Value'); swin = get(Windw, 'String'); Vwin = get(Windw, 'Value'); typwin = swin(Vwin);

% Retrieve the threshold value and reset the inputCC value
Vthr = str2double(get(thr, 'String')); set(inputCC, 'value', 1);

% Select the input data for feature extraction
if Vinputf == 2
    Inputf = Input;
elseif Vinputf == 3
    Inputf = DataFilter;
end

% Validate user inputs if the display flag is enabled
if dis == 1
    if Data == 0
        % Display an error message if no data is loaded
        msgbox('Please Load Data in Block Load Data', 'Error Load Data', 'error'); return;
    end
    if Vinputf == 1
        % Display a warning if no input is selected
        msgbox('Please Select Input in Block Feature Extraction', '', 'warn'); return;
    end
    if Inputf == 0
        % Display a warning if the selected input is not loaded
        msgbox(['Please Load ', SVinputf], '', 'warn'); return;
    end
    if Vwin == 1
        % Display a warning if no window type is selected
        msgbox('Please Select Window Type', '', 'warn'); return;
    end
    if isnan(Lwin)
        % Display a warning if the window size is not entered
        msgbox('Please Enter Size Window', '', 'warn'); return;
    end
    if Lwin > length(Inputf)
        % Display a warning if the window size is too large
        msgbox(['Should be selected Size Window <', num2str(length(Inputf))], '', 'warn'); return;
    end
end

% Handle non-overlapping and overlapping window types
if strcmp(typwin, 'Non-Overlapping')
    % Disable the sliding window input for non-overlapping windows
    set(SlidW, 'Enable', 'off'); SlidWSize = 0;
elseif strcmp(typwin, 'Overlapping')
    % Enable the sliding window input for overlapping windows
    set(SlidW, 'Enable', 'on');
    SlidWSize = str2double(get(SlidW, 'String'));
    if dis == 1
        if isnan(SlidWSize)
            % Display a warning if the sliding window size is not entered
            msgbox('Please Enter Sliding Window', '', 'warn'); return;
        end
    end
end

% Handle time-domain and frequency-domain feature selection
if VFDom == 1
    % Set up the GUI for time-domain features
    set(FDomain, 'Visible', 'off', 'value', 1);
    set(TDomain, 'String', {'Mean'; 'Std'; 'Median'; 'ACC'; 'DASDV'; 'MAD'; 'MAV'; 'MMAV'; 'MFL'; 'MYOP'; ...
        'Integrate'; 'RMS'; 'SSI'; 'SSC'; 'ZC'; 'VAR'; 'Skewness'; 'Kurtosis'; 'V-Order2'; ...
        'V-Order3'; 'WAMP'; 'WL'}, 'Visible', 'on');
    sTDom = get(TDomain, 'String'); VTDom = get(TDomain, 'Value'); typTDom = sTDom(VTDom);
elseif VFDom == 2
    % Set up the GUI for frequency-domain features
    set(FDomain, 'Visible', 'on'); set(TDomain, 'Visible', 'off');
    set(TDomain, 'value', 1); set(FDomain, 'string', {'MNP'; 'TTP'; 'MDF'; 'MNF'});
    sTDom = get(FDomain, 'String'); VTDom = get(FDomain, 'Value'); typTDom = sTDom(VTDom);
end

% Enable/disable the threshold input based on the selected feature type
if strcmp(typTDom, 'WAMP') || strcmp(typTDom, 'MYOP') || strcmp(typTDom, 'ZC') || strcmp(typTDom, 'SSC')
    set(thr, 'Enable', 'on');
    if dis == 1
        if isnan(Vthr)
            % Display a warning if the threshold is not entered
            msgbox('Please Enter Threshold', '', 'warn'); return;
        end
    end
else
    set(thr, 'Enable', 'off');
end

% Perform feature extraction based on the selected domain
if (VFDom == 1) && (dis == 1)
    % Extract time-domain features
    Inpuf = time_domain_features(Inputf, typTDom, Lwin, SlidWSize, Vthr);
elseif (VFDom == 2) && (dis == 1)
    % Placeholder for frequency-domain features (not implemented in this function)
    % [handles.a, handles.b] = size(Inputf); In = zeros(handles.a - 1, handles.b);
end

% Retrieve input selection details
SInput = get(input, 'String'); VInput = get(input, 'value');
VSInput = SInput(VInput); Vchi = str2double(get(Chi, 'string')); Vchj = str2double(get(Chj, 'string'));

% Plot the extracted features if the feature data is non-empty
if ~isnan(Inpuf)
    if VInput == 1
        % Display a warning if no input channel is selected
        msgbox('Please Select Input Channels in Block Load Data', '', 'warn'); return;
    end
    % Plot the extracted features
    plot_feature_extraction(Data, Inputf, Lwin, SlidWSize, Inpuf, VSInput, VInput, SInput, typTDom, Vchi, Vchj, ax2, cm, CM, cmm);
end
end