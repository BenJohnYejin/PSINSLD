% imudata  time 3   4:6  7:9   RFU  NED
% imu  wm,vm,time
function [ imu ] = file2DataIMU( datapath,fileName,ts )
glvs;
    imu00=load([datapath,fileName]);%%4 345  678
    imu00no=[[imu00(:,5),imu00(:,4),-imu00(:,6)]*glv.deg,imu00(:,[8,7]),-imu00(:,9),imu00(:,3)]; 
    % NED ---->ENU
%     imu00no=[[imu00(:,4),imu00(:,5),imu00(:,6)]*glv.deg,imu00(:,7),imu00(:,8),imu00(:,9),imu00(:,3)];
%     plot(diff(imu00no(:,end)));
%     imu00no(10 > imu00no(:,end),:) = [];
%     % ��̼� 
%     imu00(find(imu00(:,12)==0),12) = 1;
%     imu00(find(imu00(:,12)==255),12) = -1;
%     imu00(:,11) = imu00(:,11).*imu00(:,12);
%     %�޸�IMU����
%     imu00no = imurepair(imu00no);
%     %IMU�����ز���
%     imu00ok = imuresample(imu00no, ts);
    %ʱ��
    imu00ok = imu00no;
    imu00ok(:,7)=round(imu00no(:,7)*1000)/1000;
    
    imu=imu00ok;
end

