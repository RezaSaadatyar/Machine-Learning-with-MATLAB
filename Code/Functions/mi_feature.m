function MI = mi_feature(TrainInputs,TrainTargets,nbins)
N= size(TrainInputs,2);MI=zeros(1,size(TrainInputs,1));
hy=hist(TrainTargets,nbins);py=hy/N ;
for i=1:size(TrainInputs,1)
    %%  step 1: calculate histogram of x & y, hx,hy, px,py
    hx= hist(TrainInputs(i,:),nbins);px=hx/N ;
    %% step 3: calculate bivariate histogram of x & y, hxy
    X=[TrainInputs(i,:)',TrainTargets'];hxy=hist3(X,[nbins,nbins]);
    %% step 4: calculate jonit pdf of x & y, pxy
    pxy_joint= hxy/N;pxy_indep= px'*py;
    tp= pxy_joint.* log2(pxy_joint./pxy_indep );
%     MI(i)=nansum(tp(:));%     index= isnan(tp)==0;MI(i)=sum(tp(index));
    I=isnan(tp);tp(I)=[];I=isinf(tp);tp(I)=[];MI(i)=sum(tp(:));
end
end
