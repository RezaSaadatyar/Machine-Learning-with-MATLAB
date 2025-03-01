function [InputWApprox_Detial,InputWRecons] = wavelet(Data,nlevel,Nwavelet,softhard,THR,Plotwavelet,...
 input,Chi,Chj,ax3,ax4,cm,CM,cmm,FVal,inputw,DataFilter,Input,inputCC)

InputWRecons=0;inputw1=0;InputWApprox_Detial={};

level=get(nlevel,'value');dis=get(Plotwavelet,'Value');VInput=get(input,'Value');
Vchi=str2double(get(Chi,'string'));Vchj=str2double(get(Chj,'string'));set(inputCC,'value',1);
swav=get(Nwavelet,'String');Vwav=get(Nwavelet,'Value');typwav=swav(Vwav);
sTHR=get(THR,'String');VTHR=get(THR,'Value');typTHR=sTHR(VTHR);ssh=get(softhard,'String');
Vsh=get(softhard,'Value');typsh=ssh(Vsh);Vinputw=get(inputw,'value');
subplot(1,1,1,'replace','Parent',ax3);subplot(1,1,1,'replace','Parent',ax4);

if size(FVal,2)~=0;u=[];for i=1:size(FVal,1);u=[u cell2mat(FVal(i))];end;inputF=u;else;inputF=0;end%#ok
if Vinputw==2;inputw1=Input;if inputw1==0;msgbox('Please Set Parameters in Block Load Data','Warning','warn');return;end
elseif Vinputw==3;inputw1=DataFilter;if inputw1==0;msgbox('Please Set Parameters in Block Filtering','Warning','warn');return;end
elseif Vinputw==4;inputw1=inputF;if inputw1==0;msgbox('Please Set Parameters in Block Feature Extraction','Warning','warn');return;end
end

if dis==1
if Data==0;msgbox('Please Load Data in Block Load Data','Error Load Data','error');return;end
if Vinputw==1;msgbox('Please Select Input in Block Wavelet','Warning','warn');return;end
[InputWApprox_Detial,InputWRecons] = plot_wavelet(Data,inputw1,VInput,Vchi,Vchj,level,typwav, ...
    typTHR,typsh,ax3,ax4,cm,CM,cmm);
end
end