function [  ] = CalibratePlot( dd )
glvs;myfigure;
    subplot(3,2,1);
    plot(dd(:,end),dd(:,1:3));xlabel('time/s');ylabel('lever/m');
    grid on;legend('x lever','y lever','z lever');title('GNSS Lever');
    
    subplot(3,2,2);
    plot(dd(:,end),dd(:,4:6));xlabel('time/s');ylabel('lever/m');
    grid on;legend('x lever','y lever','z lever');title('OD Lever');
    
    subplot(3,2,3);
    plot(dd(:,end),[dd(:,7)/glv.deg,dd(:,9)/glv.deg]);
    xlabel('time/s');grid on;legend('dPitchOD','dYawOD');title('OD');
    
    subplot(3,2,4);
    plot(dd(:,end),dd(:,8));
    xlabel('time/s');grid on;legend('odScale');title('OD-Scale');
    
    subplot(3,2,5);
    plot(dd(:,end),dd(:,10)/glv.deg);
    grid on;xlabel('time/s');legend('dYawGNSS');title('GNSS-dYaw');

    subplot(3,2,6);
    plot(dd(:,end),dd(:,11));
    grid on;xlabel('time/s');legend('dt_{GNSS}');title('GNSS-dt');

end

