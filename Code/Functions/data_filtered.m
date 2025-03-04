%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================= E-mail: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [DataFilter, fss, FVal, Fstr, SW, SS] = data_filtered(Data, Input, fs, fl, fh, rp, rs, order, design, response, ...
    window, input, Chi, Chj, ax1, cm, CM, cmm, display, Fnotch, notch, inputf, list2, inputw, inputCC, ax13)
% This function applies filtering to the input data based on user-selected parameters in the GUI.
% It supports various filter types, including notch filters, and updates the GUI with the filtered data.


% Initialize output variables
DataFilter = 0; X = 0; f = 0; FVal = []; Fstr = ''; SW = []; SS = [];

% Reset GUI elements to their default values
set(inputf, 'value', 1); set(inputw, 'value', 1); set(inputCC, 'value', 1);
set(list2, 'value', 1);
if length(list2.String) > 1
    set(list2, 'string', 'Select:');
end

% Retrieve user inputs from the GUI
dis = get(display, 'value'); fss = str2double(get(fs, 'String')); fll = str2double(get(fl, 'String'));
fhh = str2double(get(fh, 'String')); rpp = str2double(get(rp, 'String')); rss = str2double(get(rs, 'String'));
orderr = str2double(get(order, 'String')); sCBF = get(design, 'String'); ValCBF = get(design, 'Value');
typeCBF = sCBF(ValCBF); sFT = get(response, 'String'); ValFT = get(response, 'Value'); typeFT = sFT(ValFT);
if Data==0;msgbox('Please Load Data in Block Load Data','Error Load Data','error');return;end

if Input == 0
    % Display a warning message if no channel is selected
    msgbox('Please Select Input Channels in Block Load Data', '', 'warn');
    return;
end
% Check if the design method is not selected
if dis == 1
    if ValCBF == 1
        % Display a warning if no design method is selected
        msgbox('Please select design method in Block Filtering:', '', 'warn');
        return;
    end
end

% Clear plots in the GUI axes
subplot(1, 1, 1, 'replace', 'Parent', ax1); subplot(1, 1, 1, 'replace', 'Parent', ax13);

% Apply notch filter if enabled
if get(notch, 'value') == 1
    Fo = str2double(get(Fnotch, 'string')); set(fs, 'enable', 'On');
    % Validate notch frequency
    if isnan(Fo) || (Fo < 0)
        msgbox('Please Enter F0 > 1', '', 'warn'); return;
    end
    % Validate sampling frequency
    if isnan(fss) || (fss <= 0)
        msgbox('Please enter Fs', '', 'warn'); return;
    end
    % Design and apply notch filter
    [num, den] = iirnotch(Fo / (fss / 2), Fo / (fss / 2)); Input = filter(num, den, Input);
    % Compute FFT of the filtered signal
    X = fft2(Input); X = abs(X(1:round(length(Input) / 2), :));
    f = linspace(0, fss / 2, round(length(Input) / 2));
end

% Handle filter design method selection
if ValCBF == 2
    % Disable irrelevant GUI elements for moving average filter
    set(response, 'enable', 'Off', 'value', 1); set(window, 'Enable', 'on'); set(fl, 'enable', 'Off');
    set(fh, 'enable', 'Off'); set(rp, 'enable', 'Off'); set(rs, 'enable', 'Off'); set(order, 'enable', 'Off');
    set(fs, 'enable', 'Off'); set(display, 'Enable', 'off')
    if get(notch, 'value') == 1
        set(fs, 'enable', 'On');
    end
    typeFT = '';
else
    % Enable relevant GUI elements for other filter types
    set(response, 'enable', 'On'); set(window, 'Enable', 'off'); set(fl, 'enable', 'On'); set(fh, 'enable', 'On');
    set(rp, 'enable', 'On'); set(rs, 'enable', 'On'); set(order, 'enable', 'On');
    set(fs, 'enable', 'On'); set(display, 'Enable', 'on')
    if dis == 1
        if ValFT == 1
            % Display a warning if no response type is selected
            msgbox('Please select Response type:', '', 'warn'); return;
        end
    end
end

% Enable/disable frequency range inputs based on filter type
if strcmp(typeFT, 'Lowpass')
    set(fl, 'Enable', 'on'); set(fh, 'Enable', 'off');
elseif strcmp(typeFT, 'Highpass')
    set(fl, 'Enable', 'off'); set(fh, 'Enable', 'on');
elseif strcmp(typeFT, 'Bandpass') || strcmp(typeFT, 'Bandstop')
    set(fl, 'Enable', 'on'); set(fh, 'Enable', 'on');
end

% Apply moving average filter if selected
if ValCBF == 2
    winS = str2double(get(window, 'String'));
    if dis == 1
        if isnan(winS) || winS <= 1
            % Display a warning if window size is invalid
            msgbox('Please Enter Window size > 1', '', 'warn'); return;
        end
    end
    % Design and apply moving average filter
    b = (1 / winS) * ones(1, winS); a = 1; DataFilter = filtfilt(b, a, Input);
elseif ValCBF == 3
    % Disable ripple parameters for Butterworth filter
    set(rp, 'Enable', 'off'); set(rs, 'Enable', 'off');
elseif strcmp(typeCBF, 'Cheby1')
    % Enable passband ripple for Chebyshev Type I filter
    set(rp, 'Enable', 'on'); set(rs, 'Enable', 'off');
elseif strcmp(typeCBF, 'Cheby2')
    % Enable stopband ripple for Chebyshev Type II filter
    set(rp, 'Enable', 'on'); set(rs, 'Enable', 'off');
elseif strcmp(typeCBF, 'Ellip')
    % Enable both passband and stopband ripple for Elliptic filter
    set(rp, 'Enable', 'on'); set(rs, 'Enable', 'on');
end

% Apply the selected filter if not a moving average filter
if dis == 1
    if ValCBF ~= 2
        DataFilter = filter_type(Input, typeFT, typeCBF, fss, orderr, fll, fhh, rpp, rss, display);
    end
end

% Retrieve input selection details
SInput = get(input, 'String'); VInput = get(input, 'value'); VSInput = SInput(VInput);
Vchi = str2double(get(Chi, 'string')); Vchj = str2double(get(Chj, 'string'));

% Plot the filtered data if it is non-zero
if find(DataFilter) ~= 0
    plot_filter(Data, Input, DataFilter, VSInput, VInput, SInput, Vchi, Vchj, X, f, ax1, ax13, cm, CM, cmm);
end
end