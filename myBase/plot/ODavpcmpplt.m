
function [ err ] = ODavpcmpplt( avp0 ,avp1, flagGNSS,isShow )
glvs;
    err = avpcmp(avp1(:,[2,1,3:end]), avp0(:,[2,1,3:end]), 'mu');
    t = err(:,end);
%     t=t-t(1);
    dxyz0 = pos2dxyz(avp0(:,7:9));
    dxyz1 = pos2dxyz(avp1(:,7:9));
%     initPos = avp0(1,7:8);
%     avp0(:,7) = avp0(:,7)-initPos(1);avp0(:,8) = avp0(:,8)-initPos(2);
%     avp1(:,7) = avp1(:,7)-initPos(1);avp1(:,8) = avp1(:,8)-initPos(2);    
    if(isShow)
        myfigure;
        subplot(321), hold on, plot(t, err(:,1:3)/glv.min,'LineWidth',1); xygo('mu');
        subplot(323), hold on, plot(t, err(:,4:6), 'LineWidth',1); xygo('dV'); 
        subplot(325), hold on, plot(t, [err(:,7:8)*glv.Re,err(:,9)], 'LineWidth',1); xygo('dP'); 
        subplot(322), hold on, plot(avp0(:,end)-avp0(1,end), [avp0(:,4:6),normv(avp0(:,4:6))]); xygo('V');
        
        subplot(3,2,[4,6]);grid on;hold on; 
        plot(0, 0, 'rp');   
        plot(dxyz0(:,1), dxyz0(:,2),'g.-'); xygo('est', 'nth');
        plot(dxyz1(:,1), dxyz1(:,2),'b.-'); 
%         plot(dxyz1(flagGNSS == 0 ,1),dxyz1(flagGNSS == 0 ,2),'rx');
        plot(dxyz1(flagGNSS == 3 ,1),dxyz1(flagGNSS == 3 ,2),'r.');
        
        legend(sprintf('LON0:%.2f, LAT0:%.2f (DMS)', r2dms(avp0(1,8)),r2dms(avp0(1,7))),...
            '基准数据','实测数据','量测无航向','Location','NorthOutside');
        
%         plot(avp0(:,7)*glv.Re,avp0(:,8)*glv.Re,'g','LineWidth',1.0);
%         plot(avp1(:,7)*glv.Re,avp1(:,8)*glv.Re,'b','LineWidth',1.0);
%         plot(avp1(flagGNSS == 0,7)*glv.Re,avp1(flagGNSS == 0,8)*glv.Re,'rx');

    end

end

