%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [InputWApprox_Detial, InputWRecons] = wavelet(Data, nlevel, Nwavelet, softhard, THR, Plotwavelet, ...
    input, Chi, Chj, ax3, ax4, cm, CM, cmm, FVal, inputw, DataFilter, Input, inputCC)
% This function performs wavelet decomposition on the input signal and plots the results.
% It supports multiple input types (raw data, filtered data, or extracted features) and allows customization of wavelet parameters.

% Initialize output variables
InputWRecons = 0; inputw1 = 0; InputWApprox_Detial = {};

% Retrieve user inputs from the GUI
level = get(nlevel, 'value'); dis = get(Plotwavelet, 'Value'); VInput = get(input, 'Value');
Vchi = str2double(get(Chi, 'string')); Vchj = str2double(get(Chj, 'string')); set(inputCC, 'value', 1);
swav = get(Nwavelet, 'String'); Vwav = get(Nwavelet, 'Value'); typwav = swav(Vwav);
sTHR = get(THR, 'String'); VTHR = get(THR, 'Value'); typTHR = sTHR(VTHR); ssh = get(softhard, 'String');
Vsh = get(softhard, 'Value'); typsh = ssh(Vsh); Vinputw = get(inputw, 'value');

% Clear the plots in the GUI axes
subplot(1, 1, 1, 'replace', 'Parent', ax3); subplot(1, 1, 1, 'replace', 'Parent', ax4);

% Prepare the input data for wavelet decomposition
if size(FVal, 2) ~= 0
    u = [];
    for i = 1:size(FVal, 1)
        u = [u cell2mat(FVal(i))]; %#ok<AGROW>
    end
    inputF = u;
else
    inputF = 0;
end

% Select the input data based on the user's choice
if Vinputw == 2
    inputw1 = Input;
    if inputw1 == 0
        msgbox('Please Set Parameters in Block Load Data', 'Warning', 'warn'); return;
    end
elseif Vinputw == 3
    inputw1 = DataFilter;
    if inputw1 == 0
        msgbox('Please Set Parameters in Block Filtering', 'Warning', 'warn'); return;
    end
elseif Vinputw == 4
    inputw1 = inputF;
    if inputw1 == 0
        msgbox('Please Set Parameters in Block Feature Extraction', 'Warning', 'warn'); return;
    end
end

% Perform wavelet decomposition and plot the results if the display flag is enabled
if dis == 1
    if Data == 0
        msgbox('Please Load Data in Block Load Data', 'Error Load Data', 'error'); return;
    end
    if Vinputw == 1
        msgbox('Please Select Input in Block Wavelet', 'Warning', 'warn'); return;
    end
    % Call the plot_wavelet function to perform wavelet decomposition and plot the results
    [InputWApprox_Detial, InputWRecons] = plot_wavelet(Data, inputw1, VInput, Vchi, Vchj, level, typwav, ...
        typTHR, typsh, ax3, ax4, cm, CM, cmm);
end
end