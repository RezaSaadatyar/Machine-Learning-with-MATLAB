function ind = feature_selction(TrainInputs,TrainTargets,Alpha,nbins,Val)
N=size(TrainInputs,1);P=nan(1,N);ind=0;nclass=unique(TrainTargets);
if Val==1;if length(nclass)>2;msgbox('This Method for 2 classes','','warn');return;end;H=nan(1,N);
for j=1:N;[H(j),P(j)]=ttest2(TrainInputs(j,TrainTargets==nclass(1)),TrainInputs(j,TrainTargets==nclass(2)),'Alpha',Alpha);end
[~,ind]=sort(P,'ascend');%I=find(H==0);ind(I)=[];
elseif Val==2;for j=1:N;P(j)=anova1(TrainInputs(j,:),TrainTargets,'off');end;[~,ind]=sort(P,'ascend');
elseif Val==3;MI = mi_feature(TrainInputs,TrainTargets,nbins);[~,ind]=sort(MI,'descend');
elseif Val==4;fdr=FDR_Feature(TrainInputs,TrainTargets);[~,ind]=sort(fdr,'descend');
end
end