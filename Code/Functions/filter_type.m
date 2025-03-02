%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

function DataFilter = filter_type(Input, typeFT, typeCBF, fs, order, fl, fh, rp, rs, display)
% This function designs and applies a digital filter to the input data based on user-selected parameters.
% It supports various filter types (Butterworth, Chebyshev, Elliptic) and response types (Lowpass, Highpass, Bandpass, Bandstop).

% Retrieve the display flag and initialize the output variable
dis = get(display, 'value'); DataFilter = 0;

% Validate user inputs if the display flag is enabled
if dis == 1
    % Validate sampling frequency (fs)
    if isnan(fs) || (fs < 1)
        msgbox('Please Enter Fs and Fs > 0', '', 'warn'); return;
    end
    % Validate filter order
    if isnan(order) || (order < 1)
        msgbox('Please Enter Order and Order > 0', '', 'warn'); return;
    end

    % Validate cutoff frequencies based on the filter type
    if strcmp(typeFT, 'Lowpass')
        % Validate lowpass cutoff frequency (fl)
        if fl / fs / 2 >= 1
            msgbox('Invalid Value Flow; (Fs/Flow /2) must be within the interval of (0,1)', '', 'warn'); return;
        end
        if isnan(fl) || (fl < 2)
            msgbox('Please Enter Flow and Flow > 1', '', 'warn'); return;
        end
    elseif strcmp(typeFT, 'Highpass')
        % Validate highpass cutoff frequency (fh)
        if fh / fs / 2 >= 1
            msgbox('Invalid Value Fhigh; (Fs/Fhigh /2) must be within the interval of (0,1)', '', 'warn'); return;
        end
        if isnan(fh) || (fh < 2)
            msgbox('Please Enter Fhigh and Fhigh > 1', '', 'warn'); return;
        end
    elseif strcmp(typeFT, 'Bandpass') || strcmp(typeFT, 'Bandstop')
        % Validate bandpass/bandstop cutoff frequencies (fl and fh)
        if fl / fs / 2 >= 1
            msgbox('Invalid Value Flow; (Fs/Flow /2) must be within the interval of (0,1)', '', 'warn'); return;
        end
        if fh / fs / 2 >= 1
            msgbox('Invalid Value Fhigh; (Fs/Fhigh /2) must be within the interval of (0,1)', '', 'warn'); return;
        end
        if isnan(fl) || (fl < 2)
            msgbox('Please Enter Flow and Flow > 1', '', 'warn'); return;
        end
        if isnan(fh) || (fh < 2)
            msgbox('Please Enter Fhigh and Fhigh > 1', '', 'warn'); return;
        end
        if fh <= fl
            msgbox('Fhigh must be greater than Flow (Fhigh > Flow)', '', 'warn'); return;
        end
    end

    % Validate ripple parameters for Chebyshev and Elliptic filters
    if strcmp(typeCBF, 'Cheby1') || strcmp(typeCBF, 'Cheby2')
        if isnan(rp) || (rp < 2)
            msgbox('Please Enter Rp and Rp > 1', '', 'warn'); return;
        end
    elseif strcmp(typeCBF, 'Ellip')
        if isnan(rp) || (rp < 2)
            msgbox('Please Enter Rp and Rp > 1', '', 'warn'); return;
        end
        if isnan(rs) || (rs <= 1)
            msgbox('Please Enter Rs and Rs > 1', '', 'warn'); return;
        end
        if rs <= rp
            msgbox('Rs must be greater than Rp (Rs > Rp)', '', 'warn'); return;
        end
    end
end

% Design and apply the filter based on the selected type and response
if strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Butter')
    % Butterworth Lowpass Filter
    [b, a] = butter(order, fl / fs / 2, 'low'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Butter')
    % Butterworth Highpass Filter
    [b, a] = butter(order, fh / fs / 2, 'high'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Butter')
    % Butterworth Bandpass Filter
    [b, a] = butter(order, [fl / fs / 2, fh / fs / 2], 'bandpass'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Butter')
    % Butterworth Bandstop Filter
    [b, a] = butter(order, [fl / fs / 2, fh / fs / 2], 'stop'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I Lowpass Filter
    [b, a] = cheby1(order, rp, fl / fs / 2, 'low'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I Highpass Filter
    [b, a] = cheby1(order, rp, fh / fs / 2, 'high'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I Bandpass Filter
    [b, a] = cheby1(order, rp, [fl / fs / 2, fh / fs / 2], 'bandpass'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Cheby1')
    % Chebyshev Type I Bandstop Filter
    [b, a] = cheby1(order, rp, [fl / fs / 2, fh / fs / 2], 'stop'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II Lowpass Filter
    [b, a] = cheby2(order, rp, fl / fs / 2, 'low'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II Highpass Filter
    [b, a] = cheby2(order, rp, fh / fs / 2, 'high'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II Bandpass Filter
    [b, a] = cheby2(order, rp, [fl / fs / 2, fh / fs / 2], 'bandpass'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Cheby2')
    % Chebyshev Type II Bandstop Filter
    [b, a] = cheby2(order, rp, [fl / fs / 2, fh / fs / 2], 'stop'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Lowpass') && strcmp(typeCBF, 'Ellip')
    % Elliptic Lowpass Filter
    [b, a] = ellip(order, rp, rs, fl / fs / 2, 'low'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Highpass') && strcmp(typeCBF, 'Ellip')
    % Elliptic Highpass Filter
    [b, a] = ellip(order, rp, rs, fh / fs / 2, 'high'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandpass') && strcmp(typeCBF, 'Ellip')
    % Elliptic Bandpass Filter
    [b, a] = ellip(order, rp, rs, [fl / fs / 2, fh / fs / 2], 'bandpass'); DataFilter = filtfilt(b, a, Input);
elseif strcmp(typeFT, 'Bandstop') && strcmp(typeCBF, 'Ellip')
    % Elliptic Bandstop Filter
    [b, a] = ellip(order, rp, rs, [fl / fs / 2, fh / fs / 2], 'stop'); DataFilter = filtfilt(b, a, Input);
end
end