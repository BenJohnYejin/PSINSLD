%A14    time 4 POS 5~7 VEL 8~10  ATT 16 17 15
%baseA14  avpt
function baseA14 = file2DataA14(datapath0,fileName,Count)
glvs;
    a140=load([datapath0,fileName]);            
    a14(:,1) = round((a140(:,4)+Count*24*3600-8*3600+18)*1000)/1000; %-0.08;
    %使用a14代替主惯导
    a140(:,[5:6,13:15])=a140(:,[6,5,16,17,15])*glv.deg;
    a140(:,15)=yawcvt(a140(:,15),'c360cc180');
    base(:,2:4)=a140(:,5:7);
    base(:,[5,6,7])=a140(:,[13,14,15]);
    base(:,8:10)=a140(:,8:10);
    base(:,1)=a14(:,1);
    
    baseA14=base(:,[6,5,7,8:10,2:4,1]);
end

