function [  ] = leverPlot( levert )
glvs;figure;
    subplot(2,1,1);
    plot(levert(:,end),levert(:,1:3));xlabel('time/s');ylabel('lever/m');
    grid on;legend('x lever','y lever','z lever');title('GNSS Lever');
    subplot(2,1,2);
    plot(levert(:,end),levert(:,4:6));xlabel('time/s');ylabel('lever/m');
    grid on;legend('x lever','y lever','z lever');title('OD Lever');
end

