function [  ] = flagShow( flagTest )
%FLAGSHOW Summary of this function goes here
%   Detailed explanation goes here
%     myfigure;
    subplot(2,1,1);plot(flagTest(:,end),flagTest(:,1),'rx');grid on;
    xlabel('time/s'),ylabel('Calibrate_{flag}'),legend('Calibrate ');
    subplot(2,1,2);plot(flagTest(:,end),flagTest(:,2),'rx');grid on;
    xlabel('time/s'),ylabel('flagMeas_{flag}'),legend('Meas ');

end

