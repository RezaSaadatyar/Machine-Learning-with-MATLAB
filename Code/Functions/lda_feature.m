function W = lda_feature(TrainInputs,TrainTargets,nfeature)
% m<= C-1, C= number of class
N= size(TrainInputs,2);d= size(TrainInputs,1);
mt= mean(TrainInputs,2);SW= zeros(d,d);SB= zeros(d,d);
userlabel= unique(TrainTargets);C= numel(userlabel);%number of class
for i=1:C
    ind= find(TrainTargets==userlabel(i));Xc= TrainInputs(:,ind);
    si=cov(Xc');mi=mean(Xc,2);ni=numel(ind)/N;SW=SW+si;SB=SB+(ni*(mi-mt)*(mi-mt)'); 
end
%% step 4: eigen value decomposition
[U,D]= eig(SB,SW);% [U,D]= eig(inv(SW)*SB);
%% step 5: sort eignen vectors according to eigen valuse
D= diag(D);[~,ind]= sort(D,'descend');U= U(:,ind);
%% step 6: select best eigen vectors
W= U(:,1:nfeature);
end
