%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to perform PCA-based classification on test data
function labeltest = pca_test(mdl, datatest)
    % Inputs:
    %   mdl: A trained PCA model containing:
    %        - userlabel: Unique class labels.
    %        - nfeature: Number of features (principal components).
    %        - Mu: Mean vectors for each class.
    %        - W: Transformation matrices for each class.
    %   datatest: Test data matrix (features x samples).
    % Output:
    %   labeltest: Predicted labels for the test data.

    % Step 1: Extract model parameters
    userlabel = mdl.userlabel; % Unique class labels
    nfeature = mdl.nfeature;   % Number of features (principal components)
    Mu = mdl.Mu;               % Mean vectors for each class
    C = numel(userlabel);      % Number of classes
    W = mdl.W;                 % Transformation matrices for each class

    % Step 2: Initialize the distance matrix
    dn = zeros(C, size(datatest, 2)); % Distance matrix (classes x samples)

    % Step 3: Loop through each class
    for i = 1:C
        % Step 4: Normalize the test data by subtracting the class mean
        Xn = datatest - repmat(Mu(:, i), 1, size(datatest, 2));

        % Step 5: Compute the distance in the transformed space
        if nfeature == 1
            % For a single feature, compute the squared distance
            dn(i, :) = ((W(:, :, i)' * Xn).^2);
        else
            % For multiple features, compute the sum of squared distances
            dn(i, :) = sum((W(:, :, i)' * Xn).^2);
        end
    end

    % Step 6: Assign the predicted label based on the minimum distance
    [~, labeltest] = min(dn); % Find the class with the minimum distance for each sample
end