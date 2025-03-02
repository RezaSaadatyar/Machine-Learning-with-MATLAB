%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to perform Principal Component Analysis (PCA) for feature extraction
function [W] = pca_feature(TrainInputs, nfeature)
    % Inputs:
    %   TrainInputs: Input data matrix (features x samples).
    %   nfeature: Number of features to select (number of principal components).
    % Output:
    %   W: Transformation matrix for feature extraction.

    % Step 1: Normalize the data by subtracting the mean
    mu_p = mean(TrainInputs, 2); % Compute the mean of each feature (column-wise)
    reptMu = repmat(mu_p, 1, size(TrainInputs, 2)); % Replicate the mean vector for subtraction
    Xn = TrainInputs - reptMu; % Subtract the mean to center the data

    % Step 2: Calculate the covariance matrix
    C = cov(Xn'); % Compute the covariance matrix of the centered data

    % Step 3: Perform eigenvalue decomposition
    [U, D] = eig(C); % U: Eigenvectors, D: Eigenvalues

    % Step 4: Sort eigenvalues and eigenvectors in descending order
    D = diag(D); % Extract eigenvalues as a vector
    [~, ind] = sort(D, 'descend'); % Sort eigenvalues in descending order
    U = U(:, ind); % Sort eigenvectors accordingly

    % Step 5: Select the top nfeature eigenvectors
    W = U(:, 1:nfeature); % Select the top nfeature eigenvectors
end