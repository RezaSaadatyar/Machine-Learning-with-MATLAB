function XLAB(Input,fs)
xlb=(get(gcbo,'label'));ax=gca;ax.FontName='Times New Roman';
if~isempty(ax.Legend);ax.Legend.FontSize=8;end;tt=ax.XTick;
if  strcmp(xlb,'none');t=0:length(Input)-1;u=[];for i=2:length(tt);u=[u t(tt(i))+1];end;%#ok
    ax.XTickLabel=[t(1) u];ax.XLabel.String='';end
if find(tt)~=0;if tt(end)>length(Input);tt(end)=length(Input);end
    if  strcmp(xlb,'Time(Sec)')
        if isempty(fs);fs=str2double(cell2mat((inputdlg('Enter Fs','modal'))));else
        if isnan(fs)||(fs==0)||isempty(fs);fs=str2double(cell2mat((inputdlg('Enter Fs','modal'))));end;end
        if isnan(fs)||(fs==0);msgbox('Please Enter Fs','','warn'); return;end
        ax.XLabel.String=xlb;
        Ts=1/fs;t=(0:length(Input)-1)*Ts;
        ax.XTickLabel=round([t(1) t(tt(find(tt)))],2);
    elseif strcmp(xlb,'Sample');ax.XLabel.String=xlb;t=0:length(Input)-1;u=[];
        for i=2:length(tt);u=[u t(tt(i))+1];end; ax.XTickLabel=round([t(1) u]);%#ok
    end
else
    ax.XLabel.String='';
end
end