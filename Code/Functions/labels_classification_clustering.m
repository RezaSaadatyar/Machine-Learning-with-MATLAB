function Lab = labels_classification_clustering(values,FF,inputCC,hobj,str,NSC,Classify,...
Cluster,Cluster1,NumClass,NumClass1)

Lab=0;set(Classify,'value',1);set(Cluster,'Value',1);set(Cluster1,'Value',1);

if get(inputCC,'value')==1;msgbox('Please Select Input in Block Classification & Clustring','Warning','warn');return;end
if get(hobj,'Value')==1;msgbox('Please Select Labels in Block Classification & Clustring','Warning','warn');return;end

Spop1=get(hobj,'String');Vpop1=get(hobj,'Value');typpop1=Spop1(Vpop1);

if strcmp(str,'xlsx');Lab=xlsread(FF,char(typpop1));
elseif strcmp(str,'mat');Val=struct2cell(values);Lab=cell2mat(Val(Vpop1-1));
elseif strcmp(str,'txt');Lab=values;
end

[handles.a,handles.b]=size(Lab);if (handles.a<handles.b);Lab=Lab';end
Cll=cell(handles.b+2,1);Cll{1}='Select Ch:';Cll{handles.b+2}='Multi Ch';
for i=2:handles.b+1;Cll{i}=['Ch', num2str(i-1)];end;set(NSC,'string',Cll);
Va=get(NSC,'value');
if handles.b==1;set(NumClass1,'enable','off');set(NSC,'value',1)
    set(NSC,'enable','off');set(NumClass,'enable','off');
else;set(NSC,'enable','on');
    if Va==1;msgbox('Please Select Ch:','','warn');return;end
    if Va~=handles.b+2;Lab=Lab(:,Va-1);end
    if Va==handles.b+2;set(NumClass,'enable','on');
        set(NumClass1,'enable','on');Vchi=str2double(get(NumClass,'string'));
        Vchj=str2double(get(NumClass1,'string'));
        if isnan(Vchi)||(Vchi<1)||(Vchi>handles.b);msgbox(['Please Enter Chi:  0 < Chi < ',num2str(handles.b)],'','warn');return;end
        if isnan(Vchj)||(Vchj<1)||(Vchj>handles.b+1);msgbox(['Please Enter Chj:  ',num2str(Vchi),'< Chj <',num2str(handles.b)+1],'','warn');return;end
        if Vchj<=Vchi;msgbox([num2str(Vchi),'< Chj <',num2str(handles.b)+1],'','warn');return;end
        Lab=Lab(:,Vchi:Vchj);
    end
end