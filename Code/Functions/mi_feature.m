%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to compute Mutual Information (MI) between features and target labels
function MI = mi_feature(TrainInputs, TrainTargets, nbins)
    % Inputs:
    %   TrainInputs: Input data matrix (features x samples).
    %   TrainTargets: Target labels for each sample.
    %   nbins: Number of bins for histogram computation.
    % Output:
    %   MI: Mutual Information for each feature.

    % Step 1: Get the number of samples
    N = size(TrainInputs, 2); % Number of samples

    % Step 2: Initialize the Mutual Information array
    MI = zeros(1, size(TrainInputs, 1)); % Mutual Information for each feature

    % Step 3: Compute the histogram and probability distribution of the target labels
    hy = hist(TrainTargets, nbins); % Histogram of target labels
    py = hy / N; % Probability distribution of target labels

    % Step 4: Loop through each feature
    for i = 1:size(TrainInputs, 1)
        %% Step 5: Calculate the histogram and probability distribution of the current feature
        hx = hist(TrainInputs(i, :), nbins); % Histogram of the current feature
        px = hx / N; % Probability distribution of the current feature

        %% Step 6: Calculate the bivariate histogram of the current feature and target labels
        X = [TrainInputs(i, :)', TrainTargets']; % Combine feature and target labels
        hxy = hist3(X, [nbins, nbins]); % Bivariate histogram

        %% Step 7: Calculate the joint and independent probability distributions
        pxy_joint = hxy / N; % Joint probability distribution
        pxy_indep = px' * py; % Independent probability distribution

        %% Step 8: Compute Mutual Information
        tp = pxy_joint .* log2(pxy_joint ./ pxy_indep); % Mutual Information term

        % Handle NaN and Inf values in the Mutual Information term
        I = isnan(tp); % Find NaN values
        tp(I) = []; % Remove NaN values
        I = isinf(tp); % Find Inf values
        tp(I) = []; % Remove Inf values

        % Sum the Mutual Information term to get the final MI value for the current feature
        MI(i) = sum(tp(:));
    end
end