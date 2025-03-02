%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Function to perform feature selection based on a specified method
function ind = feature_selction(TrainInputs, TrainTargets, Alpha, nbins, Val)
    % Get the number of features
    N = size(TrainInputs, 1);
    
    % Initialize an array to store p-values or scores
    P = nan(1, N);
    
    % Initialize the output index array
    ind = 0;
    
    % Get unique class labels
    nclass = unique(TrainTargets);
    
    % Perform feature selection based on the specified method (Val)
    if Val == 1
        % Method 1: Two-sample t-test (only for 2 classes)
        if length(nclass) > 2
            msgbox('This Method for 2 classes', '', 'warn');
            return;
        end
        
        % Initialize an array to store hypothesis test results
        H = nan(1, N);
        
        % Loop through each feature
        for j = 1:N
            % Perform a two-sample t-test between the two classes
            [H(j), P(j)] = ttest2(TrainInputs(j, TrainTargets == nclass(1)), ...
                              TrainInputs(j, TrainTargets == nclass(2)), ...
                              'Alpha', Alpha);
        end
        
        % Sort features based on p-values in ascending order
        [~, ind] = sort(P, 'ascend');
        
        % Optional: Remove features that fail the hypothesis test (H == 0)
        % I = find(H == 0);
        % ind(I) = [];
        
    elseif Val == 2
        % Method 2: One-way ANOVA (for multiple classes)
        for j = 1:N
            % Perform ANOVA for each feature
            P(j) = anova1(TrainInputs(j, :), TrainTargets, 'off');
        end
        
        % Sort features based on p-values in ascending order
        [~, ind] = sort(P, 'ascend');
        
    elseif Val == 3
        % Method 3: Mutual Information (MI) based feature selection
        MI = mi_feature(TrainInputs, TrainTargets, nbins);
        
        % Sort features based on MI scores in descending order
        [~, ind] = sort(MI, 'descend');
        
    elseif Val == 4
        % Method 4: Fisher's Discriminant Ratio (FDR) based feature selection
        fdr = FDR_Feature(TrainInputs, TrainTargets);
        
        % Sort features based on FDR scores in descending order
        [~, ind] = sort(fdr, 'descend');
    end
end