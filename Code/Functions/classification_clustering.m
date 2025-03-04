%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================= E-mail: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

function [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT, typeNSC, KFold] = classification_clustering(...
    inputc, Lab, Lals, inputCC, Classify, Cluster, Cluster1, Nneigh, Iterkmean, diskmean, Kfold, KernalSVM, ...
    Bay, MKnn, Knndist, learnfun, learnR, epoc, Nonedim, maxf, NNue, weights, activefun, val, lfmlp, TFun, ...
    maxfmlp, epocmlp, NNhmlp, NNhmlp1, NNhmlp2, cent, nrbf, sigm, typ, p8, p10, p11, p12, p21, p22, p29, p30, ...
    p31, p32, p33, Numhl, lda, Nonedim1, Nonedim2, Epoch, Eta, Tau, Sig, ax5, ax6, ax9, ax10, ...
    reduct, redfeat, redfeat1, Nfeat, Nfeat1, Nfeat2, alpha, bin, cm, CM)
% This function performs classification or clustering on the input data based on user-selected parameters.
% It supports various classification and clustering algorithms and evaluates their performance using k-fold cross-validation.

% Initialize output variables
Perfomance = 0; PerfomanceTotal = 0; typeNSC = ''; PerfomanceT = 0; PerfomanceTotalT = 0;

% Retrieve user inputs from the GUI
Vinputc = get(inputCC, 'value'); VCC = get(Classify, 'Value'); val = get(val, 'value');
VKmdist = get(diskmean, 'Value'); sKmdist = get(diskmean, 'String'); typKmdist = sKmdist(VKmdist);
sSVM = get(KernalSVM, 'String'); VSVM = get(KernalSVM, 'Value'); typeSVM = sSVM(VSVM);
sBay = get(Bay, 'String'); VBay = get(Bay, 'Value'); typeBay = sBay(VBay); sKnn = get(MKnn, 'String');
VKnn = get(MKnn, 'Value'); typeKnn = sKnn(VKnn); sKdist = get(Knndist, 'String'); VKdist = get(Knndist, 'Value');
typeKdist = sKdist(VKdist); slvq = get(learnfun, 'String'); Vlvq = get(learnfun, 'Value');
typelvq = slvq(Vlvq); Velm = get(weights, 'Value'); Velm1 = get(activefun, 'Value');
slfmlp = get(lfmlp, 'String'); Vlfmlp = get(lfmlp, 'Value'); tlfmlp = slfmlp(Vlfmlp);
sTFun = get(TFun, 'String'); VTFun = get(TFun, 'Value'); tTFun = sTFun(VTFun); Vcent = get(cent, 'Value');

% Retrieve numerical parameters from the GUI
KFold = str2double(get(Kfold, 'String')); Alpha = str2double(get(alpha, 'String'));
Bin = str2double(get(bin, 'String')); NumNneigh = str2double(get(Nneigh, 'String'));
Itkm = str2double(get(Iterkmean, 'String')); epoc = str2double(get(epoc, 'String'));
learnr = str2double(get(learnR, 'String')); Nonedim = str2double(get(Nonedim, 'String'));
maxf = str2double(get(maxf, 'String')); nfeature = str2double(get(Nfeat, 'String'));
NNue = str2double(get(NNue, 'String')); maxfm = str2double(get(maxfmlp, 'String'));
Numh = str2double(get(Numhl, 'String')); epocm = str2double(get(epocmlp, 'String'));
NNh = str2double(get(NNhmlp, 'String')); NNh1 = str2double(get(NNhmlp1, 'String'));
NNh2 = str2double(get(NNhmlp2, 'String')); rbf = str2double(get(nrbf, 'String')); ValF = get(redfeat1, 'value');
sigma = str2double(get(sigm, 'String')); ty = get(typ, 'Value'); slda = get(lda, 'String'); Vlda = get(lda, 'Value'); tlda = slda(Vlda);

% Clear the plots in the GUI axes
subplot(1, 1, 1, 'replace', 'Parent', ax9); subplot(1, 1, 1, 'replace', 'Parent', ax10);
subplot(1, 1, 1, 'replace', 'Parent', ax5); subplot(1, 1, 1, 'replace', 'Parent', ax6);

% Validate user inputs
if Vinputc == 1
    msgbox('Please Select Input in Block Classification & Clustering', '', 'warn'); return;
