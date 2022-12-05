
% ATT 8-10 VEL 14~16 BLH 2-4 tow 1
% avpt
function [ navA05 ] = file2DataA05( datapath,fileName)
glvs;
    nav0=load([datapath,fileName]);
    nav= nav0(:,[8:10,14:16,3,2,4,1]);
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.dps;
    nav(:,3)=yawcvt(nav(:,3),'c360cc180');
    nav(:,10)=(round(nav(:,10)*1000))/1000+18;
    
    navA05 = nav;

end

