%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ======================================= 2018-2019 ============================================

% Main function for Extreme Learning Machine (ELM) implementation
function [Perfomance,PerfomanceTotal,PerfomanceT,PerfomanceTotalT] = ELM(inputc,KFold,Label,Velm,...
 Velm1,NNue,reduct,nfeature,redfeat,ValF,Nfeat1,Nfeat2,Alpha,Bin,cm,CM,ax5,ax6,ax9,ax10)

% Number of unique classes in the dataset
nclass = length(unique(Label));

% Cross-validation partitioning
Indx = cvpartition(Label,'k',KFold);

% Get the value of dimensionality reduction method
Reduct = get(reduct,'value');

% Get the value of feature reduction method
ReductT = get(redfeat,'value');

% Store the original labels
LAb = Label;

% Convert labels to one-hot encoding
Label = full(ind2vec(Label'));

% Initialize performance matrices
Perfomance = zeros(KFold,3);
PerfomanceTotal = zeros(KFold,6);
PerfomanceT = zeros(KFold,3);
PerfomanceTotalT = zeros(KFold,6);

% Initialize cell arrays for storing training and testing indices
INtr = cell(KFold,1);
INte = INtr;

% Initialize matrices for storing number of training and testing samples
nTrainData = zeros(KFold,nclass);
nTestData = nTrainData;

% Initialize cell arrays for storing intermediate results
U = cell(KFold,1);
U1 = U;
Kfol = cell(KFold,1);
Kf = cell(1,KFold+1);
Kf{1} = 'Real';
y = cell(1,nclass);

% Check if the number of neurons is valid
if isnan(NNue) || (NNue < 1)
    msgbox('Please Enter Number Neurons >1','','warn');
    return;
end

% Loop through each fold of the cross-validation
for i = 1:KFold
    % Get training and testing indices for the current fold
    trIdx = Indx.training(i);
    teIdx = Indx.test(i);
    
    % Prepare training and testing data
    TrainInputs = inputc(trIdx,:)';
    TrainTargets = Label(:,trIdx);
    TestInputs = inputc(teIdx,:)';
    labelTargetTest = vec2ind(Label(:,teIdx));
    
    % Store the training labels
    LTargets = LAb(trIdx,:)';
    
    % Perform dimensionality reduction if selected
    if Reduct == 2
        if ReductT == 1
            % Perform PCA feature reduction
            W = pca_feature(TrainInputs,nfeature);
        elseif ReductT == 2
            % Check if the number of features is valid for LDA
            if isnan(nfeature) || (nfeature >= nclass)
                msgbox(['Please Enter Number features;  0 < Number features < ' num2str(nclass)],'','warn');
                return;
            end
            % Perform LDA feature reduction
            W = lda_feature(TrainInputs,LTargets,nfeature);
        end
        % Apply the dimensionality reduction to training and testing data
        TrainInputs = W' * TrainInputs;
        TestInputs = W' * TestInputs;
    elseif Reduct == 3
        % Perform feature selection
        ind = feature_selction(TrainInputs,LTargets,Alpha,Bin,ValF);
        if ind == 0
            return;
        end
        % Store the selected features
        Kfol(i) = {['KFold',num2str(i)]};
        U(i) = {ind};
        U1(i) = {ind(1:nfeature)};
        
        % Update the feature selection display
        Nfeat1.ForegroundColor = 'r';
        Nfeat2.ForegroundColor = 'm';
        
        % Apply the feature selection to training and testing data
        TrainInputs = TrainInputs(ind(1:nfeature),:);
        TestInputs = TestInputs(ind(1:nfeature),:);
    end
    
    % Add bias term to the training and testing data
    TrainInputs = [-ones(1,size(TrainInputs,2)); TrainInputs];
    QQ = size(TrainInputs,1);
    TestInputs = [-ones(1,size(TestInputs,2)); TestInputs];
    
    %% ELM (Extreme Learning Machine)
    % Initialize weights randomly
    if Velm == 1
        w = randn(NNue,QQ) * 0.01;
    else
        w = rand(NNue,QQ);
    end
    
    % Compute hidden layer output
    H = w * TrainInputs;
    H = [-ones(1,size(H,2)); tanh(H)];
    Hsinv = (H * H') \ H;
    beta = (Hsinv * TrainTargets')';
    
    % Count the number of training samples per class
    for j = 1:nclass
        nTrainData(i,j) = length(find(LAb(trIdx,:) == j));
    end
    
    % Compute the output of the ELM for training data
    v = beta * H;
    if isnan(v)
        msgbox('Please Select randn','','warn');
        return;
    end
    
    % Apply activation function to the output
    if Velm1 == 1
        labeltrain = vec2ind(1./(1 + exp(-2 * v)));
    else
        labeltrain = vec2ind(v);
    end
    INtr{i} = labeltrain;
    
    % Compute performance metrics for training data
    [AccT, SenT, SpeT, PreT, FmT, MCCT, ~] = confusion_matrix(vec2ind(TrainTargets), labeltrain);
    PerfomanceT(i,:) = [AccT SenT SpeT];
    PerfomanceTotalT(i,:) = [AccT SenT SpeT PreT FmT MCCT];
    
    % Count the number of testing samples per class
    for j = 1:nclass
        nTestData(i,j) = length(find(LAb(teIdx,:) == j));
    end
    
    % Compute the output of the ELM for testing data
    H = w * TestInputs;
    H = [-ones(1,size(H,2)); tanh(H)];
    v = beta * H;
    
    % Check for NaN values in the output
    if isnan(v)
        msgbox('Please Select randn','','warn');
        return;
    end
    
    % Apply activation function to the output
    if Velm1 == 1
        label = vec2ind(1./(1 + exp(-2 * v)));
    else
        label = vec2ind(v);
    end
    INte{i} = label;
    
    % Compute performance metrics for testing data
    [Acc, Sen, Spe, Pre, Fm, MCC, ~] = confusion_matrix(labelTargetTest, label);
    Perfomance(i,:) = [Acc Sen Spe];
    PerfomanceTotal(i,:) = [Acc Sen Spe Pre Fm MCC];
    
    % Store the fold information
    Kf{i+1} = ['Kfold' num2str(i)];
    warning('off')
end

% Update the feature selection display if feature selection was performed
if Reduct == 3
    set(Nfeat1,'Data',cell2mat(U),'RowName',Kfol);
    set(Nfeat2,'Data',cell2mat(U1),'RowName',Kfol);
end

% Prepare class labels for display
for i = 1:nclass
    y{i} = ['Class' num2str(i)];
end

%% Plot training results
pos1 = [0.1 0.2 0.8 0.7];
b = 0;
p(1) = subplot('Position',pos1,'Parent',ax5);
PP(1) = plot(p(1),vec2ind(TrainTargets),'k--','Linewidth',1);
hold on;

% Plot the predicted classes for each fold
for i = 1:KFold
    PP(i+1) = plot(p(1),INtr{i}+b,'.','MarkerSize',12);
    b = b + 0.03;
end

% Add legend and labels
til = legend(p(1),Kf,'Location','best');
p(1).YLim = [1 nclass+b];
title(til,'Traning');
ylabel(p(1),{'Predict Classes in'; 'each Kfold (ELM)'});
xlabel(p(1),'Sample');
p(1).YTick = 1:nclass;
p(1).FontName = 'Times New Roman';
p(1).FontWeight = 'bold';
p(1).XLim = [0 length(INtr{1})];

% Plot the number of training samples per class
p(2) = subplot('Position',pos1,'Parent',ax6);
bar(nTrainData);
til = legend(p(2),y,'Location','best');
xlabel(p(2),'KFold');
ylabel(p(2),'Number Samples');
title(til,'Traning');
p(2).YGrid = 'on';
p(2).FontName = 'Times New Roman';
p(2).FontWeight = 'bold';

%% Plot testing results
pos1 = [0.1 0.2 0.8 0.7];
b = 0;
p(3) = subplot('Position',pos1,'Parent',ax9);
PP(numel(PP)+1) = plot(p(3),labelTargetTest,'k--','Linewidth',1);
hold on;
nP = numel(PP);

% Plot the predicted classes for each fold
for i = 1:KFold
    PP(i+nP) = plot(p(3),INte{i}+b,'.','MarkerSize',12);
    b = b + 0.05;
end

% Add legend and labels
til = legend(p(3),Kf,'Location','best');
ylabel(p(3),{'Predict Classes in'; 'each Kfold (ELM)'});
xlabel(p(3),'Sample');
p(3).YTick = 1:nclass;
p(3).YLim = [1 nclass+b];
title(til,'Test');
p(3).FontName = 'Times New Roman';
p(3).FontWeight = 'bold';
p(3).XLim = [0 length(INte{1})];

% Plot the number of testing samples per class
p(4) = subplot('Position',pos1,'Parent',ax10);
bar(nTestData);
til = legend(p(4),y,'Location','best');
xlabel(p(4),'KFold');
ylabel(p(4),'Number Samples');
title(til,'Test');
p(4).YGrid = 'on';
p(4).FontName = 'Times New Roman';
p(4).FontWeight = 'bold';

% Set context menus for the plots
set(p,'uicontextmenu',cm);
set(PP,'uicontextmenu',CM);

% End of function
end