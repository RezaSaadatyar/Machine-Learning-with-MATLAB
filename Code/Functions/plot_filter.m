%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function plot_filter(Data, Input, DataFilter, VSInput, VInput, SInput, Vchi, Vchj, X, f, ax1, ax13, cm, CM, cmm)
% This function plots the raw and filtered signals, as well as the frequency spectrum of the filtered signal.
% It handles different input configurations and updates the GUI with the plots.

% Determine the size of the input data
[~, KK] = size(Data); [~, KKK] = size(Input); j = 0;

% Check if no input channel is selected
if VInput == 1
    % Display a warning message if no input channel is selected
    msgbox('Please Select Input Channels in Block Load Data', '', 'warn');
    return;
end

% Check if the filtered data is non-empty
if length(DataFilter) > 1
    % Handle multi-channel data when "All Channels" is selected
    if (KK ~= 1) && (KKK ~= 1) && (VInput == 2)
        for i = 1:KK
            % Plot raw signal in the top subplot
            p(j + i) = subplot(2, 1, 1, 'Parent', ax1);
            plotline(j + i) = plot(p(j + i), Input(:, i)); %#ok<AGROW>
            p(j + i).XTick = []; hold on;
            YT = ylabel(p(j + i), 'Amplitude', 'FontName', 'Times New Roman'); 
            % Add legend for the last channel
            if i == KK
                lg = legend(SInput(4:end)); title(lg, 'Raw Signal');
            end

            % Plot filtered signal in the bottom subplot
            p(2 * i) = subplot(2, 1, 2, 'Parent', ax1);
            plotline(2 * i) = plot(p(2 * i), DataFilter(:, i)); %#ok<AGROW>
            hold on;
            XT = ylabel(p(2 * i), 'Amplitude', 'FontName', 'Times New Roman');
            % Add legend for the last channel
            if i == KK
                lg = legend(SInput(4:end)); title(lg, 'Filtered Signal');
            end
            j = j + 1;
            YXT = xlabel(p(2 * i), 'Sample', 'FontName', 'Times New Roman'); 
        end

    % Handle single-channel data when "All Channels" is selected
    elseif (KK == 1) && (KKK == 1) && (VInput == 2)
        % Plot raw signal in the top subplot
        p(1) = subplot(2, 1, 1, 'Parent', ax1);
        plotline(1) = plot(p(1), Input);
        YT = ylabel(p(1), 'Amplitude', 'FontName', 'Times New Roman'); p(1).XTick = [];
        legend('Raw Signal');

        % Plot filtered signal in the bottom subplot
        p(2) = subplot(2, 1, 2, 'Parent', ax1);
        plotline(2) = plot(p(2), DataFilter);
        XT = ylabel(p(2), 'Amplitude', 'FontName', 'Times New Roman');
        YXT = xlabel(p(2), 'Sample', 'FontName', 'Times New Roman'); legend('Filtered Signal');

    % Handle multi-channel data when a specific channel is selected
    elseif (KK ~= 1) && (KKK == 1) && (VInput ~= 2)
        % Plot raw signal in the top subplot
        p(1) = subplot(2, 1, 1, 'Parent', ax1);
        plotline(1) = plot(p(1), Input);
        p(1).XTick = [];
        lg = legend(VSInput); title(lg, 'Filter Signal');
        YT = ylabel(p(1), 'Amplitude', 'FontName', 'Times New Roman');

        % Plot filtered signal in the bottom subplot
        p(2) = subplot(2, 1, 2, 'Parent', ax1);
        plotline(2) = plot(p(2), DataFilter);
        lg = legend(VSInput); title(lg, 'Filter Signal');
        XT = ylabel(p(2), 'Amplitude', 'FontName', 'Times New Roman');
        YXT = xlabel(p(2), 'Sample', 'FontName', 'Times New Roman');

    % Handle multi-channel data when a range of channels is selected
    elseif VInput == 3
        Ki = Vchi:Vchj; u = [];
        % Generate channel labels for the selected range
        for i = 1:KKK
            u = [u; 'Ch', num2str(Ki(i))]; %#ok<AGROW>
        end

        % Plot raw and filtered signals for each channel in the selected range
        for i = 1:KKK
            % Plot raw signal in the top subplot
            p(i + j) = subplot(2, 1, 1, 'Parent', ax1);
            plotline(j + i) = plot(p(i + j), Input(:, i)); %#ok<AGROW>
            YT = ylabel(p(i + j), 'Amplitude', 'FontName', 'Times New Roman'); p(i + j).XTick = []; hold on;
            % Add legend for the last channel
            if i == KKK
                lg = legend(u); title(lg, 'Raw Signal');
            end

            % Plot filtered signal in the bottom subplot
            p(2 * i) = subplot(2, 1, 2, 'Parent', ax1);
            plotline(2 * i) = plot(p(2 * i), DataFilter(:, i)); %#ok<AGROW>
            XT = ylabel(p(2 * i), 'Amplitude', 'FontName', 'Times New Roman');
            YXT = xlabel(p(2 * i), 'Sample', 'FontName', 'Times New Roman'); hold on;
            % Add legend for the last channel
            if i == KKK
                lg = legend(u); title(lg, 'Filtered Signal');
            end
            j = j + 1;
        end
    end

    % Plot the frequency spectrum of the filtered signal
    TT = subplot(1, 1, 1, 'Parent', ax13);
    plot(f, X); xlabel('F(Hz)', 'FontName', 'Times New Roman');
    ylabel('Power', 'FontName', 'Times New Roman');
    % Set context menus for the plots and labels
    set(TT, 'uicontextmenu', cm);
    set(plotline, 'uicontextmenu', CM);
    set(YXT, 'uicontextmenu', cmm);
    set(YT, 'uicontextmenu', cmm);
    set(XT, 'uicontextmenu', cmm);
    set(p, 'uicontextmenu', cm);
end
end