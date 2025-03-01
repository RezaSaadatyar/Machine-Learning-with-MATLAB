function In = time_domain_features(Inputf,typTDom,Lwin,SlidWSize,Vthr)
[handles.a,handles.b]=size(Inputf);In=zeros(handles.a-1,handles.b);b=0;k=1;r=0;j=0;
if strcmp(typTDom,'Integrate')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            a=abs(Inputf(i,:));b=b+a;In(i,:)=b;
        else
            b=0;r=Lwin*k-SlidWSize;In(i,:)=abs(Inputf(i,:));
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'Mean')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=mean(Inputf(1+j:i,:),1);
        else;r=Lwin*k-SlidWSize;In(i,:)=mean(Inputf(i,:),1);j=i-1;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
    elseif strcmp(typTDom,'MAD')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=mad(Inputf(1+j:i,:));
        else;r=Lwin*k-SlidWSize;In(i,:)=mad(Inputf(i,:));j=i-1;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
    elseif strcmp(typTDom,'Median')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=median(Inputf(1+j:i,:),1);
        else;r=Lwin*k-SlidWSize;In(i,:)=median(Inputf(i,:),1);j=i-1;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'Std')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=std(Inputf(1+j:i,:),0,1);
        else;r=Lwin*k-SlidWSize;In(i,:)=std(Inputf(i,:),0,1);j=i-1;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'Skewness')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=skewness(Inputf(1+j:i,:),[],1);In(isnan(In))=0;
        else;r=Lwin*k-SlidWSize;j=i-1;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'Kurtosis')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=kurtosis(Inputf(1+j:i,:),[],1);In(isnan(In))=0;
        else;r=Lwin*k-SlidWSize;j=i-1;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'MAV')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=(sum(abs(Inputf(1+j:i,:)),1))./(length(j:i)-1);
        else
            j=i-1;r=Lwin*k-SlidWSize;In(i,:)=abs(Inputf(i,:));
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'V-Order3')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            In(i,:)=((sum((abs(Inputf(j+1:i,:))).^3,1))./(length(j:i)-1)).^(1/3);
        else
            j=i-1;r=Lwin*k-SlidWSize;In(i,:)=abs(Inputf(i,:));
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'MMAV')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r)
            if (0.25*Lwin+r<=i) && (i<=0.75*Lwin+r)
                In(i,:)=(sum(abs(Inputf(1+j:i,:)),1))./(length(j:i)-1);else
                In(i,:)=(sum(0.5.*abs(Inputf(1+j:i,:)),1))./(length(j:i)-1);
            end
        else
            j=i-1;r=Lwin*k-SlidWSize;
            if (0.25*Lwin+r<=i) && (i<=0.75*Lwin+r);In(i,:)=abs(Inputf(i,:));else
                In(i,:)=0.5*abs(Inputf(i,:));end;if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'SSI')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r); a=abs(Inputf(i,:)).^2;b=b+a;In(i,:)=b;else
            b=0;r=Lwin*k-SlidWSize;a=abs(Inputf(i,:)).^2;b=b+a;In(i,:)=b;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'VAR')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r);In(i,:)=var(Inputf(1+j:i,:),0,1);
        else;j=i-1;In(i,:)=var(Inputf(i,:),0,1);r=Lwin*k-SlidWSize;
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'RMS') || strcmp(typTDom,'V-Order2')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r);In(i,:)=rms(Inputf(1+j:i,:),1);
        else;j=i-1;r=Lwin*k-SlidWSize;In(i,:)=rms(Inputf(i,:),1);
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'WL')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r-1)
            a=abs(Inputf(i+1,:)-Inputf(i,:));b=b+a;In(i,:)=b;
        else
            b=0;r=Lwin*k-SlidWSize;In(i,:)=abs(Inputf(i,:)-Inputf(i+1,:));
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'ACC')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r-1)
            a=abs(Inputf(i+1,:)-Inputf(i,:));b=b+a;In(i,:)=b./(length(j:i)-1);
        else
            j=i-1;b=0;r=Lwin*k-SlidWSize;In(i,:)=abs(Inputf(i,:)-Inputf(i+1,:));
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'WAMP')
    for jj=1:handles.b;b=0;k=1;r=0;
        for  i=1:handles.a-1
            if (1+r<=i) && (i<=Lwin+r-1)
                if abs(Inputf(i,jj)-Inputf(i+1,jj))>Vthr;b=b+1;In(i,jj)=b;else;In(i,jj)=b;end
            else
                b=0;r=Lwin*k-SlidWSize;if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
                if abs(Inputf(i,jj)-Inputf(i+1,jj))>Vthr;b=b+1;In(i,jj)=b;else;In(i,jj)=b; end
            end
        end
    end
