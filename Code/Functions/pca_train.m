function mdl = pca_train(TrainInputs,TrainTargets,nfeature)
userlabel=unique(TrainTargets);C=numel(userlabel);Mu=zeros(size(TrainInputs,1),C);
for i=1:C
    Xc=TrainInputs(:,TrainTargets==userlabel(i));
    W(:,:,i)=pca_feature(Xc,nfeature);Mu(:,i)=mean(Xc,2);
end
mdl.W=W;mdl.Mu=Mu;mdl.userlabel=userlabel;mdl.nfeature=nfeature;
end


