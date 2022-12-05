function [] = IPOS3plot( ins)
glvs;
    t0 = ins(1,end);
    t = ins(:,end)-t0;
    avp = ins(:,1:9);
    flag = ins(:,10:11);
myfigure;
    subplot(321), plot(t, avp(:,1:2)/glv.deg); xygo('pr');
    subplot(322), plot(t, avp(:,3)/glv.deg); xygo('y');
    subplot(323), plot(t, [avp(:,4:6),sqrt(avp(:,4).^2+avp(:,5).^2+avp(:,6).^2)]); xygo('V'); 
    dxyz1 = pos2dxyz(avp(:,7:9));
    subplot(325), plot(t, dxyz1(:,[2,1,3])); xygo('DP');
    subplot(3,2,[4,6]), plot(0, 0, 'rp');   
    
    hold on, plot(dxyz1(:,1), dxyz1(:,2),'g.-'); xygo('est', 'nth');
    %¶ªÊ§GNSS
    index = find(flag(:,2) == 34 & flag(:,1) == 0);
    plot(dxyz1(index,1),dxyz1(index,2),'ro');
    %µ¥µã
    index = find(flag(:,2) == 34 & flag(:,1) == 1);    
    plot(dxyz1(index,1),dxyz1(index,2),'b.');  
    
    legend(sprintf('LON0:%.2f, LAT0:%.2f (DMS)', r2dms(avp(1,8)),r2dms(avp(1,7))),'Location','NorthOutside');
end

