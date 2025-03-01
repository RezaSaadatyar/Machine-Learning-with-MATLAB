function fdr = FDR_Feature(TrainInputs,TrainTargets)
userlabel=unique(TrainTargets);NumClass=numel(userlabel);fdr=nan(1,size(TrainInputs,1));
for j=1:size(TrainInputs,1)
    xj= TrainInputs(j,:);mut= mean(xj);nt= numel(xj);tp_num=0;tp_denum=0; 
    for i=1:NumClass
%         ind= find(TrainTargets== userlabel(i)); xi= xj(ind);
        xi=xj(TrainTargets==userlabel(i));mui=mean(xi);ni=numel(xi);pi=ni/nt;
        tp_num=tp_num+(pi*(mui-mut)^2);vi=var(xi);tp_denum=tp_denum +(pi*vi);
    end
    fdr(j)= tp_num / tp_denum;
end
end

