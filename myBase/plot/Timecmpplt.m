%%
%测试两结果之间的时间之差并绘图
function [] = Timecmpplt(nav0,nav1,timeCount,timeIntervel)
%%
glvs;
    ori_t = nav1(:,end);
    t0 = (timeCount*timeIntervel)/2;

    myfigure('Vel dt delay');
    for j = 1:timeCount
        delta_t =  t0 - j*timeIntervel;
        t = ori_t + delta_t;
        nav1(:,end) = t;
        err = avpcmp(nav1, nav0, 'v'); t = err(:,end);
        subplot(timeCount,1,j),plot(t, err(:,4:6),'LineWidth',2);grid on;
        ylabel(sprintf('%.2f s',delta_t ));
        title(sprintf('rms = %.3f %.3f %.3f ',rms(err(:,4:6))));
    end
    %%
    myfigure('Pos dt delay');
    for j = 1:timeCount
        delta_t =  t0 - j*timeIntervel;
        t = ori_t + delta_t;
        nav1(:,end) = t;
        err = avpcmp(nav1, nav0, 'p'); t = err(:,end);
        subplot(timeCount,1,j),plot(t, [err(:,7:8)*glv.Re,err(:,9)],'LineWidth',2);grid on;
        ylabel(sprintf('%.2f s',delta_t ));
        title(sprintf('rms = %.3f %.3f %.3f ',rms([err(:,7:8)*glv.Re,err(:,9)])));
    end
end