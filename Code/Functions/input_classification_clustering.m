%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to prepare input data for classification and clustering tasks
function Input_classification = input_classification_clustering(Input, DataFilter, FVal, InputWRecons, ...
    inputCC, NSC, Lals, Cluster, Cluster1, Classify, Nfeat, ax5, ax6, ax7, ax8, ax9, ax10, ax11, ax12)

    % Initialize the output variable
    Input_classification = 0;

    % Set default values for clustering and classification options
    set(Cluster, 'Value', 1);
    set(Classify, 'Value', 1);
    set(Cluster1, 'Value', 1);

    % Check if FVal (filtered values) is provided and concatenate into a single array
    [fb, bb] = size(FVal);
    if bb ~= 0
        u = [];
        for i = 1:fb
            u = [u, cell2mat(FVal(i))]; %#ok<AGROW>
        end
        inputF = u;
    else
        inputF = 0;
    end

    % Get the string and value of the input selection dropdown
    Sinputc = get(inputCC, 'string');
    Vinputc = get(inputCC, 'value');

    % Clear all subplots in the provided axes
    subplot(1, 1, 1, 'replace', 'Parent', ax5);
    subplot(1, 1, 1, 'replace', 'Parent', ax6);
    subplot(1, 1, 1, 'replace', 'Parent', ax7);
    subplot(1, 1, 1, 'replace', 'Parent', ax8);
    subplot(1, 1, 1, 'replace', 'Parent', ax9);
    subplot(1, 1, 1, 'replace', 'Parent', ax10);
    subplot(1, 1, 1, 'replace', 'Parent', ax11);
    subplot(1, 1, 1, 'replace', 'Parent', ax12);

    % Check if no input is selected and display a warning
    if Vinputc == 1
        msgbox('Please Select Input in Block Classification & Clustering', 'Warning', 'warn');
        return;
    end

    % Assign the appropriate input data based on the selection
    if Vinputc == 2
        Input_classification = Input;
    elseif Vinputc == 3
        Input_classification = DataFilter;
    elseif Vinputc == 4
        Input_classification = inputF;
    else
        Input_classification = InputWRecons;
    end

    % Reset the NSC (Number of Selected Channels) and Lals (Labels) dropdowns
    set(NSC, 'value', 1, 'string', 'Select Ch:');
    set(Lals, 'value', 1);

    % Check if the selected input is valid
    if Input_classification == 0
        if Vinputc ~= 5
            msgbox(['Please Load ', Sinputc{Vinputc}], '', 'warn');
            return;
        end
    end

    % Update the number of features in the Nfeat (Number of Features) display
    set(Nfeat, 'string', num2str(size(Input_classification, 2)));
end