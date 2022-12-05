% gpsdata.lat  SOW 2  BLH 3:5  flg 6 VEL 7:9 heading 15
%  baseGPS  VP Flag  baseline Yaw  Time  
function [ baseGPS ] = file2DataGPS(datapath,fileName  )
    gps0=load([datapath,fileName]);            %9-14  15heading 16flag    
    gps=[gps0(:,7:9),gps0(:,[3,4])*pi/180,gps0(:,5),gps0(:,6),...
        gps0(:,14),gps0(:,15)*pi/180,gps0(:,end),gps0(:,2)];
    gps(:,end-2) = yawcvt(gps(:,end-2),'c360cc180');
    baseGPS = gps;
end

