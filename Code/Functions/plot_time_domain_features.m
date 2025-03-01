function plot_time_domain_features(Data,Input,FVal,SW,SS,Valist,VSInput,VInput,SInput,typlist, ...
    Vchi,Vchj,ax2,cm,CM,cmm)
b=FVal{Valist};[~,KK]=size(Data);[~,KKK]=size(Input);
SW1=['SizeW:',num2str(SW(Valist))];SS1=['; SlidW:',num2str(SS(Valist))];
if (KK~=1)&& (KKK~=1)&&(VInput==2)
    for i=1:KK
        p(i) = subplot(1,1,1,'Parent',ax2);plotline(i)=plot(p(i),b(:,i));%#ok
        hold on; if i==KK;lg=legend(SInput(4:end));title(lg,typlist);title([SW1,SS1],'FontName','Times New Roman');end
    end
elseif (KK~=1)&&(KKK==1)&&(VInput~=2)
    p(1) = subplot(1,1,1,'Parent',ax2);plotline(1)=plot(p(1),b);
    lg=legend(VSInput);title(lg,typlist);title([SW1,SS1],'FontName','Times New Roman');
elseif (KK==1)&&(KKK==1)&&(VInput==2)
    p(1) = subplot(1,1,1,'Parent',ax2);plotline(1)=plot(p(1),b);
    legend(typlist);title([SW1,SS1],'FontName','Times New Roman');
elseif VInput==3
    Ki=Vchi:Vchj;u=[];for i=1:KKK;u=[u;'Ch',num2str(Ki(i))];end;%#ok
    for i=1:KKK;p(i) = subplot(1,1,1,'Parent',ax2);plotline(i)=plot(p(1),b(:,i));%#ok
        hold on;if i==KKK;lg=legend(u);title(lg,typlist);title([SW1,SS1],'FontName','Times New Roman');end
    end
end
YT=ylabel(p(1),'Amplitude','FontName','Times New Roman');
YXT=xlabel(p(1),'Sample','FontName','Times New Roman');
set(p,'uicontextmenu',cm); set(plotline,'uicontextmenu',CM);
set(YXT,'uicontextmenu',cmm);set(YT,'uicontextmenu',cmm); 
end