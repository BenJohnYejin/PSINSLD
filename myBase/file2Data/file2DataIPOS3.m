
function [ nav,imu ] = file2DataIPOS3( datapath,filename )
glvs;ts=0.01;
    data = load([datapath,filename]);
    data(:,1)=round(data(:,1)*100)/100;
    
    ins58 = data(:,[10,9,8,5,6,7,2,3,4,1]);
    ins58(:,[1:3,7,8]) = ins58(:,[1:3,7,8])*glv.dps;
    ins58(:,3)=yawcvt(-ins58(:,3),'c360cc180');
    nav = ins58;
    
    imuOri = data(:,[end-6:end,1]); 
    imuOri(:,1:3)=imuOri(:,1:3)*ts;
    imuOri(:,4:6)=imuOri(:,4:6)*glv.g0*ts;
    imuOri(:,7)= data(:,22);
    
    imu = imuOri;
end