end
if get(Lals, 'value') == 1
    msgbox('Please Select Labels in Block Classification & Clustering', '', 'warn'); return;
end
if VCC == 1
    msgbox('Select Classification OR Clustering', '', 'warn'); return;
end
if isnan(KFold) || (KFold < 1)
    msgbox('Please Enter Number KFold > 1 ', '', 'warn'); return;
end
if isnan(nfeature) || (nfeature > size(inputc, 2)) || (nfeature < 1)
    msgbox(['Please Enter Number features;  0 < Number features < ' num2str(size(inputc, 2))], '', 'warn'); return;
end

% Prepare the labels for classification or clustering
if size(Lab, 1) < size(Lab, 2)
    Lab = Lab';
end
if size(Lab, 2) == 1
    Label = zeros(size(Lab)); LL = unique(Lab);
    for i = 1:length(LL)
        Label(Lab == LL(i)) = i;
    end
else
    Lab = vec2ind(Lab'); Label = zeros(size(Lab)); LL = unique(Lab);
    for i = 1:length(LL)
        Label(Lab == LL(i)) = i;
    end
    Lab = Lab';
end
if (length(LL) >= length(Lab) / 2) || (length(LL) == 1)
    msgbox('Please Select Labels Properly ', '', 'warn'); return;
end
if size(inputc, 1) ~= size(Lab, 1)
    Lab = Lab(1:length(inputc), :);
end

% Handle dimensionality reduction settings
if get(reduct, 'value') == 2
    set(Nfeat1, 'enable', 'off'); set(Nfeat2, 'enable', 'off'); set(alpha, 'enable', 'off');
    set(bin, 'enable', 'off'); set(redfeat1, 'enable', 'off'); set(redfeat, 'enable', 'on');
elseif get(reduct, 'value') == 3
    set(Nfeat1, 'enable', 'on'); set(Nfeat2, 'enable', 'on'); set(alpha, 'enable', 'on');
    set(bin, 'enable', 'on'); set(redfeat1, 'enable', 'on'); set(redfeat, 'enable', 'off');
end

% Perform classification or clustering based on the user's choice
if VCC == 2
    % Classification
    set(Cluster, 'Visible', 'On'); set(Cluster1, 'Visible', 'Off'); set(p21, 'Visible', 'Off');
    set(p22, 'Visible', 'Off');
    sclasify = get(Cluster, 'String'); Vclasify = get(Cluster, 'Value'); typeNSC = sclasify(Vclasify);
    if Vclasify == 1
        msgbox('Select Classification Type', '', 'warn'); return;
    end

    if strcmp(typeNSC, 'MLP')
        % Multi-Layer Perceptron (MLP)
        set(p10, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p33, 'Visible', 'On');
        set(p32, 'Visible', 'Off'); set(p31, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(NNhmlp, 'Visible', 'Off'); set(NNhmlp1, 'Visible', 'Off'); set(NNhmlp2, 'Visible', 'Off'); set(p8, 'Visible', 'Off');
        if Numh == 1
            set(NNhmlp, 'Visible', 'On'); NN = NNh; set(NNhmlp2, 'Visible', 'Off'); set(NNhmlp1, 'Visible', 'Off');
            if isnan(NNh)
                msgbox('Please Enter Number Neurons Layer 1', '', 'warn'); return;
            end
        elseif Numh == 2
            set(NNhmlp1, 'Visible', 'On'); NN = [NNh NNh1]; set(NNhmlp, 'Visible', 'On'); set(NNhmlp2, 'Visible', 'Off');
            if isnan(NNh)
                msgbox('Please Enter Number Neurons Layer 1', '', 'warn'); return;
            end
            if isnan(NNh1)
                msgbox('Please Enter Number Neurons Layer 2', '', 'warn'); return;
            end
        elseif Numh == 3
            set(NNhmlp2, 'Visible', 'On'); NN = [NNh NNh1 NNh2]; set(NNhmlp1, 'Visible', 'On'); set(NNhmlp, 'Visible', 'On');
            if isnan(NNh)
                msgbox('Please Enter Number Neurons Layer 1', '', 'warn'); return;
            end
            if isnan(NNh1)
                msgbox('Please Enter Number Neurons Layer 2', '', 'warn'); return;
            end
            if isnan(NNh2)
                msgbox('Please Enter Number Neurons Layer 3', '', 'warn'); return;
            end
        end
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = MLP(inputc, KFold, Label, epocm, maxfm, ...
            Numh, NN, tlfmlp, tTFun, reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'SVM')
        % Support Vector Machine (SVM)
        set(p10, 'Visible', 'On'); set(p11, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off'); set(Bay, 'Value', 1);
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = SVM(inputc, KFold, Label, typeSVM, ...
            reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'Baysian')
        % Naive Bayes
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'On'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off'); set(KernalSVM, 'Value', 1);
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = Bayesian(inputc, KFold, Label, typeBay, ...
            reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'KNN')
        % K-Nearest Neighbors (KNN)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'On'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = KNN(inputc, KFold, Label, typeKnn, ...
            typeKdist, NumNneigh, reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'LVQ')
        % Learning Vector Quantization (LVQ)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'On');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = LVQ(inputc, KFold, Label, typelvq, ...
            learnr, epoc, Nonedim, maxf, reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'LDA')
        % Linear Discriminant Analysis (LDA)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'On');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = LDA(inputc, KFold, Label, tlda, ...
            reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'RBF')
        % Radial Basis Function (RBF)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'On'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'On'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = RBF(inputc, KFold, Label, rbf, Vcent, ...
            reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'PNN')
        % Probabilistic Neural Network (PNN)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'On');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = PNN(inputc, KFold, Label, sigma, val, ty, ...
            reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'ELM')
        % Extreme Learning Machine (ELM)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'On'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = ELM(inputc, KFold, Label, Velm, Velm1, NNue, ...
            reduct, nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'PCA')
        % Principal Component Analysis (PCA)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = PCA(inputc, KFold, Label, reduct, ...
            nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    elseif strcmp(typeNSC, 'DT')
        % Decision Tree (DT)
        set(p10, 'Visible', 'Off'); set(p12, 'Visible', 'Off'); set(p11, 'Visible', 'Off'); set(p32, 'Visible', 'Off');
        set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p30, 'Visible', 'Off'); set(p29, 'Visible', 'Off');
        set(p8, 'Visible', 'Off');
        [Perfomance, PerfomanceTotal, PerfomanceT, PerfomanceTotalT] = DT(inputc, KFold, Label, reduct, ...
            nfeature, redfeat, ValF, Nfeat1, Nfeat2, Alpha, Bin, cm, CM, ax5, ax6, ax9, ax10);
    end
