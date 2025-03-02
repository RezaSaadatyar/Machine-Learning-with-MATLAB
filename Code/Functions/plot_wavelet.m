%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

function [InputWApprox_Detial, InputWRecons] = plot_wavelet(Data, inputw1, VInput, Vchi, Vchj, level, ...
    typwav, typTHR, typsh, ax3, ax4, cm, CM, cmm)
% This function performs wavelet decomposition on the input signal and plots the raw signal,
% reconstructed signal, and wavelet approximation and detail coefficients.

% Initialize output variables
InputWRecons = 0; InputWApprox_Detial = {};

% Determine the channel labels based on the input selection
if (size(Data, 2) ~= 1) && (VInput == 2)
    y = cell(size(inputw1, 2), 1);
    for i = 1:size(inputw1, 2)
        y{i} = ['Ch ' num2str(i)];
    end
elseif (size(Data, 2) == 1) && (VInput == 2)
    y = '';
elseif VInput == 3
    % Validate the channel range inputs
    if isnan(Vchi)
        msgbox('Please Enter Chi', '', 'warn'); return;
    end
    if Vchi == 0
        msgbox(['0 < Chi < ', num2str(size(Data, 2))], '', 'warn'); return;
    end
    if isnan(Vchj)
        msgbox('Please Enter Chj', '', 'warn'); return;
    end
    if Vchj > size(Data, 2)
        msgbox([num2str(Vchi), '< Chj <', num2str(size(Data, 2) + 1)], '', 'warn'); return;
    end
    y = {};
    for i = Vchi:Vchj
        y = [y; 'Ch', num2str(i)];
    end
else
    y = {['Ch ' num2str(VInput - 3)]};
end

% Initialize cells to store approximation and detail coefficients
ca = cell(size(inputw1, 2), level); cd = ca;

% Initialize the reconstructed signal matrix
InputWRecons = zeros(size(inputw1, 1), size(inputw1, 2));

% Perform wavelet decomposition for each channel
for j = 1:size(inputw1, 2)
    for i = 1:level
        % Decompose the signal into approximation and detail coefficients
        [c, l] = wavedec(inputw1(:, j), i, char(typwav));
        ca{j, i} = appcoef(c, l, char(typwav), i);
    end
    % Extract detail coefficients
    d = detcoef(c, l, 1:level); YY = [];
    for k = 1:size(d, 2)
        if level == 1
            cd(j, k) = {d};
        else
            cd(j, k) = d(k);
        end
    end

    % De-noise the signal using wavelet thresholding
    for i = 1:level
        aa = cd{j, i}; THR = thselect(aa, char(typTHR));
        Y = wthresh(inputw1(:, j), char(typsh), THR); YY = [YY; Y]; %#ok<AGROW>
    end
    % Reconstruct the signal from the approximation and detail coefficients
    InputWRecons(:, j) = waverec([appcoef(c, l, char(typwav), level); YY], l, char(typwav));
end

% Plot the raw and reconstructed signals
kk = 0;
for k = 1:size(inputw1, 2)
    Q(k + kk) = subplot(2, 1, 1, 'Parent', ax4); QL(k + kk) = plot(Q(k + kk), inputw1(:, k)); %#ok<AGROW>
    hold on; title('Raw Signal'); QT(1) = ylabel(Q(k + kk), 'Amp', 'FontName', 'Times New Roman');

    Q(2 * k) = subplot(2, 1, 2, 'Parent', ax4); QL(2 * k) = plot(Q(2 * k), InputWRecons(:, k)); %#ok<AGROW>
    hold on; QT(2) = ylabel(Q(2 * k), 'Amp', 'FontName', 'Times New Roman'); title('Reconstructed Signal'); kk = kk + 1;
end

% Add legend if channel labels are available
if ~isempty(y)
    legend(Q(1), y, 'FontSize', 8); legend(Q(2), y, 'FontSize', 8);
end

% Add labels and context menus to the plots
QXT = xlabel('Sample', 'FontName', 'Times New Roman'); set(QXT, 'uicontextmenu', cmm);
set(Q, 'uicontextmenu', cm); set(QL, 'uicontextmenu', CM); set(QT, 'uicontextmenu', cmm);

% Plot the approximation and detail coefficients
kk = 0;
for k = 1:size(inputw1, 2)
    P(k + kk) = subplot(level + 1, 2, 1, 'Parent', ax3); PL(k + kk) = plot(P(k + kk), inputw1(:, k)); %#ok<AGROW>
    hold on; ylabel(P(k + kk), 'Sig', 'FontName', 'Times New Roman'); title('Signal and Approximations');
    xlim([0 length(inputw1(:, k))]);

    P(2 * k) = subplot(level + 1, 2, 2, 'Parent', ax3); PL(2 * k) = plot(P(2 * k), inputw1(:, k)); %#ok<AGROW>
    hold on; ylabel(P(2 * k), 'Sig', 'FontName', 'Times New Roman'); title('Signal and Details');
    c = 2; kk = kk + 1; xlim([0 length(inputw1(:, k))]);
end

% Add legend if channel labels are available
if (size(inputw1, 2) ~= 1) || (size(Data, 2) ~= 1)
    legend(P(1), y, 'FontSize', 8); legend(P(2), y, 'FontSize', 8);
end

kk = numel(P);
for i = 1:level
    c = c + 1;
    for k = 1:size(inputw1, 2)
        P(k + kk) = subplot(level + 1, 2, c, 'Parent', ax3); PL(k + kk) = plot(P(k + kk), ca{k, i}); hold on;
    end
    xlim([0 length(ca{k, i})]);
    ylabel(P(k + kk), ['a_{' num2str(i) '}']); c = c + 1; kk = numel(P);
    if i == level
        xlabel('Sample');
    end

    for k = 1:size(inputw1, 2)
        P(k + kk) = subplot(level + 1, 2, c, 'Parent', ax3);
        PL(k + kk) = plot(P(k + kk), cd{k, i}); hold on;
    end
    ylabel(P(k + kk), ['d_{ ' num2str(i) '}']); kk = numel(P);
    if i == level
        xlabel('Sample');
    end
    xlim([0 length(cd{k, i})]);
end

% Store the approximation and detail coefficients in the output structure
InputWApprox_Detial.Approximation = ca;
InputWApprox_Detial.Detialn = cd;

% Add legend if channel labels are available
if ~isempty(y)
    legend(P(1), y, 'FontSize', 8); legend(P(2), y, 'FontSize', 8);
end

% Set context menus for the plots
set(P, 'uicontextmenu', cm); set(PL, 'uicontextmenu', CM);
end