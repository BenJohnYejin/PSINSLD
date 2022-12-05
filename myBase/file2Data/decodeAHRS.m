
function [imu,mag,tpt,time]=decodeAHRS(fileName)
    imuData=load(fileName);
    time=imuData(:,2);
    Ts = 1/(time(2)-time(1));
    gyr=imuData(:,3:5)/Ts;
    acc=imuData(:,6:8);
    tpt=imuData(:,9);
    mag=imuData(:,10:12);
    imu=[gyr,acc];
end