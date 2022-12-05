%  sow 1  BLH 2-4 ATT 5-7  VEL 8-10 ???
%  Att VEL  BLH  sow
function [ baseA08 ] = file2DataA08( dataPath,fileName,Count )
glvs;
    data=load([dataPath,fileName]);
%     data(:,1)=data(:,1)+Count*24*3600-8*3600;
    base = data(:,[6,5,7,8:10,2,3,4,1]);
    base(:,3)=yawcvt(base(:,3),'c360cc180');
    base(:,end)=base(:,end)+18;
    baseA08 = base;


end

