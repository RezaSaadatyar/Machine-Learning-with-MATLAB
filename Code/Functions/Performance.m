function Performance(TPerf,TPerfT,FTPerf,ax6,ax7,cm,T)
p1= subplot(1,1,1,'replace','Parent',ax6);b=bar(p1,TPerf,'FaceColor','flat');
p2= subplot(1,1,1,'replace','Parent',ax7);b2=bar(p2,TPerfT,'FaceColor','flat');
p1.YGrid='on';ylabel(p1,'%');p1.YLim=[0 103];p1.FontSize=10;p1.FontWeight='bold';
p1.FontName='Times New Roman';p1.XTickLabel=[];
p2.YGrid='on';ylabel(p2,'%');p2.YLim=[0 103];p2.FontSize=10;p2.FontWeight='bold';
p2.FontName='Times New Roman';p2.XTickLabel=[];
if length(FTPerf)>1;til=legend(p1,{'Accuracy','Sensitivity','Specificity'},'Location','southeast');
    p1.XTickLabel=FTPerf;title(til,T);p1.XTick=1:length(FTPerf);
    b(1).CData=[1,0,0];b(2).CData=[0,1,0];b(3).CData=[0.49 0.18 0.56];p1.XTickLabelRotation=90;
    til=legend(p2,{'Accuracy','Sensitivity','Specificity','Precision','F-measure','MCC'},'Location','southeast');
    p2.XTickLabel=FTPerf;p2.XTickLabelRotation=90;b2(1).CData=[1,0,0];b2(2).CData=[0,0,1];title(til,T)
    b2(3).CData=[0,1,0];b2(4).CData=[1 1 0];b2(5).CData=[0.49 0.18 0.56];b2(6).CData=[0 1 1];p2.XTick=1:length(FTPerf);
end
set(p1,'uicontextmenu',cm);set(p2,'uicontextmenu',cm)
end