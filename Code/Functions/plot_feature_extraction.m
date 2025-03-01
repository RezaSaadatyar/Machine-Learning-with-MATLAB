function plot_feature_extraction(Data,Inputf,Lwin,SlidWSize,Inpuf,VSInput,VInput,SInput,typTDom,Vchi,Vchj,ax,cm,CM,cmm)
[~,KK]=size(Data);[~,KKK]=size(Inputf);SW=['SizeW:',num2str(Lwin)];SS=['; SlidW:',num2str(SlidWSize)];
if ~isempty(Inpuf)
    if (KK~=1)&& (KKK~=1)&&(VInput==2)
        for i=1:KK
            p(i) = subplot(1,1,1,'Parent',ax);plotline(i)=plot(p(i),Inpuf(:,i));%#ok
            hold on; if i==KK;lg=legend(SInput(4:end));title(lg,typTDom),title([SW,SS],'FontName','Times New Roman')
            end
        end
    elseif (KK==1)&&(KKK==1)&&(VInput==2)
        p(1) = subplot(1,1,1,'Parent',ax);plotline(1)=plot(p(1),Inpuf);
        legend(typTDom);title([SW,SS],'FontName','Times New Roman')
    elseif (KK~=1)&&(KKK==1)&&(VInput~=2)
        p(1) = subplot(1,1,1,'Parent',ax);plotline(1)=plot(p(1),Inpuf);
        lg=legend(VSInput);title(lg,typTDom);title([SW,SS],'FontName','Times New Roman')
    elseif VInput==3
        Ki=Vchi:Vchj;u=[];for i=1:KKK;u=[u;'Ch',num2str(Ki(i))];end;%#ok
        for i=1:KKK;p(i) = subplot(1,1,1,'Parent',ax);plotline(i)=plot(p(1),Inpuf(:,i));%#ok
            hold on;if i==KKK;lg=legend(u);title(lg,typTDom);title([SW,SS],'FontName','Times New Roman');end
        end
    end
    YT=ylabel(p(1),'Amplitude','FontName','Times New Roman');
    YXT=xlabel(p(1),'Sample','FontName','Times New Roman');
set(p,'uicontextmenu',cm); set(plotline,'uicontextmenu',CM);
set(YXT,'uicontextmenu',cmm);set(YT,'uicontextmenu',cmm);
end
end