elseif VCC == 3
    % Clustering
    set(Cluster, 'Visible', 'Off'); set(p29, 'Visible', 'Off'); set(Cluster1, 'Visible', 'On'); set(Cluster, 'Value', 1);
    set(p31, 'Visible', 'Off'); set(p33, 'Visible', 'Off'); set(p32, 'Visible', 'Off'); set(p8, 'Visible', 'Off'); set(p30, 'Visible', 'Off');
    set(Cluster1, 'string', {'Select Clustering Type:'; 'SOFM'; 'K-Means'; 'FCM'}); set(p10, 'Visible', 'Off'); set(p11, 'Visible', 'Off');
    set(p12, 'Visible', 'Off'); sclasify = get(Cluster1, 'String'); Vclasify = get(Cluster1, 'Value'); typeNSC = sclasify(Vclasify);
    if strcmp(typeNSC, 'Kmeans')
        % K-Means Clustering
        set(p21, 'Visible', 'On'); set(p22, 'Visible', 'Off');
        if isnan(Itkm)
            msgbox('Please Enter Number Iteration', '', 'warn'); return;
        end
        [idx, ~] = kmeans(inputc, NumClass, 'MaxIter', Itkm, 'Distance', char(typKmdist));
        aa = (Label - idx); aa = aa(aa == 0); accuracy = (length(aa) / length(idx)) * 100;
        disp('accuracy kmeans:'); disp(accuracy);
    elseif strcmp(typeNSC, 'FCM')
        % Fuzzy C-Means Clustering
        set(p21, 'Visible', 'On'); set(p22, 'Visible', 'Off');
        options = [2 Itkm NaN 0]; [~, U] = fcm(inputc, NumClass, options); [~, index] = max(U); aa = (Label - index'); aa = aa(aa == 0);
        accuracy = (length(aa) / length(U)) * 100; disp('accuracy fcm:'); disp(accuracy);
    end
end
end