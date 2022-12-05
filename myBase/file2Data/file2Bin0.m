%% �������� matlab�ű�
%  A14b��׼  IPOS3����  GNSS NIME��ʽ����
%  ��ͼ��ԭʼ���ݣ�IMU,OD,GNSSFLAG��IPOS3flag��  
%  GNSS���׼�Ա�  IPOS3���׼�Ա�
%  ���ɷ������ݣ� imu_gps_base 32������
%  2022/03/21 ����  
function []= file2Bin0(datapath,fileNameBase,fileNameGNSS,fileNameNav,fileNameOut,Type)
    format longG; glvs;
    datapath0 = [datapath,'\610\'];
    datapath1 = [datapath,'\IPOS3\'];
    
    BasePos610=binfile([datapath0,fileNameBase],10);
    gps = binfile([datapath1,fileNameGNSS],15);
%     gps(:,9) = gps(:,9)+pi/2;
    gps(gps(:,end)<100,:) = [];
    
    [navIPOS3,IMU] = Slove58Bytes([datapath1,fileNameNav]);
    navIPOS3(:,end) = navIPOS3(:,end)+18;
    navIPOS3(navIPOS3(:,end)<navIPOS3(1,end),:)=[];
    IMU(IMU(:,end)<IMU(1,end),:)=[];
    IMU(IMU(:,end) > IMU(end,end),:) = [];
    %% ��ͼ����
    if (Type)
        imuplot(IMU(IMU(:,8) == 15,[1:6,end]));
        %IPOS3ʵ�ʹ켣�붪ʧ·�λ���
        IPOS3plot(navIPOS3(navIPOS3(:,7)>0.1,[1:9,10,13,end]));
        %gps���׼�Ƚ�
        [~,indexgps,index610]=intersect(gps(:,end),BasePos610(:,end));
        insgps=[];
        insgps(:,[4:6,7:9,3,10]) = gps(:,[1,2,3,4,5,6,9,end]);
        insgps(indexgps,[1:2,10]) = BasePos610(index610,[1:2,end]);
        myfigure;err = avpcmpplot(insgps(insgps(:,7) >0,:),BasePos610,'mu');
        time = find(err(:,end)>(err(1,end)+300) & err(:,end)<(err(1,end)+8000));
        errShow(err,time);
        
        myfigure;
        err = avpcmpplot(navIPOS3(:,[1:9,end]),insgps(insgps(:,7) >0,:),'mu');
        time = find(err(:,end)>(err(1,end)+300) & err(:,end)<(err(1,end)+8000));
        [~,str]=errShow(err,time);
        
         delt = 18;
        %GNSSflag �� ��̼��ٶ�
        gpsvel= [];
        %��̼�
%         IMU(IMU(:,7) > 90,:) = [];
        IMU(:,7)=odplot(IMU(:,[7,end]),100,1,1);
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
    end
    %% �����켣���׼�Ƚ�
%     navIPOS3(end-100*100:end,:)=[];
%     navIPOS3(:,end) = navIPOS3(:,end) + 0.01;
%     IMU(:,end) = IMU(:,end);
    myfigure;err=avpcmpplot(BasePos610,navIPOS3(:,[1:3,4,5,6,7:9,end]), 'mu');
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time);
    %%
    tmp = BasePos610;
    [~,indextmp,indexGps]=intersect(tmp(:,end),gps(:,end));
    
%     %num dop ----> v5double
%     gps(:,8)=v5double([gps(:,8),gps(:,14)*10]);
%     %POS std*3  ---> v5double
%     gps(:,11)=v5double(gps(:,11:13)*10);
  
%     gpsBase=[];
%     gpsBase(:,12:21)=tmp(:,[7:9,1:3,4:6,10]);
%     gpsBase(indextmp,[1:7,8:11]) = gps(indexGps,[4:6,7,1:3,8,11,9,10]);
%     gpsBase(:,end+1)=0;
%     gpsBase = gpsBase(:,[end,1:end-1]);
    baseVel = sqrt(tmp(:,4).^2+tmp(:,5).^2+tmp(:,6).^2);
    gpsBase=[];
    gpsBase(:,[12:20,25])=tmp(:,[7:9,1:3,4:6,10]);
    gpsBase(indextmp,[1:7,8:11]) = gps(indexGps,[4:6,7,1:3,8,11,9,10]);
    gpsBase(indextmp,21:24)=gps(indexGps,[14,11:13]);
    gpsBase(:,end+1) = baseVel;
    gpsBase = gpsBase(:,[end,1:end-1]);
            
    [~,indexImu,indexGps]=intersect(IMU(:,end)+18,gpsBase(:,end));
    
    data(:,1:6)  =  IMU(:,1:6);
    data(indexImu,7:31)=gpsBase(indexGps,1:25);
    data(:,32) = IMU(:,end);
    
%     data(:,1:7)  =  IMU(:,1:7);
%     data(indexImu,8:31)=gpsBase(indexGps,2:25);
%     data(:,32) = IMU(:,end);
    
%     data(:,1:7)  =  IMU(:,1:7);
%     data(indexImu,8:28)=gpsBase(indexGps,2:end);
%     data(:,28) = IMU(:,end);
    
%     [~,indexOD,indexData]=intersect(OD(:,end),data(:,end));
%     data(indexData(1):length(OD)+indexData(1)-1,7) = OD(:,1);
    
    index=find(data(:,9)~=0);
    if (length(index)>1)
        data=data(index(1):index(end),:);
        data = data(:,[end,1:end-1]);
    end
    %%
    binfile([datapath1,fileNameOut], data);
end



