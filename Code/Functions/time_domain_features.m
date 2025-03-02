%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function In = time_domain_features(Inputf, typTDom, Lwin, SlidWSize, Vthr)
% This function computes various time-domain features from the input signal based on the selected feature type.
% It supports multiple feature types such as Mean, Median, Standard Deviation, Skewness, Kurtosis, etc.

% Determine the size of the input data
[handles.a, handles.b] = size(Inputf);

% Initialize the output matrix with zeros
In = zeros(handles.a - 1, handles.b);

% Initialize variables for sliding window calculations
b = 0; k = 1; r = 0; j = 0;

% Compute features based on the selected feature type
if strcmp(typTDom, 'Integrate')
    % Integrate the signal over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            a = abs(Inputf(i, :)); b = b + a; In(i, :) = b;
        else
            b = 0; r = Lwin * k - SlidWSize; In(i, :) = abs(Inputf(i, :));
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'Mean')
    % Compute the mean over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = mean(Inputf(1 + j:i, :), 1);
        else
            r = Lwin * k - SlidWSize; In(i, :) = mean(Inputf(i, :), 1); j = i - 1;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'MAD')
    % Compute the median absolute deviation over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = mad(Inputf(1 + j:i, :));
        else
            r = Lwin * k - SlidWSize; In(i, :) = mad(Inputf(i, :)); j = i - 1;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'Median')
    % Compute the median over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = median(Inputf(1 + j:i, :), 1);
        else
            r = Lwin * k - SlidWSize; In(i, :) = median(Inputf(i, :), 1); j = i - 1;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'Std')
    % Compute the standard deviation over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = std(Inputf(1 + j:i, :), 0, 1);
        else
            r = Lwin * k - SlidWSize; In(i, :) = std(Inputf(i, :), 0, 1); j = i - 1;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'Skewness')
    % Compute the skewness over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = skewness(Inputf(1 + j:i, :), [], 1); In(isnan(In)) = 0;
        else
            r = Lwin * k - SlidWSize; j = i - 1;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'Kurtosis')
    % Compute the kurtosis over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = kurtosis(Inputf(1 + j:i, :), [], 1); In(isnan(In)) = 0;
        else
            r = Lwin * k - SlidWSize; j = i - 1;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'MAV')
    % Compute the mean absolute value over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = (sum(abs(Inputf(1 + j:i, :)), 1)) ./ (length(j:i) - 1);
        else
            j = i - 1; r = Lwin * k - SlidWSize; In(i, :) = abs(Inputf(i, :));
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'V-Order3')
    % Compute the third-order variance over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = ((sum((abs(Inputf(j + 1:i, :))) .^ 3, 1)) ./ (length(j:i) - 1)) .^ (1 / 3);
        else
            j = i - 1; r = Lwin * k - SlidWSize; In(i, :) = abs(Inputf(i, :));
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'MMAV')
    % Compute the modified mean absolute value over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            if (0.25 * Lwin + r <= i) && (i <= 0.75 * Lwin + r)
                In(i, :) = (sum(abs(Inputf(1 + j:i, :)), 1)) ./ (length(j:i) - 1);
            else
                In(i, :) = (sum(0.5 .* abs(Inputf(1 + j:i, :)), 1)) ./ (length(j:i) - 1);
            end
        else
            j = i - 1; r = Lwin * k - SlidWSize;
            if (0.25 * Lwin + r <= i) && (i <= 0.75 * Lwin + r)
                In(i, :) = abs(Inputf(i, :));
            else
                In(i, :) = 0.5 * abs(Inputf(i, :));
            end
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'SSI')
    % Compute the simple square integral over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            a = abs(Inputf(i, :)) .^ 2; b = b + a; In(i, :) = b;
        else
            b = 0; r = Lwin * k - SlidWSize; a = abs(Inputf(i, :)) .^ 2; b = b + a; In(i, :) = b;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'VAR')
    % Compute the variance over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = var(Inputf(1 + j:i, :), 0, 1);
        else
            j = i - 1; In(i, :) = var(Inputf(i, :), 0, 1); r = Lwin * k - SlidWSize;
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'RMS') || strcmp(typTDom, 'V-Order2')
    % Compute the root mean square over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r)
            In(i, :) = rms(Inputf(1 + j:i, :), 1);
        else
            j = i - 1; r = Lwin * k - SlidWSize; In(i, :) = rms(Inputf(i, :), 1);
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'WL')
    % Compute the waveform length over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r - 1)
            a = abs(Inputf(i + 1, :) - Inputf(i, :)); b = b + a; In(i, :) = b;
        else
            b = 0; r = Lwin * k - SlidWSize; In(i, :) = abs(Inputf(i, :) - Inputf(i + 1, :));
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'ACC')
    % Compute the average amplitude change over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r - 1)
            a = abs(Inputf(i + 1, :) - Inputf(i, :)); b = b + a; In(i, :) = b ./ (length(j:i) - 1);
        else
            j = i - 1; b = 0; r = Lwin * k - SlidWSize; In(i, :) = abs(Inputf(i, :) - Inputf(i + 1, :));
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'WAMP')
    % Compute the Willison amplitude over a sliding window
    for jj = 1:handles.b
        b = 0; k = 1; r = 0;
        for i = 1:handles.a - 1
            if (1 + r <= i) && (i <= Lwin + r - 1)
                if abs(Inputf(i, jj) - Inputf(i + 1, jj)) > Vthr
                    b = b + 1; In(i, jj) = b;
                else
                    In(i, jj) = b;
                end
            else
                b = 0; r = Lwin * k - SlidWSize;
                if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
                if abs(Inputf(i, jj) - Inputf(i + 1, jj)) > Vthr
                    b = b + 1; In(i, jj) = b;
                else
                    In(i, jj) = b;
                end
            end
        end
    end

