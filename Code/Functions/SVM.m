%% =============================================================================================
% ================================= Machine Learning Software ==================================
% ================================ Presented by: Reza Saadatyar ================================
% ============================== Email: Reza.Saadatyar@outlook.com =============================
% ======================================= 2018-2019 ============================================

% Define the main function for SVM-based classification with cross-validation
function [Perfomance,PerfomanceTotal,PerfomanceT,PerfomanceTotalT] = SVM(inputc,KFold,Label,typeSVM,...
reduct,nfeature,redfeat,ValF,Nfeat1,Nfeat2,Alpha,Bin,cm,CM,ax5,ax6,ax9,ax10)

% Determine the number of unique classes in the dataset
nclass=length(unique(Label));

% Create cross-validation partitions for K-Fold validation
Indx=cvpartition(Label,'k',KFold);

% Get the value of the reduction method (PCA, LDA, or feature selection)
Reduct=get(reduct,'value');

% Get the value of the feature reduction type (PCA or LDA)
ReductT=get(redfeat,'value');

% Initialize matrices to store performance metrics for training and testing
Perfomance=zeros(KFold,3);PerfomanceTotal=zeros(KFold,6);PerfomanceT=zeros(KFold,3);
PerfomanceTotalT=zeros(KFold,6);INtr=cell(KFold,1);INte=INtr;nTrainData=zeros(KFold,nclass);
nTestData=nTrainData;U=cell(KFold,1);U1=U;

% Initialize cell arrays to store K-Fold information
Kf=cell(1,KFold+1);Kf{1}='Real';y=cell(1,nclass);Kfol=cell(KFold,1);

% Define the SVM template with standardization and the specified kernel function
SVM = templateSVM('Standardize',1,'KernelFunction',char(typeSVM));

% Create a waitbar to show progress during K-Fold iterations
hWait = waitbar(0,'Please wait....');hPatch = findobj(hWait,'Type','Patch');
set(hPatch,'FaceColor','g','EdgeColor','k');set(hWait,'windowstyle','modal') 