elseif strcmp(typTDom,'MYOP')
    for jj=1:handles.b;b=0;k=1;r=0;j=0;
        for  i=1:handles.a-1
            if (1+r<=i) && (i<=Lwin+r-1)
                if Inputf(i,jj)>Vthr;b=b+1;In(i,jj)=b/(length(j:i)-1);else;In(i,jj)=b/(length(j:i)-1);end
            else
                if Inputf(i,jj)>Vthr;b=b+1;In(i,jj)=b/(length(j:i)-1);else;In(i,jj)=b/(length(j:i)-1);end
                j=i-1;b=0;r=Lwin*k-SlidWSize;if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
            end
        end
    end
elseif strcmp(typTDom,'ZC')
    for jj=1:handles.b;b=0;k=1;r=0;
        for  i=1:handles.a-1
            if (1+r<=i) && (i<=Lwin+r-1)
                if (Inputf(i,jj)*Inputf(i+1,jj)<0) && (abs(Inputf(i,jj)-Inputf(i+1,jj)))>Vthr
                    b=b+1;In(i,jj)=b;else;In(i,jj)=b;end
            else
                b=0;r=Lwin*k-SlidWSize;if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
                if (Inputf(i,jj)*Inputf(i+1,jj)<0) && (abs(Inputf(i,jj)-Inputf(i+1,jj)))>Vthr
                    b=b+1;In(i,jj)=b;else;In(i,jj)=b;end
            end
        end
    end
elseif strcmp(typTDom,'DASDV')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r-1)
            a=(Inputf(i+1,:)-Inputf(i,:)).^2;b=b+a;In(i,:)=sqrt((b+a)./(length(j:i)-1));
        else
            j=i-1;b=0;r=Lwin*k-SlidWSize;In(i,:)=sqrt((Inputf(i,:)-Inputf(i-1,:)).^2);
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'MFL')
    for  i=1:handles.a-1
        if (1+r<=i) && (i<=Lwin+r-1)
            a=(Inputf(i+1,:)-Inputf(i,:)).^2;b=b+a;In(i,:)=log10(sqrt(b));
        else
            b=0;r=Lwin*k-SlidWSize;a=(Inputf(i,:)-Inputf(i-1,:)).^2;In(i,:)=log10(sqrt(a));
            if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
        end
    end
elseif strcmp(typTDom,'SSC')
    for jj=1:handles.b;b=0;k=1;r=0;
        for  i=2:handles.a-1
            if (1+r<=i) && (i<=Lwin+r-1)
                if (Inputf(i,jj)-Inputf(i-1,jj))*(Inputf(i,jj)-Inputf(i+1,jj))>Vthr
                    b=b+1;In(i-1,jj)=b;else;In(i-1,jj)=b;end
            else
                b=0;r=Lwin*k-SlidWSize;if (1<=k) && (k<=floor(handles.a/Lwin));k=k+1;end
                if (Inputf(i,jj)-Inputf(i-1,jj))*(Inputf(i,jj)-Inputf(i+1,jj))>Vthr
                    b=b+1;In(i-1,jj)=b;else;In(i-1,jj)=b;end
            end
        end
        b=b+1;In(i,jj)=b;
    end
end
end