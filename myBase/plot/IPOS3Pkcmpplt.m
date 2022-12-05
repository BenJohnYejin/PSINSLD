%%
%测试Pk与真实误差之间对比情况
%用于提供定位是否有效标志
function [] = IPOS3Pkcmpplt(base,navIPOS3)
    stdPos = navIPOS3(navIPOS3(:,13) == 0,[10:12,15]);
    stdVel = navIPOS3(navIPOS3(:,13) == 1,[10:12,15]);
    stdAtt = navIPOS3(navIPOS3(:,13) == 2,[10:12,15]);
    err = avpcmp(base,navIPOS3(:,[1:9,end]),'mu');
    %%
    glvs;
    myfigure('Pos');
    subplot(2,1,1),plot(stdPos(:,end),stdPos(:,1:3));legend('E-std','N-std','U-std');grid on;
    xlabel('time /s');ylabel('std /m');xlim([stdPos(1,4),stdPos(end,4)]);
    subplot(2,1,2),plot(err(:,end),abs([err(:,7:8)*glv.Re,err(:,9)]));legend('E-err','N-err','U-err');grid on;
    xlabel('time /s');ylabel('err /m');xlim([stdPos(1,4),stdPos(end,4)]);
    
    myfigure('Vel');
    subplot(2,1,1),plot(stdAtt(:,end),stdVel(:,1:3));legend('E-std','N-std','U-std');grid on;
    xlabel('time /s');ylabel('std /m/s');xlim([stdVel(1,4),stdVel(end,4)]);
    subplot(2,1,2),plot(err(:,end),abs(err(:,4:6)));legend('E-err','N-err','U-err');grid on;
    xlabel('time /s');ylabel('err /m/s');xlim([stdVel(1,4),stdVel(end,4)]);
    
    myfigure('Att');
    subplot(2,1,1),plot(stdAtt(:,end),stdAtt(:,1:3));legend('E-std','N-std','U-std');grid on;
    xlabel('time /s');ylabel('std /deg');xlim([stdAtt(1,4),stdAtt(end,4)]);
    subplot(2,1,2),plot(err(:,end),abs(err(:,1:3))/glv.deg);legend('E-err','N-err','U-err');grid on;
    xlabel('time /s');ylabel('err /deg');xlim([stdAtt(1,4),stdAtt(end,4)]);
end

