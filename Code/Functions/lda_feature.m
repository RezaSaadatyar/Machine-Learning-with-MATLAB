%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to perform Linear Discriminant Analysis (LDA) for feature extraction
function W = lda_feature(TrainInputs, TrainTargets, nfeature)
    % Inputs:
    %   TrainInputs: Input data matrix (features x samples).
    %   TrainTargets: Class labels for each sample.
    %   nfeature: Number of features to select (must be <= C-1, where C is the number of classes).
    % Output:
    %   W: Transformation matrix for feature extraction.

    % Step 1: Compute the total number of samples and the dimensionality of the data
    N = size(TrainInputs, 2); % Number of samples
    d = size(TrainInputs, 1); % Dimensionality of the data

    % Step 2: Compute the mean of the entire dataset
    mt = mean(TrainInputs, 2); % Mean of all samples (d x 1)

    % Step 3: Initialize scatter matrices
    SW = zeros(d, d); % Within-class scatter matrix
    SB = zeros(d, d); % Between-class scatter matrix

    % Step 4: Get unique class labels and the number of classes
    userlabel = unique(TrainTargets); % Unique class labels
    C = numel(userlabel); % Number of classes

    % Step 5: Compute scatter matrices
    for i = 1:C
        % Find indices of samples belonging to the current class
        ind = find(TrainTargets == userlabel(i));
        
        % Extract data for the current class
        Xc = TrainInputs(:, ind); % Data for the current class (d x ni)
        
        % Compute the covariance matrix for the current class
        si = cov(Xc'); % Within-class scatter for the current class (d x d)
        
        % Compute the mean of the current class
        mi = mean(Xc, 2); % Mean of the current class (d x 1)
        
        % Compute the proportion of samples in the current class
        ni = numel(ind) / N; % Proportion of samples in the current class
        
        % Update the within-class scatter matrix
        SW = SW + si; % Accumulate within-class scatter
        
        % Update the between-class scatter matrix
        SB = SB + (ni * (mi - mt) * (mi - mt)'); % Accumulate between-class scatter
    end

    %% Step 6: Eigenvalue decomposition
    % Solve the generalized eigenvalue problem: SB * W = lambda * SW * W
    [U, D] = eig(SB, SW); % U: Eigenvectors, D: Eigenvalues
    % Alternatively: [U, D] = eig(inv(SW) * SB);

    %% Step 7: Sort eigenvectors according to eigenvalues
    D = diag(D); % Extract eigenvalues as a vector
    [~, ind] = sort(D, 'descend'); % Sort eigenvalues in descending order
    U = U(:, ind); % Sort eigenvectors accordingly

    %% Step 8: Select the top nfeature eigenvectors
    W = U(:, 1:nfeature); % Select the top nfeature eigenvectors
end