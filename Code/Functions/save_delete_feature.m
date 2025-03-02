%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [FVal, Fstr, SW, SS] = save_delete_feature(Data, FVal, Fstr, SW, SS, Input, inputf, list2, Chi, Chj, ...
    input, delete, ax2, cm, CM, cmm)
% This function handles saving and deleting features extracted from the input signal.
% It updates the GUI and manages the list of saved features.

% Check if data is loaded
if Data == 0
    % Display an error message if no data is loaded
    msgbox('Please Load Data in Block Load Data', 'Error Load Data', 'error'); return;
end

% Check if the input type is selected
if get(inputf, 'value') == 1
    % Display a warning if no input type is selected
    msgbox('Please Select Input Type in Block Feature Extraction', '', 'warn'); return;
end

% Check if the feature list is empty
if strcmp(get(list2, 'string'), 'Select:')
    % Display a warning if no feature is saved
    msgbox('Please Save Feature', 'Warning', 'warn'); return;
end

% Retrieve the selected channel range and feature list details
Vchi = str2double(get(Chi, 'string')); Vchj = str2double(get(Chj, 'string')); Slist = get(list2, 'string');
Valist = get(list2, 'value'); typlist = Slist(Valist); subplot(1, 1, 1, 'replace', 'Parent', ax2);

% Retrieve the selected input and its value
SInput = get(input, 'String'); VInput = get(input, 'value'); VSInput = SInput(VInput);

% Check if the delete option is selected
delval = get(delete, 'value');
if delval == 1
    % Delete the selected feature from the saved list
    if ~isempty(FVal)
        FVal(Valist) = []; Fstr(Valist) = []; SW(Valist) = []; SS(Valist) = [];
    end
    Valist = 1;

    % Update the feature list in the GUI
    if size(FVal, 2) == 0
        set(list2, 'string', 'Select:');
    else
        set(list2, 'value', 1); set(list2, 'string', Fstr); Slist = get(list2, 'string'); typlist = Slist(Valist);
    end

    % Reset the delete option
    set(delete, 'value', 0);
end

% Plot the remaining features if any are saved
if size(FVal, 2) ~= 0
    plot_time_domain_features(Data, Input, FVal, SW, SS, Valist, VSInput, VInput, SInput, typlist, Vchi, Vchj, ...
        ax2, cm, CM, cmm);
else
    % Clear the feature lists and the plot if no features are saved
    FVal = []; Fstr = []; SW = []; SS = []; subplot(1, 1, 1, 'replace', 'Parent', ax2);
end
end