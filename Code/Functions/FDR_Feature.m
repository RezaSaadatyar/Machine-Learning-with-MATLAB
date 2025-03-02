%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to compute Fisher's Discriminant Ratio (FDR) for feature ranking
function fdr = FDR_Feature(TrainInputs, TrainTargets)
    % Extract unique class labels from the training targets
    userlabel = unique(TrainTargets);
    
    % Determine the number of classes
    NumClass = numel(userlabel);
    
    % Initialize the FDR array with NaN values
    fdr = nan(1, size(TrainInputs, 1));
    
    % Loop through each feature (row) in the training inputs
    for j = 1:size(TrainInputs, 1)
        % Extract the current feature values
        xj = TrainInputs(j, :);
        
        % Compute the mean of the current feature across all samples
        mut = mean(xj);
        
        % Determine the total number of samples
        nt = numel(xj);
        
        % Initialize numerator and denominator for FDR calculation
        tp_num = 0;
        tp_denum = 0;
        
        % Loop through each class
        for i = 1:NumClass
            % Extract the feature values for the current class
            xi = xj(TrainTargets == userlabel(i));
            
            % Compute the mean of the feature for the current class
            mui = mean(xi);
            
            % Determine the number of samples in the current class
            ni = numel(xi);
            
            % Compute the proportion of samples in the current class
            pi = ni / nt;
            
            % Update the numerator for FDR
            tp_num = tp_num + (pi * (mui - mut)^2);
            
            % Compute the variance of the feature for the current class
            vi = var(xi);
            
            % Update the denominator for FDR
            tp_denum = tp_denum + (pi * vi);
        end
        
        % Compute the FDR for the current feature
        fdr(j) = tp_num / tp_denum;
    end
end