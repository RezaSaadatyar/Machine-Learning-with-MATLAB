%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to load and process labels for classification and clustering tasks
function Lab = labels_classification_clustering(values, FF, inputCC, hobj, str, NSC, Classify, ...
    Cluster, Cluster1, NumClass, NumClass1)

    % Initialize the output variable
    Lab = 0;

    % Set default values for classification and clustering options
    set(Classify, 'value', 1);
    set(Cluster, 'Value', 1);
    set(Cluster1, 'Value', 1);

    % Check if no input is selected and display a warning
    if get(inputCC, 'value') == 1
        msgbox('Please Select Input in Block Classification & Clustering', 'Warning', 'warn');
        return;
    end

    % Check if no label is selected and display a warning
    if get(hobj, 'Value') == 1
        msgbox('Please Select Labels in Block Classification & Clustering', 'Warning', 'warn');
        return;
    end

    % Get the string and value of the label selection dropdown
    Spop1 = get(hobj, 'String');
    Vpop1 = get(hobj, 'Value');
    typpop1 = Spop1(Vpop1);

    % Load labels based on the file type
    if strcmp(str, 'xlsx')
        % Load labels from an Excel file
        Lab = xlsread(FF, char(typpop1));
    elseif strcmp(str, 'mat')
        % Load labels from a MATLAB .mat file
        Val = struct2cell(values);
        Lab = cell2mat(Val(Vpop1 - 1));
    elseif strcmp(str, 'txt')
        % Load labels from a text file
        Lab = values;
    end

    % Ensure the labels are in column format
    [handles.a, handles.b] = size(Lab);
    if (handles.a < handles.b)
        Lab = Lab';
    end

    % Prepare the channel selection dropdown options
    Cll = cell(handles.b + 2, 1);
    Cll{1} = 'Select Ch:';
    Cll{handles.b + 2} = 'Multi Ch';
    for i = 2:handles.b + 1
        Cll{i} = ['Ch', num2str(i - 1)];
    end
    set(NSC, 'string', Cll);

    % Get the selected channel value
    Va = get(NSC, 'value');

    % Handle single-channel case
    if handles.b == 1
        set(NumClass1, 'enable', 'off');
        set(NSC, 'value', 1);
        set(NSC, 'enable', 'off');
        set(NumClass, 'enable', 'off');
    else
        % Handle multi-channel case
        set(NSC, 'enable', 'on');
        if Va == 1
            msgbox('Please Select Ch:', '', 'warn');
            return;
        end
        if Va ~= handles.b + 2
            % Select a single channel
            Lab = Lab(:, Va - 1);
        end
        if Va == handles.b + 2
            % Enable multi-channel selection
            set(NumClass, 'enable', 'on');
            set(NumClass1, 'enable', 'on');
            Vchi = str2double(get(NumClass, 'string'));
            Vchj = str2double(get(NumClass1, 'string'));

            % Validate the channel range
            if isnan(Vchi) || (Vchi < 1) || (Vchi > handles.b)
                msgbox(['Please Enter Chi:  0 < Chi < ', num2str(handles.b)], '', 'warn');
                return;
            end
            if isnan(Vchj) || (Vchj < 1) || (Vchj > handles.b + 1)
                msgbox(['Please Enter Chj:  ', num2str(Vchi), '< Chj <', num2str(handles.b) + 1], '', 'warn');
                return;
            end
            if Vchj <= Vchi
                msgbox([num2str(Vchi), '< Chj <', num2str(handles.b) + 1], '', 'warn');
                return;
            end

            % Select the specified range of channels
            Lab = Lab(:, Vchi:Vchj);
        end
    end
end