
function [ baseIPOS ] = file2DataIPOS( datapath,fileName,Count )
glvs;   
    nav0=load([datapath,fileName]);
    nav0(:,22)=nav0(:,4)+Count*24*3600-8*3600;
    nav= nav0(:,[17,16,15,8:10,6,5,7,22]);
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.dps;
    nav(:,3)=yawcvt(nav(:,3),'c360cc180');
    nav(:,10)=(round(nav(:,10)*1000))/1000;
    
    
    baseIPOS = nav;


end

