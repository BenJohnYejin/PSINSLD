
function [ output_args ] = ODKappaPlot( ODKappa )
figure;
glvs;
    subplot(3,1,1);plot(ODKappa(:,end),ODKappa(:,1)/glv.deg);xlabel('time/s');ylabel('dpitch/deg');grid on;
    subplot(3,1,2);plot(ODKappa(:,end),ODKappa(:,2));xlabel('time/s');ylabel('Scale/-');grid on;
    subplot(3,1,3);plot(ODKappa(:,end),ODKappa(:,3)/glv.deg);xlabel('time/s');ylabel('dYaw/deg');grid on;
end