elseif strcmp(typTDom, 'MYOP')
    % Compute the myopulse percentage rate over a sliding window
    for jj = 1:handles.b
        b = 0; k = 1; r = 0; j = 0;
        for i = 1:handles.a - 1
            if (1 + r <= i) && (i <= Lwin + r - 1)
                if Inputf(i, jj) > Vthr
                    b = b + 1; In(i, jj) = b / (length(j:i) - 1);
                else
                    In(i, jj) = b / (length(j:i) - 1);
                end
            else
                if Inputf(i, jj) > Vthr
                    b = b + 1; In(i, jj) = b / (length(j:i) - 1);
                else
                    In(i, jj) = b / (length(j:i) - 1);
                end
                j = i - 1; b = 0; r = Lwin * k - SlidWSize;
                if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
            end
        end
    end

elseif strcmp(typTDom, 'ZC')
    % Compute the zero-crossing rate over a sliding window
    for jj = 1:handles.b
        b = 0; k = 1; r = 0;
        for i = 1:handles.a - 1
            if (1 + r <= i) && (i <= Lwin + r - 1)
                if (Inputf(i, jj) * Inputf(i + 1, jj) < 0) && (abs(Inputf(i, jj) - Inputf(i + 1, jj))) > Vthr
                    b = b + 1; In(i, jj) = b;
                else
                    In(i, jj) = b;
                end
            else
                b = 0; r = Lwin * k - SlidWSize;
                if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
                if (Inputf(i, jj) * Inputf(i + 1, jj) < 0) && (abs(Inputf(i, jj) - Inputf(i + 1, jj))) > Vthr
                    b = b + 1; In(i, jj) = b;
                else
                    In(i, jj) = b;
                end
            end
        end
    end

elseif strcmp(typTDom, 'DASDV')
    % Compute the difference absolute standard deviation value over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r - 1)
            a = (Inputf(i + 1, :) - Inputf(i, :)) .^ 2; b = b + a; In(i, :) = sqrt((b + a) ./ (length(j:i) - 1));
        else
            j = i - 1; b = 0; r = Lwin * k - SlidWSize; In(i, :) = sqrt((Inputf(i, :) - Inputf(i - 1, :)) .^ 2);
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'MFL')
    % Compute the maximum fractal length over a sliding window
    for i = 1:handles.a - 1
        if (1 + r <= i) && (i <= Lwin + r - 1)
            a = (Inputf(i + 1, :) - Inputf(i, :)) .^ 2; b = b + a; In(i, :) = log10(sqrt(b));
        else
            b = 0; r = Lwin * k - SlidWSize; a = (Inputf(i, :) - Inputf(i - 1, :)) .^ 2; In(i, :) = log10(sqrt(a));
            if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
        end
    end

elseif strcmp(typTDom, 'SSC')
    % Compute the slope sign change over a sliding window
    for jj = 1:handles.b
        b = 0; k = 1; r = 0;
        for i = 2:handles.a - 1
            if (1 + r <= i) && (i <= Lwin + r - 1)
                if (Inputf(i, jj) - Inputf(i - 1, jj)) * (Inputf(i, jj) - Inputf(i + 1, jj)) > Vthr
                    b = b + 1; In(i - 1, jj) = b;
                else
                    In(i - 1, jj) = b;
                end
            else
                b = 0; r = Lwin * k - SlidWSize;
                if (1 <= k) && (k <= floor(handles.a / Lwin)); k = k + 1; end
                if (Inputf(i, jj) - Inputf(i - 1, jj)) * (Inputf(i, jj) - Inputf(i + 1, jj)) > Vthr
                    b = b + 1; In(i - 1, jj) = b;
                else
                    In(i - 1, jj) = b;
                end
            end
        end
        b = b + 1; In(i, jj) = b;
    end
end
end