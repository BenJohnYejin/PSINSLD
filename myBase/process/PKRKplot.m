function [ ] = PKRKplot( kfdata )
t = kfdata(:,end);
subplot(311), hold on, plot(t, kfdata(:,4:6)./kfdata(:,16:18));xygo('dV');mylegend('VE','VN','VU');
subplot(312), hold on, plot(t, kfdata(:,7:9)./kfdata(:,19:21));xygo('dP');mylegend('lat','lon','H');
subplot(313), hold on, plot(t, kfdata(:,4:6)./kfdata(:,22:24));xygo('dV');mylegend('dVE','dVN','dVU');

end

