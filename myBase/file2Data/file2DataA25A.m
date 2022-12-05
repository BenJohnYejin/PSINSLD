% A35  1 time  9,8,10 att  16:18 vel  3,2,4 BHL
% baseA35  avpt
function [ baseA25 ] = file2DataA25A( datapath,fileName,Count )
glvs;
    nav0=load([datapath,fileName]);
    nav0(:,1)=nav0(:,1)+Count*24*3600-8*3600;
    nav= nav0(:,[9,8,10,16:18,3,2,4,1]); 
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.dps;
    nav(:,3)=yawcvt(nav(:,3),'c360cc180'); 
    nav(:,10)=(round(nav(:,10)*1000))/1000;%nav时间避免小数位差值变化
    baseA25 = nav;
end

