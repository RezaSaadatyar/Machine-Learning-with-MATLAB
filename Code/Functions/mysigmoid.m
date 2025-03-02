%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Function to compute the Sigmoid kernel (also known as the Hyperbolic Tangent kernel)
function G = mysigmoid(U, V)
    % Inputs:
    %   U: A matrix of size (m x d), where m is the number of samples and d is the number of features.
    %   V: A matrix of size (n x d), where n is the number of samples and d is the number of features.
    % Output:
    %   G: A matrix of size (m x n) representing the Sigmoid kernel between U and V.

    % Step 1: Define the slope (gamma) and intercept (c) for the Sigmoid kernel
    gamma = 0.5; % Slope parameter
    c = -2;      % Intercept parameter

    % Step 2: Compute the Sigmoid kernel using the tanh function
    G = tanh(gamma * U * V' + c);
end