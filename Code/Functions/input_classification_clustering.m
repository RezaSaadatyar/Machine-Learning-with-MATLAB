function Input_classification = input_classification_clustering(Input,DataFilter,FVal,InputWRecons,...
inputCC,NSC,Lals,Cluster,Cluster1,Classify,Nfeat,ax5,ax6,ax7,ax8,ax9,ax10,ax11,ax12)

Input_classification=0;set(Cluster,'Value',1);set(Classify,'Value',1);set(Cluster1,'Value',1);
[fb,bb]=size(FVal); if bb~=0;u=[];for i=1:fb;u=[u cell2mat(FVal(i))];end;inputF=u;else;inputF=0;end%#ok
Sinputc=get(inputCC,'string');Vinputc=get(inputCC,'value');
subplot(1,1,1,'replace','Parent',ax5);subplot(1,1,1,'replace','Parent',ax6);
subplot(1,1,1,'replace','Parent',ax7);subplot(1,1,1,'replace','Parent',ax8);
subplot(1,1,1,'replace','Parent',ax9);subplot(1,1,1,'replace','Parent',ax10);
subplot(1,1,1,'replace','Parent',ax11);subplot(1,1,1,'replace','Parent',ax12);

if Vinputc==1;msgbox('Please Select Input in Block Classification & Clustring','Warning','warn');return;end
if Vinputc==2;Input_classification=Input;elseif Vinputc==3;Input_classification=DataFilter;elseif Vinputc==4;Input_classification=inputF;
else;Input_classification=InputWRecons;end;set(NSC,'value',1,'string','Select Ch:');set(Lals,'value',1);
if Input_classification==0;if Vinputc~=5;msgbox(['Please Load',Sinputc(Vinputc)],'','warn');return;end;end
set(Nfeat,'string',num2str(size(Input_classification,2)));
end