% Loop through each K-Fold iteration
for i = 1:KFold
    % Update the waitbar with the current K-Fold iteration
    message = sprintf('KFold %d of %d. Please wait Training and Test your data',i,KFold);
    waitbar(i / KFold, hWait, message)
    
    % Get the training and testing indices for the current fold
    trIdx = Indx.training(i);teIdx = Indx.test(i);
    
    % Extract the training and testing data based on the indices
    TrainInputs=inputc(trIdx,:);TrainTargets=Label(trIdx,:);
    TestInputs=inputc(teIdx,:);labelTargetTest=Label(teIdx,:);
    
    %% Dimension reduction using PCA or LDA
    LTargets=Label(trIdx,:)';
    if Reduct==2
         if ReductT==1
             % Perform PCA for feature reduction
             W = pca_feature(TrainInputs',nfeature);
        elseif ReductT==2
            % Check if the number of features is valid for LDA
            if isnan(nfeature)||(nfeature>=nclass);msgbox(['Please Enter Number features;  0 < Number features < ' num2str(nclass)],'','warn');return;end
            % Perform LDA for feature reduction
            W = lda_feature(TrainInputs',LTargets,nfeature);
        end
         % Apply the transformation to the training and testing data
         TrainInputs=(W'*TrainInputs')';TestInputs=(W'*TestInputs')';
    elseif Reduct==3
        % Perform feature selection based on the specified method
        ind = feature_selction(TrainInputs',LTargets,Alpha,Bin,ValF);
        if ind==0;return;end
        % Store the selected features for each fold
        Kfol(i)={['KFold',num2str(i)]};U(i)={ind};U1(i)={ind(1:nfeature)};
        Nfeat1.ForegroundColor='r';Nfeat2.ForegroundColor='m';
        % Apply the selected features to the training and testing data
        TrainInputs=TrainInputs(:,ind(1:nfeature));TestInputs=TestInputs(:,ind(1:nfeature));
    end 
    
    %% Train the SVM model using the ECOC (Error-Correcting Output Codes) framework
    Mdl = fitcecoc(TrainInputs,TrainTargets,'Learners',SVM,'FitPosterior',1,...
        'ClassNames',1:nclass,'Verbose',2);
    
    % Evaluate the model on the training data
    for j=1:nclass;nTrainData(i,j)=length(find(Label(trIdx,:)==j));end
    labeltrain=predict(Mdl,TrainInputs);INtr{i}=labeltrain;
    [AccT,SenT,SpeT,PreT,FmT,MCCT,~] = confusion_matrix(TrainTargets,labeltrain);
    PerfomanceT(i,:)=[AccT SenT SpeT];PerfomanceTotalT(i,:)=[AccT SenT SpeT PreT FmT MCCT];
    
    % Evaluate the model on the testing data
    for j=1:nclass;nTestData(i,j)=length(find(Label(teIdx,:)==j));end
    label=predict(Mdl,TestInputs);INte{i}=label;
    [Acc,Sen,Spe,Pre,Fm,MCC,~] = confusion_matrix(labelTargetTest,label);
    Perfomance(i,:)=[Acc Sen Spe];PerfomanceTotal(i,:)=[Acc Sen Spe Pre Fm MCC]; 
    Kf{i+1}=['Kfold' num2str(i)];
end

% Update the feature selection tables if feature selection was performed
if Reduct==3;set(Nfeat1,'Data',cell2mat(U),'RowName',Kfol);set(Nfeat2,'Data',cell2mat(U1),'RowName',Kfol);end

% Close the waitbar after completing all K-Fold iterations
delete(hWait);for i=1:nclass;y{i}=['Class' num2str(i)];end

%% Plot the training results for each K-Fold
pos1 = [0.1 0.2 0.8 0.7];b=0;p(1)=subplot('Position',pos1,'Parent',ax5);
PP(1)=plot(p(1),TrainTargets,'k--','Linewidth',1);hold on;
for i=1:KFold;PP(i+1)=plot(p(1),INtr{i}+b,'.','MarkerSize',12);b=b+0.03;end%#ok
til=legend(p(1),Kf,'Location','best');title(til,'Training');p(1).YLim=[1 nclass+b];
ylabel(p(1),{'Predict Classes in'; 'each Kfold (SVM)'});xlabel(p(1),'Sample');p(1).YTick=1:nclass;
p(1).FontName='Times New Roman';p(1).FontWeight='bold';p(1).XLim=[0 length(INtr{1})];

% Plot the number of samples in each class for the training data
p(2)=subplot('Position',pos1,'Parent',ax6);bar(nTrainData);til=legend(p(2),y,'Location','best');
xlabel(p(2),'KFold');ylabel(p(2),'Number Samples');title(til,'Training')
p(2).YGrid='on';p(2).FontName='Times New Roman';p(2).FontWeight='bold';

%% Plot the testing results for each K-Fold
pos1 = [0.1 0.2 0.8 0.7];b=0;p(3)=subplot('Position',pos1,'Parent',ax9);
PP(numel(PP)+1)=plot(p(3),labelTargetTest,'k--','Linewidth',1);hold on;nP=numel(PP);
for i=1:KFold;PP(i+nP)=plot(p(3),INte{i}+b,'.','MarkerSize',12);b=b+0.03;end
til=legend(p(3),Kf,'Location','best');ylabel(p(3),{'Predict Classes in'; 'each Kfold (SVM)'});
xlabel(p(3),'Sample');p(3).YTick=1:nclass;p(3).YLim=[1 nclass+b];title(til,'Test')
p(3).FontName='Times New Roman';p(3).FontWeight='bold';p(3).XLim=[0 length(INte{1})];

% Plot the number of samples in each class for the testing data
p(4)=subplot('Position',pos1,'Parent',ax10);bar(nTestData);til=legend(p(4),y,'Location','best');
xlabel(p(4),'KFold');ylabel(p(4),'Number Samples');title(til,'Test')
p(4).YGrid='on';p(4).FontName='Times New Roman';p(4).FontWeight='bold';

% Set the context menu for the plots
set(p,'uicontextmenu',cm);set(PP,'uicontextmenu',CM)
end