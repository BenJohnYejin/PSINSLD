%A28 time 1  LBH 2,3,4  Vel 8,9,10  att 5,6,7
%data ATT VEL BLH
%
function [ baseA28 ] = file2DataA28( path,fileName )
glvs;
    data=load([path,fileName]);
    base = data(:,[5:7,8:10,2,3,4,1]);
%     base(:,[1:3,7,8])=base(:,[1:3,7,8])*glv.deg;
    base(:,3)=yawcvt(base(:,3),'c360cc180');
    base(:,end)=base(:,end)+18;
    
    baseA28 = base;
end

