%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================= E-mail: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to train a PCA-based classification model
function mdl = pca_train(TrainInputs, TrainTargets, nfeature)
    % Inputs:
    %   TrainInputs: Input data matrix (features x samples).
    %   TrainTargets: Target labels for each sample.
    %   nfeature: Number of features (principal components) to retain.
    % Output:
    %   mdl: A trained PCA model containing:
    %        - W: Transformation matrices for each class.
    %        - Mu: Mean vectors for each class.
    %        - userlabel: Unique class labels.
    %        - nfeature: Number of features (principal components).

    % Step 1: Get unique class labels and the number of classes
    userlabel = unique(TrainTargets); % Unique class labels
    C = numel(userlabel);             % Number of classes

    % Step 2: Initialize the mean vectors matrix
    Mu = zeros(size(TrainInputs, 1), C); % Mean vectors for each class

    % Step 3: Loop through each class
    for i = 1:C
        % Step 4: Extract data for the current class
        Xc = TrainInputs(:, TrainTargets == userlabel(i)); % Data for the current class

        % Step 5: Perform PCA on the current class data
        W(:, :, i) = pca_feature(Xc, nfeature); % Transformation matrix for the current class

        % Step 6: Compute the mean vector for the current class
        Mu(:, i) = mean(Xc, 2); % Mean vector for the current class
    end

    % Step 7: Store the trained model parameters
    mdl.W = W;               % Transformation matrices for each class
    mdl.Mu = Mu;             % Mean vectors for each class
    mdl.userlabel = userlabel; % Unique class labels
    mdl.nfeature = nfeature; % Number of features (principal components)
end