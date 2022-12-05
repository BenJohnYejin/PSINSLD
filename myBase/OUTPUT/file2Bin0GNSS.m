function []= file2Bin0GNSS(datapath,fileNameGNSS,fileNameNav,fileNameOut,Type)
    format longG; glvs;
    fs = 100;ts = 1/fs;
    datapath0 = [datapath,'\dy\'];
    datapath1 = [datapath,'\IPOS3\'];
    %%
    gps = binfile([datapath1,fileNameGNSS],15);
    gps(gps(:,end)<100,:) = [];
    gps(gps(:,9) == 0,:) = [];
    [navIPOS3,IMU] = Slove58Bytes([datapath1,fileNameNav]);
    navIPOS3(:,end) = navIPOS3(:,end)+18;
    navIPOS3(navIPOS3(:,end)<navIPOS3(1,end),:)=[];
    
%     [navIPOS3,IMU] = file2DataDY([datapath0,fileNameNav]);
%     IMU(IMU(:,end)<IMU(1,end),:)=[];
%     IMU(IMU(:,end) > IMU(end,end),:) = [];
    %%
    glvs;plot(gps(:,end),gps(:,9)/glv.deg);grid on;
    if (Type)
        imuplot(IMU(:,[1:6,end]));
         delt = 18;
        %GNSSflag 与 里程计速度
        gpsvel= [];
        IMU(IMU(:,7) > 90,:) = [];
%         IMU(:,7) = IMU(:,7)*0.868;
        gpsvel(:,1)=sqrt(gps(:,1).*gps(:,1)+gps(:,2).*gps(:,2)+gps(:,3).*gps(:,3));
        gpsvel(:,2)=gps(:,7);
        gpsvel(:,3)=gps(:,end);
        gpsvel(gpsvel(:,1) < 0.05,:)=[];
        [~,indexIMU,indexGPS]=intersect(IMU(:,end)+delt,gpsvel(:,end));
        kOD=sum(gpsvel(indexGPS,1))/sum(abs(IMU(indexIMU,7)));
        figure;
        plot(IMU(indexIMU,end)+delt,abs(IMU(indexIMU,7)),'r.-');
        hold on;plot(gpsvel(indexGPS,end),abs(gpsvel(indexGPS,1)),'b.-');
        hold on;plot(gpsvel(indexGPS,end),gpsvel(indexGPS,2),'k.-');
        grid on;
        legend('odsmo','gpsvel','flag');
        str = sprintf('OD was %0.3f',kOD);
        title(str)
        
        %IPOS3实际轨迹与丢失路段绘制
        IPOS3plot(navIPOS3(navIPOS3(:,7)>0.1,[1:9,10:11,end]));
        
        %gps与导航比较
        myfigure;gps(gps(:,9) == 0,:)=[];
        [~,indexins,indexgps]=intersect(navIPOS3(:,end),gps(:,15));
        insgps=[];
        insgps(:,[4:6,7:9,3,10]) = gps(:,[2,1,3,4,5,6,9,end]);
        insgps(indexgps,[1:2,10]) = navIPOS3(indexins,[1:2,end]);
        err = avpcmpplot(insgps,navIPOS3(:,[1:3,5,4,6,7:9,end]),'mu');
        
    end
    %%
    gpsBase=[];
    gpsBase(:,[1:7,8:11]) = gps(:,[4:6,7,1:3,8,11,9,10]);
    gpsBase(:,21:25)=gps(:,[14,11:13,15]);
    gpsBase = gpsBase(:,[end,1:end-1]);

    % ODT = IMU(:,[7,end]);ODT(:,end) = ODT(:,end)-0.8;
    % [~,indexIMU,indexOD]=intersect(IMU(:,end),ODT(:,end));
    % IMU(indexIMU,7) = ODT(indexOD,1);

    IMU = imurepair(IMU);
    data = [];
    [~,indexImu,indexGps]=intersect(IMU(:,end)+18,gpsBase(:,1));
    data(:,1:7)  =  IMU(:,1:7);
    data(indexImu,8:31)=gpsBase(indexGps,2:25);
    data(:,32) = IMU(:,end);

    index=find(data(:,9)~=0);
    if (length(index)>1)
        data=data(index(1):index(end),:);
        data = data(:,[end,1:end-1]);
    end
    binfile([datapath1,fileNameOut], data);
    