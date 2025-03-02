%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to perform Probabilistic Neural Network (PNN) classification with cross-validation
function [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = PNN(inputc, KFold, Label, sigma, ...
    val, Type, reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10)

    % Step 1: Determine the number of unique classes
    nclass = length(unique(Label));

    % Step 2: Create cross-validation partitions
    Indx = cvpartition(Label, 'k', KFold);

    % Step 3: Get the dimensionality reduction method and feature reduction type
    Reduct = get(reduct, 'value');
    ReductT = get(redfeat, 'value');

    % Step 4: Initialize performance matrices
    Perfomance = zeros(KFold, 3);
    PerfomanceTotal = zeros(KFold, 6);
    PerfomanceT = zeros(KFold, 3);
    PerfomanceTotalT = zeros(KFold, 6);

    % Step 5: Initialize cell arrays for storing intermediate results
    INtr = cell(KFold, 1);
    INte = INtr;
    nTrainData = zeros(KFold, nclass);
    nTestData = nTrainData;
    U = cell(KFold, 1);
    U1 = U;
    Kfol = cell(KFold, 1);
    Kf = cell(1, KFold + 1);
    Kf{1} = 'Real';
    y = cell(1, nclass);

    % Step 6: Validate the sigma parameter
    if isnan(sigma) || (sigma < 0)
        msgbox('Please Enter Sigma > 0', '', 'warn');
        return;
    end

    % Step 7: Create a waitbar to show progress
    hWait = waitbar(0, 'Please wait....');
    hPatch = findobj(hWait, 'Type', 'Patch');
    set(hPatch, 'FaceColor', 'g', 'EdgeColor', 'k');
    set(hWait, 'windowstyle', 'modal');

    % Step 8: Loop through each fold of the cross-validation
    for i = 1:KFold
        % Update the waitbar message
        message = sprintf('KFold %d of %d. Please wait Training and Test your data', i, KFold);
        waitbar(i / KFold, hWait, message);

        % Get training and testing indices for the current fold
        trIdx = Indx.training(i);
        teIdx = Indx.test(i);

        % Prepare training and testing data
        TrainInputs = inputc(trIdx, :)';
        TrainTargets = Label(trIdx, :)';
        TestInputs = inputc(teIdx, :)';
        labelTargetTest = Label(teIdx, :)';

        % Store the training labels
        LTargets = Label(trIdx, :)';

        %% Step 9: Dimensionality Reduction (PCA or FDA)
        if Reduct == 2
            if ReductT == 1
                % Perform PCA feature reduction
                W = pca_feature(TrainInputs, nfeature);
            elseif ReductT == 2
                % Validate the number of features for FDA
                if isnan(nfeature) || (nfeature >= nclass)
                    msgbox(['Please Enter Number features;  0 < Number features < ' num2str(nclass)], '', 'warn');
                    return;
                end
                % Perform FDA (LDA) feature reduction
                W = lda_feature(TrainInputs, LTargets, nfeature);
            end
            % Apply the dimensionality reduction to training and testing data
            TrainInputs = W' * TrainInputs;
            TestInputs = W' * TestInputs;
        elseif Reduct == 3
            % Perform feature selection
            ind = feature_selction(TrainInputs, LTargets, Alpha, Bin, ValF);
            if ind == 0
                return;
            end
            % Store the selected features
            Kfol(i) = {['KFold', num2str(i)]};
            U(i) = {ind};
            U1(i) = {ind(1:nfeature)};
            % Update the feature selection display
            Nfeat1.ForegroundColor = 'r';
            Nfeat2.ForegroundColor = 'm';
            % Apply the feature selection to training and testing data
            TrainInputs = TrainInputs(ind(1:nfeature), :);
            TestInputs = TestInputs(ind(1:nfeature), :);
        end

        %% Step 10: PNN Model Training and Testing
        % Normalize the training data if required
        if val == 1
            mu = mean(TrainInputs, 2); % Mean of the training data
            sd = std(TrainInputs, 0, 2); % Standard deviation of the training data
            wkk = (TrainInputs - repmat(mu, 1, size(TrainInputs, 2))) ./ repmat(sd, 1, size(TrainInputs, 2)); % Normalized training data
        else
            wkk = TrainInputs; % Use the original training data
        end

        % Evaluate the model on training data
        for j = 1:nclass
            nTrainData(i, j) = length(find(Label(trIdx, :) == j));
        end

        % Compute the activation values for the training data
        okk = zeros(size(TrainInputs, 2), size(TrainInputs, 2));
        for jj = 1:size(TrainInputs, 2)
            x = TrainInputs(:, jj); % Current training sample
            if val == 1
                xn = (x - mu) ./ sd; % Normalize the sample
            else
                xn = x; % Use the original sample
            end
            if Type == 1
                % Compute the activation using dot product
                zkk = wkk' * xn;
                okk(:, jj) = exp((zkk - 1) / sigma);
            else
                % Compute the activation using Euclidean distance
                reptXn = repmat(xn, 1, size(wkk, 2));
                r = sqrt(sum((reptXn - wkk).^2));
                okk(:, jj) = (1 / sqrt(2 * pi * sigma)) * exp(-(r) / (2 * sigma));
            end
        end

        % Check for infinite values in the activation matrix
        if numel(find(okk == inf)) > numel(okk) / 2
            msgbox('Please activate Normalize Input', '', 'warn');
            return;
        end

        % Compute the class probabilities
        L = unique(TrainTargets); % Unique class labels
        class = numel(L); % Number of classes
        index = cell(1, class); % Indices of samples for each class
        S = zeros(class, size(TrainInputs, 2)); % Sum of activations for each class
        for ii = 1:class
            index{ii} = find(TrainTargets == L(ii)); % Find indices for the current class
        end
        for j = 1:class
            S(j, :) = sum(okk(index{j}, :)); % Sum activations for the current class
        end
        [~, labeltrain] = max(S); % Assign the label with the highest probability
        INtr{i} = labeltrain;

        % Compute performance metrics for training data
        [AccT, SenT, SpeT, PreT, FmT, MCCT, ~] = confusion_matrix(TrainTargets, labeltrain);
        PerfomanceT(i, :) = [AccT SenT SpeT];
        PerfomanceTotalT(i, :) = [AccT SenT SpeT PreT FmT MCCT];

        % Evaluate the model on testing data
        for j = 1:nclass
            nTestData(i, j) = length(find(Label(teIdx, :) == j));
        end

        % Compute the activation values for the testing data
        okk = zeros(size(TrainInputs, 2), size(TestInputs, 2));
        for jj = 1:size(TestInputs, 2)
            x = TestInputs(:, jj); % Current testing sample
            if val == 1
                xn = (x - mu) ./ sd; % Normalize the sample
            else
                xn = x; % Use the original sample
            end
            if Type == 1
                % Compute the activation using dot product
                zkk = wkk' * xn;
                okk(:, jj) = exp((zkk - 1) / sigma);
            else
                % Compute the activation using Euclidean distance
                reptXn = repmat(xn, 1, size(wkk, 2));
                r = sqrt(sum((reptXn - wkk).^2));
                okk(:, jj) = (1 / sqrt(2 * pi * sigma)) * exp(-(r) / (2 * sigma));
            end
        end

        % Check for infinite values in the activation matrix
        if numel(find(okk == inf)) > numel(okk) / 2
            msgbox('Please activate Normalize Input', '', 'warn');
            return;
        end

        % Compute the class probabilities
        S = zeros(class, size(TestInputs, 2)); % Sum of activations for each class
        for ii = 1:class
            index{ii} = find(TrainTargets == L(ii)); % Find indices for the current class
        end
        for j = 1:class
            S(j, :) = sum(okk(index{j}, :)); % Sum activations for the current class
        end
        [~, label] = max(S); % Assign the label with the highest probability
        INte{i} = label;

        % Compute performance metrics for testing data
        [Acc, Sen, Spe, Pre, Fm, MCC, ~] = confusion_matrix(labelTargetTest, label);
        Perfomance(i, :) = [Acc Sen Spe];
        PerfomanceTotal(i, :) = [Acc Sen Spe Pre Fm MCC];

        % Store the fold information
        Kf{i + 1} = ['Kfold' num2str(i)];
    end

    % Step 11: Update the feature selection display if feature selection was performed
    if Reduct == 3
        set(Nfeat1, 'Data', cell2mat(U), 'RowName', Kfol);
        set(Nfeat2, 'Data', cell2mat(U1), 'RowName', Kfol);
    end

    % Step 12: Close the waitbar
    delete(hWait);

    % Step 13: Prepare class labels for display
    for i = 1:nclass
        y{i} = ['Class' num2str(i)];
    end

    %% Step 14: Plot Training Results
    pos1 = [0.1 0.2 0.8 0.7];
    b = 0;
    p(1) = subplot('Position', pos1, 'Parent', ax5);
    PP(1) = plot(p(1), TrainTargets, 'k--', 'Linewidth', 1);
    hold on;
    for i = 1:KFold
        PP(i + 1) = plot(p(1), INtr{i} + b, '.', 'MarkerSize', 12);
        b = b + 0.03;
    end
    til = legend(p(1), Kf, 'Location', 'best');
    p(1).YLim = [1 nclass + b];
    title(til, 'Training');
    ylabel(p(1), {'Predict Classes in'; 'each Kfold (PNN)'});
    xlabel(p(1), 'Sample');
    p(1).YTick = 1:nclass;
    p(1).FontName = 'Times New Roman';
    p(1).FontWeight = 'bold';
    p(1).XLim = [0 length(INtr{1})];

    p(2) = subplot('Position', pos1, 'Parent', ax6);
    bar(nTrainData);
    til = legend(p(2), y, 'Location', 'best');
    xlabel(p(2), 'KFold');
    ylabel(p(2), 'Number Samples');
    title(til, 'Training');
    p(2).YGrid = 'on';
    p(2).FontName = 'Times New Roman';
    p(2).FontWeight = 'bold';

    %% Step 15: Plot Testing Results
    pos1 = [0.1 0.2 0.8 0.7];
    b = 0;
    p(3) = subplot('Position', pos1, 'Parent', ax9);
    PP(numel(PP) + 1) = plot(p(3), labelTargetTest, 'k--', 'Linewidth', 1);
    hold on;
    nP = numel(PP);
    for i = 1:KFold
        PP(i + nP) = plot(p(3), INte{i} + b, '.', 'MarkerSize', 12);
        b = b + 0.03;
    end
    til = legend(p(3), Kf, 'Location', 'best');
    ylabel(p(3), {'Predict Classes in'; 'each Kfold (PNN)'});
    xlabel(p(3), 'Sample');
    p(3).YTick = 1:nclass;
    p(3).YLim = [1 nclass + b];
    title(til, 'Test');
    p(3).FontName = 'Times New Roman';
    p(3).FontWeight = 'bold';
    p(3).XLim = [0 length(INte{1})];

    p(4) = subplot('Position', pos1, 'Parent', ax10);
    bar(nTestData);
    til = legend(p(4), y, 'Location', 'best');
    xlabel(p(4), 'KFold');
    ylabel(p(4), 'Number Samples');
    title(til, 'Test');
    p(4).YGrid = 'on';
    p(4).FontName = 'Times New Roman';
    p(4).FontWeight = 'bold';

    % Step 16: Set context menus for the plots
    set(p, 'uicontextmenu', cm);
    set(PP, 'uicontextmenu', CM);
end