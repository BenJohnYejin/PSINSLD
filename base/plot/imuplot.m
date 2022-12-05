function lost = imuplot(imu, type, t0)
% SIMU data plot.
%
% Prototype: lost = imuplot(imu, type, t0)
% Inputs: imu - SIMU data, the last column is time tag
%         type - figure type
%         t0 - plot time t0 as 0
% Output: lost - lost index      
%          
% See also  imumeanplot, insplot, inserrplot, kfplot, gpsplot, odplot, magplot, igsplot, ttest.

% Copyright(c) 2009-2014, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 27/08/2013, 09/02/2014, 03/10/2014
global glv
    dps = glv.dps; g0 = glv.g0;
    if nargin<2, type=0; end
    if length(type)>=7  % imuplot(imu1, imu2);
        imuplot(imu);
        imu = type;   t = imu(:,end);  ts = diff(imu(1:2,end));
        subplot(321), plot(t, imu(:,1)/ts/dps, 'r'); legend('IMU1','IMU2');
        subplot(323), plot(t, imu(:,2)/ts/dps, 'r');
        subplot(325), plot(t, imu(:,3)/ts/dps, 'r');
        subplot(322), plot(t, imu(:,4)/ts/g0, 'r');
        subplot(324), plot(t, imu(:,5)/ts/g0, 'r');
        subplot(326), plot(t, imu(:,6)/ts/g0, 'r');
        return;
    end
    
    
    if size(imu,2)<7, imu(:,7) = (1:length(imu))'; end
    t = imu(:,end);
    if nargin==3,  % t0
        if ischar(t0)
            if strcmp(t0,'t0'), t0=t(1);
            elseif strcmp(t0,'t1'), t0=t(end);  end
        end
        t = t-t0;
    end
% 	ts = mean(diff(t));
	ts = mean(diff(t(1:2)));
%     if norm(mean(imu(:,4:6)))<9.8/2   % if it's velocity increment
        imu(:,1:6)=imu(:,1:6)/ts;
%     end
    myfig;
    if type==1
%         subplot(121), plot(t, [imu(:,1:3)]/dps); xygo('w');
%         subplot(122), plot(t, [imu(:,4:6)]/g0);  xygo('f');
        subplot(121), plot(t, [imu(:,1:3),normv(imu(:,1:3))]/dps); xygo('w'); legend('Wx','Wy','Wz','|W|');
        subplot(122), plot(t, [imu(:,4:6),normv(imu(:,4:6))]/g0);  xygo('f'); legend('Ax','Ay','Az','|A|');
    elseif type==2
        ax = plotyy(t, imu(:,1:3)/dps, t, imu(:,4:6)/g0); xyygo(ax, 'w', 'f');
    elseif type==3
        subplot(311), ax = plotyy(t, imu(:,1)/dps, t, imu(:,4)/g0); xyygo(ax, 'wx', 'fx');
        subplot(312), ax = plotyy(t, imu(:,2)/dps, t, imu(:,5)/g0); xyygo(ax, 'wy', 'fy');
        subplot(313), ax = plotyy(t, imu(:,3)/dps, t, imu(:,6)/g0); xyygo(ax, 'wz', 'fz');
    elseif type==4
        wfdot = diff([imu(1,:);imu])/ts;
        subplot(321), plot(t, [imu(:,1),wfdot(:,1)]/dps); xygo('wx');
        subplot(323), plot(t, [imu(:,2),wfdot(:,2)]/dps); xygo('wy');
        subplot(325), plot(t, [imu(:,3),wfdot(:,3)]/dps); xygo('wz');
        subplot(322), plot(t, [imu(:,4),wfdot(:,4)]/g0);  xygo('fx');
        subplot(324), plot(t, [imu(:,5),wfdot(:,5)]/g0);  xygo('fy');
        subplot(326), plot(t, [imu(:,6),wfdot(:,6)]/g0);  xygo('fz');
    elseif type==4
        wfdot = diff([imu(1,:);imu])/ts;
        subplot(321), plot(t, [imu(:,1),wfdot(:,1)]/dps); xygo('wx');
        subplot(323), plot(t, [imu(:,2),wfdot(:,2)]/dps); xygo('wy');
        subplot(325), plot(t, [imu(:,3),wfdot(:,3)]/dps); xygo('wz');
        subplot(322), plot(t, [imu(:,4),wfdot(:,4)]/g0);  xygo('fx');
        subplot(324), plot(t, [imu(:,5),wfdot(:,5)]/g0);  xygo('fy');
        subplot(326), plot(t, [imu(:,6),wfdot(:,6)]/g0);  xygo('fz');
    elseif type==glv.dph
        dt = diff(t);
        lost = abs(dt)>mean(dt)*1.5; tlost = t(lost)+dt(1);
        subplot(321), plot(t, imu(:,1)/glv.dph, tlost,imu(lost,1)/glv.dph,'ro'); xygo('wxdph');
        subplot(323), plot(t, imu(:,2)/glv.dph, tlost,imu(lost,2)/glv.dph,'ro'); xygo('wydph');
        subplot(325), plot(t, imu(:,3)/glv.dph, tlost,imu(lost,3)/glv.dph,'ro'); xygo('wzdph');
        subplot(322), plot(t, imu(:,4)/g0,  tlost,imu(lost,4)/g0,'ro');  xygo('fx');
        subplot(324), plot(t, imu(:,5)/g0,  tlost,imu(lost,5)/g0,'ro');  xygo('fy');
        subplot(326), plot(t, imu(:,6)/g0,  tlost,imu(lost,6)/g0,'ro');  xygo('fz');
        lost = find(lost)+1;
    else % type==0
        dt = diff(t);
        lost = abs(dt)>mean(dt)*1.5; tlost = t(lost)+dt(1);
        subplot(321), plot(t, imu(:,1)/dps, tlost,imu(lost,1)/dps,'ro'); xygo('wx');
        subplot(323), plot(t, imu(:,2)/dps, tlost,imu(lost,2)/dps,'ro'); xygo('wy');
        subplot(325), plot(t, imu(:,3)/dps, tlost,imu(lost,3)/dps,'ro'); xygo('wz');
        subplot(322), plot(t, imu(:,4)/g0,  tlost,imu(lost,4)/g0,'ro');  xygo('fx');
        subplot(324), plot(t, imu(:,5)/g0,  tlost,imu(lost,5)/g0,'ro');  xygo('fy');
        subplot(326), plot(t, imu(:,6)/g0,  tlost,imu(lost,6)/g0,'ro');  xygo('fz');
        lost = find(lost)+1;
    end

