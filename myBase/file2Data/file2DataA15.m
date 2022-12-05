
% ATT 8-10 VEL 16-18 BLH 2-4 tow 1
% avpt
function [ navA15 ] = file2DataA15( datapath,fileName)
glvs;
    nav0=load([datapath,fileName]);
    nav= nav0(:,[8:10,16:18,3,2,4,1]);
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.dps;
    nav(:,3)=yawcvt(nav(:,3),'c360cc180');
    nav(:,10)=(round(nav(:,10)*1000))/1000+18;
    
    navA15 = nav;

end

