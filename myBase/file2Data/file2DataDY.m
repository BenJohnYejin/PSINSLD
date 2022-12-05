function [ nav,imu ] = file2DataDY( filename )
glvs;ts=0.01;
    data = load(filename);
    data(:,1) = round(data(:,1)*100)/100;
    data(data(:,end-1)> -0.03 &  data(:,end-1)< 0.03,:) = [];
    
    
    ins58 = data(:,[10,9,8,5:7,3,2,4,1]);
    ins58(:,[1:3,7,8]) = ins58(:,[1:3,7,8])*glv.dps;
    ins58(:,6)=-ins58(:,6);ins58(:,9)=data(:,4)-13.65;
    ins58(:,3)=yawcvt(ins58(:,3),'c360cc180');
    
    imuOri = data(:,[end-6:end,1]); 
    imuOri(:,1:3)=imuOri(:,[2,1,3])*glv.dps*ts;
    
    imuOri(:,4:6)=imuOri(:,[5,4,6])*glv.g0*ts;
    imuOri(:,[3,6])=-imuOri(:,[3,6]);
    imuOri(:,7)= sqrt(ins58(:,5).*ins58(:,5)+ins58(:,6).*ins58(:,6)+ins58(:,4).*ins58(:,4));
    
    ins58(ins58(:,end)<1000,:) = [];
    nav = ins58;
    
    imuOri(imuOri(:,end)<1000,:) = [];
    imuOri(imuOri(:,end)>imuOri(end,end),: )=[];
    imu = imuOri;
    
    
%     nav(:,end) = nav(:,end) - ts;
%     imu(:,end) = imu(:,end) - ts;
end

