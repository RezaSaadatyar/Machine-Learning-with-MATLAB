%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to visualize performance metrics using bar plots
function Performance(TPerf, TPerfT, FTPerf, ax6, ax7, cm, T)
    % Inputs:
    %   TPerf: Performance metrics for testing data (e.g., Accuracy, Sensitivity, Specificity).
    %   TPerfT: Performance metrics for training data (e.g., Accuracy, Sensitivity, Specificity, Precision, F-measure, MCC).
    %   FTPerf: Labels for the x-axis (e.g., fold names or model names).
    %   ax6: Axes handle for the first subplot (testing performance).
    %   ax7: Axes handle for the second subplot (training performance).
    %   cm: Context menu for the plots.
    %   T: Title for the legend.

    % Step 1: Create the first subplot for testing performance
    p1 = subplot(1, 1, 1, 'replace', 'Parent', ax6); % Create subplot in ax6
    b = bar(p1, TPerf, 'FaceColor', 'flat'); % Plot bar chart for testing performance

    % Step 2: Create the second subplot for training performance
    p2 = subplot(1, 1, 1, 'replace', 'Parent', ax7); % Create subplot in ax7
    b2 = bar(p2, TPerfT, 'FaceColor', 'flat'); % Plot bar chart for training performance

    % Step 3: Customize the first subplot (testing performance)
    p1.YGrid = 'on'; % Enable grid on the y-axis
    ylabel(p1, '%'); % Label for the y-axis
    p1.YLim = [0 103]; % Set y-axis limits
    p1.FontSize = 10; % Set font size
    p1.FontWeight = 'bold'; % Set font weight
    p1.FontName = 'Times New Roman'; % Set font name
    p1.XTickLabel = []; % Remove x-axis labels initially

    % Step 4: Customize the second subplot (training performance)
    p2.YGrid = 'on'; % Enable grid on the y-axis
    ylabel(p2, '%'); % Label for the y-axis
    p2.YLim = [0 103]; % Set y-axis limits
    p2.FontSize = 10; % Set font size
    p2.FontWeight = 'bold'; % Set font weight
    p2.FontName = 'Times New Roman'; % Set font name
    p2.XTickLabel = []; % Remove x-axis labels initially

    % Step 5: Add labels, legends, and colors if FTPerf has more than one element
    if length(FTPerf) > 1
        % Add legend and customize the first subplot
        til = legend(p1, {'Accuracy', 'Sensitivity', 'Specificity'}, 'Location', 'southeast');
        p1.XTickLabel = FTPerf; % Set x-axis labels
        title(til, T); % Set legend title
        p1.XTick = 1:length(FTPerf); % Set x-axis ticks
        b(1).CData = [1, 0, 0]; % Set color for Accuracy (red)
        b(2).CData = [0, 1, 0]; % Set color for Sensitivity (green)
        b(3).CData = [0.49, 0.18, 0.56]; % Set color for Specificity (purple)
        p1.XTickLabelRotation = 90; % Rotate x-axis labels by 90 degrees

        % Add legend and customize the second subplot
        til = legend(p2, {'Accuracy', 'Sensitivity', 'Specificity', 'Precision', 'F-measure', 'MCC'}, 'Location', 'southeast');
        p2.XTickLabel = FTPerf; % Set x-axis labels
        p2.XTickLabelRotation = 90; % Rotate x-axis labels by 90 degrees
        b2(1).CData = [1, 0, 0]; % Set color for Accuracy (red)
        b2(2).CData = [0, 0, 1]; % Set color for Sensitivity (blue)
        title(til, T); % Set legend title
        b2(3).CData = [0, 1, 0]; % Set color for Specificity (green)
        b2(4).CData = [1, 1, 0]; % Set color for Precision (yellow)
        b2(5).CData = [0.49, 0.18, 0.56]; % Set color for F-measure (purple)
        b2(6).CData = [0, 1, 1]; % Set color for MCC (cyan)
        p2.XTick = 1:length(FTPerf); % Set x-axis ticks
    end

    % Step 6: Set context menus for the plots
    set(p1, 'uicontextmenu', cm); % Add context menu to the first subplot
    set(p2, 'uicontextmenu', cm); % Add context menu to the second subplot
end