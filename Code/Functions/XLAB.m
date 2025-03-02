%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to update the x-axis label and ticks based on user selection
function XLAB(Input, fs)
    % Inputs:
    %   Input: Input signal data.
    %   fs: Sampling frequency (optional).

    % Step 1: Get the label of the clicked menu item
    xlb = get(gcbo, 'label'); % Get the label of the clicked menu item

    % Step 2: Get the current axes and set the font
    ax = gca; % Get the current axes
    ax.FontName = 'Times New Roman'; % Set the font for the axes

    % Step 3: Adjust the legend font size if a legend exists
    if ~isempty(ax.Legend)
        ax.Legend.FontSize = 8; % Set the legend font size
    end

    % Step 4: Get the current x-axis tick locations
    tt = ax.XTick; % Get the current x-axis tick locations

    % Step 5: Handle the case when the label is 'none'
    if strcmp(xlb, 'none')
        t = 0:length(Input) - 1; % Create a time vector starting from 0
        u = [];
        % Generate tick labels for the x-axis
        for i = 2:length(tt)
            u = [u, t(tt(i)) + 1]; %#ok<AGROW> % Append the tick values
        end
        ax.XTickLabel = [t(1), u]; % Set the x-axis tick labels
        ax.XLabel.String = ''; % Clear the x-axis label
    end

    % Step 6: Handle the case when the x-axis ticks are non-zero
    if find(tt) ~= 0
        % Ensure the last tick does not exceed the length of the input data
        if tt(end) > length(Input)
            tt(end) = length(Input); % Adjust the last tick
        end

        % Step 7: Handle the case when the label is 'Time(Sec)'
        if strcmp(xlb, 'Time(Sec)')
            % Prompt the user to enter the sampling frequency if it is not provided or invalid
            if isempty(fs)
                fs = str2double(cell2mat(inputdlg('Enter Fs', 'modal'))); % Prompt for Fs
            else
                if isnan(fs) || (fs == 0) || isempty(fs)
                    fs = str2double(cell2mat(inputdlg('Enter Fs', 'modal'))); % Prompt for Fs
                end
            end

            % Validate the sampling frequency
            if isnan(fs) || (fs == 0)
                msgbox('Please Enter Fs', '', 'warn'); % Show a warning message
                return;
            end

            % Set the x-axis label and compute the time vector
            ax.XLabel.String = xlb; % Set the x-axis label
            Ts = 1 / fs; % Compute the sampling interval
            t = (0:length(Input) - 1) * Ts; % Create the time vector

            % Set the x-axis tick labels
            ax.XTickLabel = round([t(1), t(tt(find(tt)))], 2); % Round the tick labels to 2 decimal places

        % Step 8: Handle the case when the label is 'Sample'
        elseif strcmp(xlb, 'Sample')
            ax.XLabel.String = xlb; % Set the x-axis label
            t = 0:length(Input) - 1; % Create a sample index vector
            u = [];
            % Generate tick labels for the x-axis
            for i = 2:length(tt)
                u = [u, t(tt(i)) + 1]; %#ok<AGROW> % Append the tick values
            end
            ax.XTickLabel = round([t(1), u]); % Set the x-axis tick labels
        end
    else
        % Step 9: Clear the x-axis label if no ticks are present
        ax.XLabel.String = '';
    end
end