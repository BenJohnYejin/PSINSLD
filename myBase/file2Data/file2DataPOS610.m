%  pos610  1 time 6:8 pos 9:11 att 12:14 vel  
%  basePOS610  avpt
function [ basePOS610 ] = file2DataPOS610( datapath,fileName )
    base0=load([datapath,fileName]);
    base1=[base0(:,1),base0(:,[6,7])*pi/180,base0(:,8),base0(:,[9:11])*pi/180,base0(:,12:14)];
    base1(:,7)=yawcvt(base1(:,7),'c360cc180'); %%航向角有0-360转换到-180-180度；
   
    basePOS610 = base1(:,[5:7,8:10,2:4,1]);
    basePOS610(:,end)=(round(basePOS610(:,end)*1000))/1000;
end