%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================= E-mail: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [Acc, Sen, Spe, Pre, Fm, MCC, CMax] = confusion_matrix(labelTargetTest, label)
% This function computes performance metrics such as accuracy, sensitivity, specificity,
% precision, F-measure, and Matthews correlation coefficient (MCC) based on the confusion matrix.

% Compute accuracy
if iscell(label)
    % If the labels are in cell format, compare them using string comparison
    aa = strcmp(labelTargetTest, label); aa = aa(aa ~= 0); Acc = (length(aa) / length(label)) * 100;
else
    % If the labels are numeric, compute accuracy using numeric comparison
    aa = (label - labelTargetTest); aa = aa(aa == 0); Acc = (length(aa) / length(label)) * 100;
end

% Compute the confusion matrix
CMax = confusionmat(labelTargetTest, label);

% Initialize other performance metrics
Sen = []; Spe = []; Pre = []; Fm = []; MCC = [];

% Compute metrics for binary classification (2x2 confusion matrix)
if length(CMax) == 2
    Tp = CMax(1, 1); % True positives
    Tn = CMax(2, 2); % True negatives
    Fn = CMax(2, 1); % False negatives
    Fp = CMax(1, 2); % False positives

    % Sensitivity (Recall or True Positive Rate)
    Sen = (Tp / (Tp + Fn)) * 100;

    % Specificity (True Negative Rate)
    Spe = (Tn / (Tn + Fp)) * 100;

    % Precision (Positive Predictive Value)
    Pre = (Tp / (Tp + Fp)) * 100;

    % F-measure (F1 Score)
    Fm = (2 * Tp / (2 * Tp + Fp + Fn)) * 100;

    % Matthews Correlation Coefficient (MCC)
    MCC = ((Tp * Tn - Fp * Fn) / (sqrt((Tp + Fp) * (Tp + Fn) * (Tn + Fp) * (Tn + Fn)))) * 100;
else
    % Compute metrics for multi-class classification
    for i = 1:length(CMax)
        % Sensitivity for each class
        Sen = [Sen, (CMax(i, i) / sum(CMax(i, :), 2)) * 100]; %#ok<AGROW>
    end

    for i = 1:length(CMax)
        % Specificity for each class
        ss = sum(CMax(:)) - sum(CMax(i, :), 2) - sum(CMax(:, i), 1) + CMax(i, i);
        yy = sum(CMax(:)) - sum(CMax(i, :), 2);
        Spe = [Spe, (ss / yy) * 100]; %#ok<AGROW>
    end

    for i = 1:length(CMax)
        % Precision for each class
        Pre = [Pre, (CMax(i, i) / sum(CMax(:, i), 1)) * 100]; %#ok<AGROW>
    end

    for i = 1:length(CMax)
        % F-measure for each class
        Fm = [Fm, (2 * CMax(i, i) / (sum(CMax(:, i), 1) + sum(CMax(i, :), 2))) * 100]; %#ok<AGROW>
    end

    for i = 1:length(CMax)
        % Matthews Correlation Coefficient (MCC) for each class
        TN = sum(CMax(:)) - sum(CMax(i, :), 2) - sum(CMax(:, i), 1) + CMax(i, i);
        FP = sum(CMax(:, i), 1) - CMax(i, i);
        FN = sum(CMax(i, :), 2) - CMax(i, i);
        num = CMax(i, i) * TN - (FP * FN);
        dem = (CMax(i, i) + FP) * (CMax(i, i) + FN) * (TN + FP) * (TN + FN);
        MCC = [MCC, (num / sqrt(dem)) * 100]; %#ok<AGROW>
    end

    % Average the metrics across all classes
    Sen = sum(Sen, 2) / length(CMax);
    Spe = sum(Spe, 2) / length(CMax);
    Pre = sum(Pre, 2) / length(CMax);
    Fm = sum(Fm, 2) / length(CMax);
    MCC = sum(MCC, 2) / length(CMax);
end

% The following commented-out code is for plotting ROC curves (if needed)
% p = subplot(1, 1, 1, 'Parent', ax);
% ax1 = plotroc(labelTargetTest, label);

% [tpr, fpr, thresholds] = roc(labelTargetTest, label);
% labels = cell(1, length(CMax));
% for i = 1:length(CMax), labels{i} = ['Class ' num2str(i)]; end
% figure;
% plot(fpr, tpr)
% legend(labels)
end