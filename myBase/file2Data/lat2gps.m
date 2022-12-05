% 数据格式定义
% 1-2 时间 3-5 位置 6 flag标志位
% 7-9 速度 10 卫星颗数  11 dop
% 12,13,14 gps时间  速度时间  基线长
% 15 航向  
% 16-19 std_lat,std_lon,std_high,std_yaw
%  ============>
% VP Flag Num Time
% 6 7 8 9 
function [ gps ] = lat2gps( lat )
    gps = lat(:,[7:9,3:5,6,15,2]);
    gps(:,[4:5,8])=gps(:,[4:5,8])/180*pi;
    gps = gps(gps(:,8)~=0,:);
    gps(:,8)= yawcvt(gps(:,8),'c360cc180');
end

