%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to perform Multi-Layer Perceptron (MLP) classification with cross-validation
function [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = MLP(inputc, KFold, Label, ...
    epocm, maxfm, Numh, NN, tlfmlp, tTFun, reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ...
    ax5, ax6, ax9, ax10)

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
    Kf = cell(1, KFold + 1);
    Kf{1} = 'Real';
    y = cell(1, nclass);
    Kfol = cell(KFold, 1);

    % Step 6: Validate input parameters
    if isnan(Numh) || (ceil(Numh) <= 0) || (ceil(Numh) > 3)
        msgbox('Please Enter 0 < Number hidden layers < 4', '', 'warn');
        return;
    end
    if isnan(epocm) || (epocm < 1)
        msgbox('Please Enter Epochs > 1', '', 'warn');
        return;
    end
    if isnan(maxfm) || (maxfm < 1)
        msgbox('Please Enter Max Fail (Overfitting) > 1', '', 'warn');
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
        TrainTargets = ind2vec(Label(trIdx, :)');
        TestInputs = inputc(teIdx, :)';
        labelTargetTest = ind2vec(Label(teIdx, :)');

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

        %% Step 10: MLP Model Training
        % Create and configure the MLP network
        net = feedforwardnet(NN, char(tlfmlp));
        net.trainParam.epochs = epocm;
        net.trainParam.max_fail = maxfm;

        % Set the transfer function for the output layer
        c = net.numLayers;
        net.layers{c}.transferFcn = char(tTFun);

        % Train the MLP network
        net = train(net, TrainInputs, full(TrainTargets));

        % Evaluate the model on training data
        for j = 1:nclass
            nTrainData(i, j) = length(find(Label(trIdx, :) == j));
        end
        labeltrain = net(TrainInputs);
        INtr{i} = vec2ind(labeltrain);
        [AccT, SenT, SpeT, PreT, FmT, MCCT, ~] = confusion_matrix(vec2ind(TrainTargets), vec2ind(labeltrain));
        PerfomanceT(i, :) = [AccT SenT SpeT];
        PerfomanceTotalT(i, :) = [AccT SenT SpeT PreT FmT MCCT];

        % Evaluate the model on testing data
        for j = 1:nclass
            nTestData(i, j) = length(find(Label(teIdx, :) == j));
        end
        label = net(TestInputs);
        INte{i} = vec2ind(label);
        [Acc, Sen, Spe, Pre, Fm, MCC, ~] = confusion_matrix(vec2ind(labelTargetTest), vec2ind(label));
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
    PP(1) = plot(p(1), vec2ind(TrainTargets), 'k--', 'Linewidth', 1);
    hold on;
    for i = 1:KFold
        PP(i + 1) = plot(p(1), INtr{i} + b, '.', 'MarkerSize', 12);
        b = b + 0.03;
    end
    til = legend(p(1), Kf, 'Location', 'best');
    title(til, 'Training');
    p(1).YLim = [1 nclass + b];
    ylabel(p(1), {'Predict Classes in'; 'each Kfold (MLP)'});
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
    PP(numel(PP) + 1) = plot(p(3), vec2ind(labelTargetTest), 'k--', 'Linewidth', 1);
    hold on;
    nP = numel(PP);
    for i = 1:KFold
        PP(i + nP) = plot(p(3), INte{i} + b, '.', 'MarkerSize', 12);
        b = b + 0.03;
    end
    til = legend(p(3), Kf, 'Location', 'best');
    title(til, 'Test');
    ylabel(p(3), {'Predict Classes in'; 'each Kfold (MLP)'});
    xlabel(p(3), 'Sample');
    p(3).YTick = 1:nclass;
    p(3).YLim = [1 nclass + b];
    p(3).XLim = [0 length(INte{1})];
    p(3).FontName = 'Times New Roman';
    p(3).FontWeight = 'bold';

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