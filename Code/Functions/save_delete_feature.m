function [FVal,Fstr,SW,SS] = save_delete_feature(Data,FVal,Fstr,SW,SS,Input,inputf,list2,Chi,Chj, ...
    input,delete,ax2,cm,CM,cmm)
if Data==0;msgbox('Please Load Data in Block Load Data','Error Load Data','error');return;end
if get(inputf,'value')==1;msgbox('Please Select Input Type in Block Feature Extraction','','warn');return;end
if strcmp(get(list2,'string'),'Selection');msgbox('Please Save Feature','Warning','warn');return;end
Vchi=str2double(get(Chi,'string'));Vchj=str2double(get(Chj,'string'));Slist=get(list2,'string');
Valist=get(list2,'value');typlist=Slist(Valist);subplot(1,1,1,'replace','Parent',ax2);
SInput=get(input,'String');VInput=get(input,'value');VSInput=SInput(VInput);
delval=get(delete,'value');
if delval==1 ;if ~isempty(FVal);FVal(Valist)=[];Fstr(Valist)=[];SW(Valist)=[];SS(Valist)=[];end;Valist=1;
    if size(FVal,2)==0;set(list2,'string','Selection');else;set(list2,'value',1);
        set(list2,'string',Fstr); Slist=get(list2,'string');typlist=Slist(Valist);
    end
    set(delete,'value',0);
end
if size(FVal,2)~=0
    plot_time_domain_features(Data,Input,FVal,SW,SS,Valist,VSInput,VInput,SInput,typlist,Vchi,Vchj, ...
        ax2,cm,CM,cmm);
else
    FVal=[];Fstr=[];SW=[];SS=[];subplot(1,1,1,'replace','Parent',ax2)
end
end