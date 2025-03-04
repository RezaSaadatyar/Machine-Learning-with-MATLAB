%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================= E-mail: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function plot_feature_extraction(Data, Inputf, Lwin, SlidWSize, Inpuf, VSInput, VInput, SInput, typTDom, Vchi, Vchj, ax, cm, CM, cmm)
% This function plots the extracted features from the input signal based on the selected feature type.
% It supports different input configurations and updates the GUI with the plots.

% Determine the size of the input data
[~, KK] = size(Data); [~, KKK] = size(Inputf);

% Create strings for window size and sliding window size
SW = ['SizeW:', num2str(Lwin)]; SS = ['; SlidW:', num2str(SlidWSize)];

% Check if the feature data is non-empty
if ~isempty(Inpuf)
    % Handle multi-channel data when "All Channels" is selected
    if (KK ~= 1) && (KKK ~= 1) && (VInput == 2)
        for i = 1:KK
            % Plot the feature data for each channel
            p(i) = subplot(1, 1, 1, 'Parent', ax);
            plotline(i) = plot(p(i), Inpuf(:, i)); %#ok<AGROW>
            hold on;
            % Add legend and title for the last channel
            if i == KK
                lg = legend(SInput(4:end)); title(lg, typTDom);
                title([SW, SS], 'FontName', 'Times New Roman');
            end
        end

    % Handle single-channel data when "All Channels" is selected
    elseif (KK == 1) && (KKK == 1) && (VInput == 2)
        % Plot the feature data for the single channel
        p(1) = subplot(1, 1, 1, 'Parent', ax);
        plotline(1) = plot(p(1), Inpuf);
        legend(typTDom); title([SW, SS], 'FontName', 'Times New Roman');

    % Handle multi-channel data when a specific channel is selected
    elseif (KK ~= 1) && (KKK == 1) && (VInput ~= 2)
        % Plot the feature data for the selected channel
        p(1) = subplot(1, 1, 1, 'Parent', ax);
        plotline(1) = plot(p(1), Inpuf);
        lg = legend(VSInput); title(lg, typTDom);
        title([SW, SS], 'FontName', 'Times New Roman');

    % Handle multi-channel data when a range of channels is selected
    elseif VInput == 3
        Ki = Vchi:Vchj; u = [];
        % Generate channel labels for the selected range
        for i = 1:KKK
            u = [u; 'Ch', num2str(Ki(i))]; %#ok<AGROW>
        end

        % Plot the feature data for each channel in the selected range
        for i = 1:KKK
            p(i) = subplot(1, 1, 1, 'Parent', ax);
            plotline(i) = plot(p(1), Inpuf(:, i)); %#ok<AGROW>
            hold on;
            % Add legend and title for the last channel
            if i == KKK
                lg = legend(u); title(lg, typTDom);
                title([SW, SS], 'FontName', 'Times New Roman');
            end
        end
    end

    % Add labels to the plot
    YT = ylabel(p(1), 'Amplitude', 'FontName', 'Times New Roman');
    YXT = xlabel(p(1), 'Sample', 'FontName', 'Times New Roman');

    % Set context menus for the plots and labels
    set(p, 'uicontextmenu', cm);
    set(plotline, 'uicontextmenu', CM);
    set(YXT, 'uicontextmenu', cmm);
    set(YT, 'uicontextmenu', cmm);
end
end