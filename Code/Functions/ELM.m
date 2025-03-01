function [Perfomance,PerfomanceTotal,PerfomanceT,PerfomanceTotalT] = ELM(inputc,KFold,Label,Velm,...
 Velm1,NNue,reduct,nfeature,redfeat,ValF,Nfeat1,Nfeat2,Alpha,Bin,cm,CM,ax5,ax6,ax9,ax10)

nclass=length(unique(Label));Indx=cvpartition(Label,'k',KFold);Reduct=get(reduct,'value');
ReductT=get(redfeat,'value');LAb=Label;Label=full(ind2vec(Label'));

Perfomance=zeros(KFold,3);PerfomanceTotal=zeros(KFold,6);PerfomanceT=zeros(KFold,3);
PerfomanceTotalT=zeros(KFold,6);INtr=cell(KFold,1);INte=INtr;nTrainData=zeros(KFold,nclass);
nTestData=nTrainData;U=cell(KFold,1);U1=U;Kfol=cell(KFold,1);
Kf=cell(1,KFold+1);Kf{1}='Real';y=cell(1,nclass);


if isnan(NNue)||(NNue<1);msgbox('Please Enter Number Neurons >1','','warn');return;end
% hWait = waitbar(0,'Please wait....');hPatch = findobj(hWait,'Type','Patch');
% set(hPatch,'FaceColor','g','EdgeColor','k');set(hWait,'windowstyle','modal') 
for i = 1:3
%     message = sprintf('KFold %d of %d. Please wait Training and Test your data',i,KFold);
%     waitbar(i / KFold, hWait, message)
    trIdx = Indx.training(i);teIdx = Indx.test(i);
    TrainInputs=inputc(trIdx,:)';TrainTargets=Label(:,trIdx);
    TestInputs=inputc(teIdx,:)';labelTargetTest=vec2ind(Label(:,teIdx));
    %% dimension reduction PCA OR LDA
    LTargets=LAb(trIdx,:)';
    if Reduct==2
        if ReductT==1
            W = pca_feature(TrainInputs,nfeature);
        elseif ReductT==2
            if isnan(nfeature)||(nfeature>=nclass);msgbox(['Please Enter Number features;  0 < Number features < ' num2str(nclass)],'','warn');return;end
            W = lda_feature(TrainInputs,LTargets,nfeature);
        end
         TrainInputs=W'*TrainInputs;TestInputs=W'*TestInputs;
    elseif Reduct==3
        ind=feature_selction(TrainInputs,LTargets,Alpha,Bin,ValF);
        if ind==0;return;end;Kfol(i)={['KFold',num2str(i)]};U(i)={ind};U1(i)={ind(1:nfeature)};
        Nfeat1.ForegroundColor='r';Nfeat2.ForegroundColor='m';
        TrainInputs=TrainInputs(ind(1:nfeature),:);TestInputs=TestInputs(ind(1:nfeature),:);
    end
    TrainInputs=[-ones(1,size(TrainInputs,2));TrainInputs];QQ=size(TrainInputs,1);%#ok
    TestInputs=[-ones(1,size(TestInputs,2));TestInputs];%#ok
    %% ELM
    if Velm==1;w=randn(NNue,QQ)*0.01;else;w=rand(NNue,QQ);end
    H=w*TrainInputs;H=[-ones(1,size(H,2));tanh(H)];Hsinv=(H*H')\H;beta=(Hsinv*TrainTargets')';
    % train
    for j=1:nclass;nTrainData(i,j)=length(find(LAb(trIdx,:)==j));end
    v=beta*H;if isnan(v);msgbox('Please Select randn','','warn');return;end%warning('off');
    if Velm1==1;labeltrain=vec2ind(1./(1+exp(-2*v)));else;labeltrain=vec2ind(v);end;INtr{i}=labeltrain;
    [AccT,SenT,SpeT,PreT,FmT,MCCT,~] = confusion_matrix(vec2ind(TrainTargets),labeltrain);
    PerfomanceT(i,:)=[AccT SenT SpeT];PerfomanceTotalT(i,:)=[AccT SenT SpeT PreT FmT MCCT];
    % Test
    for j=1:nclass;nTestData(i,j)=length(find(LAb(teIdx,:)==j));end
    H=w*TestInputs;H=[-ones(1,size(H,2));tanh(H)];v=beta*H;%warning('off');
    if isnan(v);msgbox('Please Select randn','','warn');return;end
    if Velm1==1;label=vec2ind(1./(1+exp(-2*v)));else;label=vec2ind(v);end;INte{i}=label; 
    [Acc,Sen,Spe,Pre,Fm,MCC,~] = confusion_matrix(labelTargetTest,label);
    Perfomance(i,:)=[Acc Sen Spe];PerfomanceTotal(i,:)=[Acc Sen Spe Pre Fm MCC];
    Kf{i+1}=['Kfold' num2str(i)];warning('off')
end
if Reduct==3;set(Nfeat1,'Data',cell2mat(U),'RowName',Kfol);set(Nfeat2,'Data',cell2mat(U1),'RowName',Kfol);end
for i=1:nclass;y{i}=['Class' num2str(i)];end;% delete(hWait);
%% train Kfold & Partition
pos1 = [0.1 0.2 0.8 0.7];b=0;p(1)=subplot('Position',pos1,'Parent',ax5);
PP(1)=plot(p(1),vec2ind(TrainTargets),'k--','Linewidth',1);hold on;
for i=1:KFold;PP(i+1)=plot(p(1),INtr{i}+b,'.','MarkerSize',12);b=b+0.03;end%#ok
til=legend(p(1),Kf,'Location','best');p(1).YLim=[1 nclass+b];title(til,'Traning')
ylabel(p(1),{'Predict Classes in'; 'each Kfold (ELM)'});xlabel(p(1),'Sample');p(1).YTick=1:nclass;
p(1).FontName='Times New Roman';p(1).FontWeight='bold';p(1).XLim=[0 length(INtr{1})];
p(2)=subplot('Position',pos1,'Parent',ax6);bar(nTrainData);til=legend(p(2),y,'Location','best');
xlabel(p(2),'KFold');ylabel(p(2),'Number Samples');title(til,'Traning')
p(2).YGrid='on';p(2).FontName='Times New Roman';p(2).FontWeight='bold';
%% test
pos1 = [0.1 0.2 0.8 0.7];b=0;p(3)=subplot('Position',pos1,'Parent',ax9);
PP(numel(PP)+1)=plot(p(3),labelTargetTest,'k--','Linewidth',1);hold on;nP=numel(PP);
for i=1:KFold;PP(i+nP)=plot(p(3),INte{i}+b,'.','MarkerSize',12);b=b+0.05;end
til=legend(p(3),Kf,'Location','best');ylabel(p(3),{'Predict Classes in'; 'each Kfold (ELM)'});
xlabel(p(3),'Sample');p(3).YTick=1:nclass;p(3).YLim=[1 nclass+b];title(til,'Test')
p(3).FontName='Times New Roman';p(3).FontWeight='bold';p(3).XLim=[0 length(INte{1})];
p(4)=subplot('Position',pos1,'Parent',ax10);bar(nTestData);til=legend(p(4),y,'Location','best');
xlabel(p(4),'KFold');ylabel(p(4),'Number Samples');title(til,'Test')
p(4).YGrid='on';p(4).FontName='Times New Roman';p(4).FontWeight='bold';
set(p,'uicontextmenu',cm);set(PP,'uicontextmenu',CM)
% [a,b,t]=roc(labelTargetTest'),(ind2vec(label'))
end

