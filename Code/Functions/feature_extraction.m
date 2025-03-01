function [Inpuf,typTDom,Lwin,SlidWSize] = feature_extraction(Data,DataFilter,Input,ax2,...
inputf,Novelab,TFDomain,Windw,thr,SlidW,TDomain,FDomain,input,Chi,Chj,cm,CM,cmm,display1,...
inputw,inputCC)

Lwin=str2double(get(Novelab,'String'));Inpuf=nan;SlidWSize=0;typTDom='';Inputf=0;
dis=get(display1,'value');subplot(1,1,1,'replace','Parent',ax2);set(inputw,'value',1)
Sinputf=get(inputf,'string');Vinputf=get(inputf,'value');SVinputf=Sinputf(Vinputf);
VFDom=get(TFDomain,'Value');swin=get(Windw,'String');Vwin=get(Windw,'Value');typwin=swin(Vwin);
Vthr=str2double(get(thr,'String'));set(inputCC,'value',1);

if Vinputf==2;Inputf=Input;elseif Vinputf==3;Inputf=DataFilter;end

if dis==1
if Data==0;msgbox('Please Load Data in Block Load Data','Error Load Data','error');return;end
if Vinputf==1;msgbox('Please Select Input in Block Feature Extraction','','warn');return;end
if Inputf==0;msgbox(['Please Load ', SVinputf ],'','warn');return;end
if Vwin==1;msgbox('Please Select Window Type','','warn');return;end
if isnan(Lwin);msgbox('Please Enter Size Window','','warn');return;end
if Lwin>length(Inputf);msgbox(['Should be selected Size Window <',num2str(length(Inputf))],'','warn');return;end
end

if strcmp(typwin,'Non-Overlapping');set(SlidW,'Enable','off');SlidWSize=0;
elseif strcmp(typwin,'Overlapping');set(SlidW,'Enable','on');
SlidWSize=str2double(get(SlidW,'String'));
if dis==1;if isnan(SlidWSize);msgbox('Please Enter Sliding Window','','warn');return;end;end
end

if VFDom==1
    set(FDomain,'Visible','off','value',1);
    set(TDomain,'String',{'Mean';'Std';'Median';'ACC';'DASDV';'MAD';'MAV';'MMAV';'MFL';'MYOP';...
        'Integrate';'RMS';'SSI';'SSC';'ZC';'VAR';'Skewness';'Kurtosis';'V-Order2';...
        'V-Order3';'WAMP';'WL'},'Visible','on');
    sTDom=get(TDomain,'String');VTDom=get(TDomain,'Value');typTDom=sTDom(VTDom);
elseif VFDom==2
    set(FDomain,'Visible','on');set(TDomain,'Visible','off');
    set(TDomain,'value',1);set(FDomain,'string',{'MNP';'TTP';'MDF';'MNF'});
    sTDom=get(FDomain,'String');VTDom=get(FDomain,'Value');typTDom=sTDom(VTDom);
end

if strcmp(typTDom,'WAMP')||strcmp(typTDom,'MYOP')||strcmp(typTDom,'ZC')||strcmp(typTDom,'SSC')
    set(thr,'Enable','on');if dis==1;if isnan(Vthr);msgbox('Please Enter Treshold','','warn');return;end;end
else;set(thr,'Enable','off')
end
if (VFDom==1)&&(dis==1);Inpuf=time_domain_features(Inputf,typTDom,Lwin,SlidWSize,Vthr);  
elseif (VFDom==2)&&(dis==1)
    %[handles.a,handles.b]=size(Inputf);In=zeros(handles.a-1,handles.b);
end
SInput=get(input,'String');VInput=get(input,'value');
VSInput=SInput(VInput);Vchi=str2double(get(Chi,'string'));Vchj=str2double(get(Chj,'string'));
if ~isnan(Inpuf)
    if VInput==1;msgbox('Please Select Input Channels in Block Load Data','','warn');return;end
    plot_feature_extraction(Data,Inputf,Lwin,SlidWSize,Inpuf,VSInput,VInput,SInput,typTDom,Vchi,Vchj,ax2,cm,CM,cmm);  
end
end
