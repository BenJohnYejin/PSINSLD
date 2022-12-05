function [ ] = Rk8plot( Rk )
glvs;
    t = Rk(:,end);
    subplot(221), hold on, plot(t, Rk(:,1:3));xygo('dV');mylegend('dVE','dVN','dVU');
    subplot(223), hold on, plot(t, Rk(:,4:6));xygo('dP');mylegend('dlat','dlon','dH');

    subplot(222), hold on, plot(t, Rk(:,7:9));xygo('dV');mylegend('dVE','dVN','dVU');
    subplot(224), hold on, plot(t, Rk(:,10)/glv.min);xygo('phiU');mylegend('phiU');
end