% ���ݸ�ʽ����
% 1-2 ʱ�� 3-5 λ�� 6 flag��־λ
% 7-9 �ٶ� 10 ���ǿ���  11 dop
% 12,13,14 gpsʱ��  �ٶ�ʱ��  ���߳�
% 15 ����  
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

