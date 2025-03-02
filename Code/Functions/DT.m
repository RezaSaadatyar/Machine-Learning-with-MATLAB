%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

function [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = DT(inputc, KFold, Label, reduct, ...
    nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10)
% This function performs Decision Tree (DT) classification using k-fold cross-validation.
% It supports dimensionality reduction (PCA, LDA, or feature selection) and evaluates the performance of the classifier.

% Determine the number of unique classes
nclass = length(unique(Label));

% Create a k-fold cross-validation partition
Indx = cvpartition(Label, 'k', KFold);

% Retrieve the selected dimensionality reduction method
Reduct = get(reduct, 'value');
ReductT = get(redfeat, 'value');

% Initialize performance matrices
Perfomance = zeros(KFold, 3); PerfomanceTotal = zeros(KFold, 6);
PerfomanceT = zeros(KFold, 3); PerfomanceTotalT = zeros(KFold, 6);

% Initialize cell arrays for storing training and testing results
INtr = cell(KFold, 1); INte = INtr;

% Initialize matrices for storing the number of training and testing samples per class
nTrainData = zeros(KFold, nclass); nTestData = nTrainData;

% Initialize cell arrays for storing feature selection results
U = cell(KFold, 1); U1 = U; Kfol = cell(KFold, 1);
Kf = cell(1, KFold + 1); Kf{1} = 'Real'; y = cell(1, nclass);

% Display a waitbar for progress tracking
hWait = waitbar(0, 'Please wait....'); hPatch = findobj(hWait, 'Type', 'Patch');
set(hPatch, 'FaceColor', 'g', 'EdgeColor', 'k'); set(hWait, 'windowstyle', 'modal');

% Perform k-fold cross-validation
for i = 1:KFold
    % Update the waitbar message
    message = sprintf('KFold %d of %d. Please wait Training and Test your data', i, KFold);
    waitbar(i / KFold, hWait, message);

    % Get the training and testing indices for the current fold
    trIdx = Indx.training(i); teIdx = Indx.test(i);

    % Extract the training and testing data
    TrainInputs = inputc(trIdx, :); TrainTargets = Label(trIdx, :);
    TestInputs = inputc(teIdx, :); labelTargetTest = Label(teIdx, :);

    %% Dimensionality reduction (PCA, LDA, or feature selection)
    LTargets = Label(trIdx, :)';
    if Reduct == 2
        % Perform PCA or LDA
        if ReductT == 1
            W = pca_feature(TrainInputs', nfeature);
        elseif ReductT == 2
            if isnan(nfeature) || (nfeature >= nclass)
                msgbox(['Please Enter Number features;  0 < Number features < ' num2str(nclass)], '', 'warn'); return;
            end
            W = lda_feature(TrainInputs', LTargets, nfeature);
        end
        % Apply the dimensionality reduction to the training and testing data
        TrainInputs = (W' * TrainInputs')'; TestInputs = (W' * TestInputs')';
    elseif Reduct == 3
        % Perform feature selection
        ind = feature_selction(TrainInputs', LTargets, Alpha, Bin, ValF);
        if ind == 0
            return;
        end
        % Store the selected features
        Kfol(i) = {['KFold', num2str(i)]}; U(i) = {ind}; U1(i) = {ind(1:nfeature)};
        Nfeat1.ForegroundColor = 'r'; Nfeat2.ForegroundColor = 'm';
        % Apply the feature selection to the training and testing data
        TrainInputs = TrainInputs(:, ind(1:nfeature)); TestInputs = TestInputs(:, ind(1:nfeature));
    end

    %% Decision Tree Classification
    % Train the Decision Tree classifier
    Mdl = fitctree(TrainInputs, TrainTargets);

    % Evaluate the classifier on the training data
    for j = 1:nclass
        nTrainData(i, j) = length(find(Label(trIdx, :) == j));
    end
    labeltrain = predict(Mdl, TrainInputs); INtr{i} = labeltrain;
    [AccT, SenT, SpeT, PreT, FmT, MCCT, ~] = confusion_matrix(TrainTargets, labeltrain);
    PerfomanceT(i, :) = [AccT SenT SpeT]; PerfomanceTotalT(i, :) = [AccT SenT SpeT PreT FmT MCCT];

    % Evaluate the classifier on the testing data
    for j = 1:nclass
        nTestData(i, j) = length(find(Label(teIdx, :) == j));
    end
    label = predict(Mdl, TestInputs); INte{i} = label;
    [Acc, Sen, Spe, Pre, Fm, MCC, ~] = confusion_matrix(labelTargetTest, label);
    Perfomance(i, :) = [Acc Sen Spe]; PerfomanceTotal(i, :) = [Acc Sen Spe Pre Fm MCC];

    % Store the fold information
    Kf{i + 1} = ['Kfold' num2str(i)];
end

% Update the feature selection results in the GUI
if Reduct == 3
    set(Nfeat1, 'Data', cell2mat(U), 'RowName', Kfol); set(Nfeat2, 'Data', cell2mat(U1), 'RowName', Kfol);
end

% Close the waitbar
delete(hWait);

% Generate class labels for plotting
for i = 1:nclass
    y{i} = ['Class' num2str(i)];
end

%% Plot the training results
pos1 = [0.1 0.2 0.8 0.7]; b = 0; p(1) = subplot('Position', pos1, 'Parent', ax5);
PP(1) = plot(p(1), TrainTargets, 'k--', 'Linewidth', 1); hold on;
for i = 1:KFold
    PP(i + 1) = plot(p(1), INtr{i} + b, '.', 'MarkerSize', 12); b = b + 0.03; %#ok<AGROW>
end
til = legend(p(1), Kf, 'Location', 'best'); title(til, 'Training'); p(1).YLim = [1 nclass + b];
ylabel(p(1), {'Predict Classes in'; 'each Kfold (DT)'}); xlabel(p(1), 'Sample'); p(1).YTick = 1:nclass;
p(1).FontName = 'Times New Roman'; p(1).FontWeight = 'bold'; p(1).XLim = [0 length(INtr{1})];

p(2) = subplot('Position', pos1, 'Parent', ax6); bar(nTrainData); til = legend(p(2), y, 'Location', 'best');
xlabel(p(2), 'KFold'); ylabel(p(2), 'Number Samples'); title(til, 'Training');
p(2).YGrid = 'on'; p(2).FontName = 'Times New Roman'; p(2).FontWeight = 'bold';

%% Plot the testing results
pos1 = [0.1 0.2 0.8 0.7]; b = 0; p(3) = subplot('Position', pos1, 'Parent', ax9);
PP(numel(PP) + 1) = plot(p(3), labelTargetTest, 'k--', 'Linewidth', 1); hold on; nP = numel(PP);
for i = 1:KFold
    PP(i + nP) = plot(p(3), INte{i} + b, '.', 'MarkerSize', 12); b = b + 0.03;
end
til = legend(p(3), Kf, 'Location', 'best'); ylabel(p(3), {'Predict Classes in'; 'each Kfold (DT)'});
xlabel(p(3), 'Sample'); p(3).YTick = 1:nclass; p(3).YLim = [1 nclass + b]; title(til, 'Test');
p(3).FontName = 'Times New Roman'; p(3).FontWeight = 'bold'; p(3).XLim = [0 length(INte{1})];

p(4) = subplot('Position', pos1, 'Parent', ax10); bar(nTestData); til = legend(p(4), y, 'Location', 'best');
xlabel(p(4), 'KFold'); ylabel(p(4), 'Number Samples'); title(til, 'Test');
p(4).YGrid = 'on'; p(4).FontName = 'Times New Roman'; p(4).FontWeight = 'bold';

% Set context menus for the plots
set(p, 'uicontextmenu', cm); set(PP, 'uicontextmenu', CM);
end