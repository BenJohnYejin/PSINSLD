% A35  4 time  17 16 15 att  8:10 vel  6,5,7 BHL
% baseA35  avp_flag_t
function [baseA35 ] = file2DataA35A(fileName,Count)
glvs;
    nav0=load(fileName);
    nav0(:,22)=nav0(:,4)+Count*24*3600-8*3600;    
    nav= nav0(:,[17,16,15,8:10,6,5,7,22]);
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.dps;
    nav(:,3)=yawcvt(nav(:,3),'c360cc180');
    nav(:,11)=(round(nav(:,10)*1000))/1000;
    nav(:,10)=nav0(:,20);
    
    
    baseA35 = nav;
end

