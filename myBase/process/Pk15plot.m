function [ ] = Pk15plot( Pk )
glvs;
    t = Pk(:,end); 
    subplot(321), hold on, plot(t, Pk(:,1:2)/glv.sec );xygo('phiEN'); mylegend('phiE','phiN');
    subplot(322), hold on, plot(t, Pk(:,3)/glv.min);xygo('phiU');mylegend('phiU');
    subplot(323), hold on, plot(t, Pk(:,4:6));xygo('dV');mylegend('dVE','dVN','dVU');
    subplot(324), hold on, plot(t, [Pk(:,7:8)*glv.Re,Pk(:,9)]);xygo('dP');mylegend('dlat','dlon','dH');
    subplot(325), hold on, plot(t, Pk(:,10:12)/glv.dph);xygo('eb');
    subplot(326), hold on, plot(t, Pk(:,13:15)/glv.ug);xygo('db');
end

