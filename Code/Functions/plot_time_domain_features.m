%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to plot time-domain features extracted from the input signal
function plot_time_domain_features(Data, Input, FVal, SW, SS, Valist, VSInput, VInput, SInput, typlist, ...
    Vchi, Vchj, ax2, cm, CM, cmm)
    % Inputs:
    %   Data: Input data matrix (samples x channels).
    %   Input: Filtered input data matrix (samples x channels).
    %   FVal: Cell array containing extracted feature data for each feature type.
    %   SW: Window sizes for feature extraction.
    %   SS: Sliding window sizes for feature extraction.
    %   Valist: Index of the selected feature type.
    %   VSInput: Selected channel or feature labels.
    %   VInput: Input selection type (1: single channel, 2: all channels, 3: range of channels).
    %   SInput: Feature labels.
    %   typlist: List of feature types (e.g., time-domain, frequency-domain).
    %   Vchi: Start index for channel range.
    %   Vchj: End index for channel range.
    %   ax2: Axes handle for plotting.
    %   cm: Context menu for the plot axes.
    %   CM: Context menu for the plot lines.
    %   cmm: Context menu for the plot labels.

    % Step 1: Extract the feature data for the selected feature type
    b = FVal{Valist}; % Feature data for the selected feature type

    % Step 2: Determine the size of the input data
    [~, KK] = size(Data); % Number of channels in the input data
    [~, KKK] = size(Input); % Number of channels in the filtered input data

    % Step 3: Create strings for window size and sliding window size
    SW1 = ['SizeW:', num2str(SW(Valist))]; % Window size string
    SS1 = ['; SlidW:', num2str(SS(Valist))]; % Sliding window size string

    % Step 4: Handle multi-channel data when "All Channels" is selected
    if (KK ~= 1) && (KKK ~= 1) && (VInput == 2)
        % Loop through each channel and plot the feature data
        for i = 1:KK
            p(i) = subplot(1, 1, 1, 'Parent', ax2); % Create subplot in the specified axes
            plotline(i) = plot(p(i), b(:, i)); % Plot the feature data for the current channel
            hold on;
            % Add legend and title for the last channel
            if i == KK
                lg = legend(SInput(4:end)); % Add legend with feature labels
                title(lg, typlist); % Set legend title
                title([SW1, SS1], 'FontName', 'Times New Roman'); % Set plot title
            end
        end

    % Step 5: Handle multi-channel data when a specific channel is selected
    elseif (KK ~= 1) && (KKK == 1) && (VInput ~= 2)
        % Plot the feature data for the selected channel
        p(1) = subplot(1, 1, 1, 'Parent', ax2);
        plotline(1) = plot(p(1), b);
        lg = legend(VSInput); % Add legend with selected channel label
        title(lg, typlist); % Set legend title
        title([SW1, SS1], 'FontName', 'Times New Roman'); % Set plot title

    % Step 6: Handle single-channel data when "All Channels" is selected
    elseif (KK == 1) && (KKK == 1) && (VInput == 2)
        % Plot the feature data for the single channel
        p(1) = subplot(1, 1, 1, 'Parent', ax2);
        plotline(1) = plot(p(1), b);
        legend(typlist); % Add legend with feature type
        title([SW1, SS1], 'FontName', 'Times New Roman'); % Set plot title

    % Step 7: Handle multi-channel data when a range of channels is selected
    elseif VInput == 3
        Ki = Vchi:Vchj; % Range of selected channels
        u = [];
        % Generate channel labels for the selected range
        for i = 1:KKK
            u = [u; 'Ch', num2str(Ki(i))]; %#ok<AGROW>
        end

        % Plot the feature data for each channel in the selected range
        for i = 1:KKK
            p(i) = subplot(1, 1, 1, 'Parent', ax2);
            plotline(i) = plot(p(1), b(:, i)); %#ok<AGROW>
            hold on;
            % Add legend and title for the last channel
            if i == KKK
                lg = legend(u); % Add legend with channel labels
                title(lg, typlist); % Set legend title
                title([SW1, SS1], 'FontName', 'Times New Roman'); % Set plot title
            end
        end
    end

    % Step 8: Add labels to the plot
    YT = ylabel(p(1), 'Amplitude', 'FontName', 'Times New Roman'); % Y-axis label
    YXT = xlabel(p(1), 'Sample', 'FontName', 'Times New Roman'); % X-axis label

    % Step 9: Set context menus for the plots and labels
    set(p, 'uicontextmenu', cm); % Add context menu to the plot axes
    set(plotline, 'uicontextmenu', CM); % Add context menu to the plot lines
    set(YXT, 'uicontextmenu', cmm); % Add context menu to the X-axis label
    set(YT, 'uicontextmenu', cmm); % Add context menu to the Y-axis label
end