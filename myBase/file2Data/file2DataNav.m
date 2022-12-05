%读取后处理数据
%nav time 2 pos 3:5  vel 6:8  att 9:11
%base
function [ baseNav ] = file2DataNav( datapath,fileName )
glvs;
    nav0=load([datapath,fileName]); 
    nav1= nav0(:,[9:11,6:8,3:5,2]); 
    nav1(:,[1:3,7,8]) = nav1(:,[2,1,3,7,8])*glv.dps;
    nav1(:,3)=yawcvt(nav1(:,3),'c360cc180'); 
    nav1(:,10)=(round(nav1(:,10)*1000))/1000+18;
    
    baseNav=nav1;
end

