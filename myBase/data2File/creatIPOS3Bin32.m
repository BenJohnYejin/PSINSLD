%%
% IPOS3仿真文件生成
function [ ok ] = creatIPOS3Bin32(datapath,fileNameGNSS,fileNameNav,fileNameOut,fileNameBase,isOD)
    datapath0 = [datapath,'\610\'];
    datapath1 = [datapath,'\IPOS3\'];
    flag = 0; ok = 0;
    if (~isempty(fileNameBase)) 
        BasePos610=binfile([datapath0,fileNameBase],10);
        flag = 1;
    end
    
    GPS = load([datapath1,fileNameGNSS]);
    gps = GPS(:,[7,6,8,3:5,15,17,10,11,12:14,16,2]);
    gps(:,9)=yawcvt(gps(:,9),'c360cc180');
    gps(gps(:,9)  ~= 0 ,9) = gps(gps(:,9)  ~= 0,9) - pi/2;
    gps(gps(:,9)<-pi+0.01*pi,9) = gps(gps(:,9)<-pi+0.01*pi,9) + 2*pi;
    
    [~,~,IMU,~] = Slove76Bytes([datapath1,fileNameNav]);
    
%     [navIPOS3,IMU] = Slove58Bytes([datapath1,fileNameNav]);
%     navIPOS3(:,end) = navIPOS3(:,end)+18;
%     navIPOS3(navIPOS3(:,end)<navIPOS3(1,end),:)=[];
    IMU(IMU(:,end)<IMU(1,end),:)=[];
    IMU(IMU(:,end) > IMU(end,end),:) = [];
    IMU = imurepair(IMU(:,[1:8,end]));
    
    if(flag)
        tmp = BasePos610;
        [~,indextmp,indexGps]=intersect(tmp(:,end),gps(:,end));
        gpsBase=[];
        gpsBase(:,[12:20,25])=tmp(:,[7:9,1:3,4:6,10]);
        gpsBase(indextmp,[1:7,8:11]) = gps(indexGps,[4:6,7,1:3,8,11,9,10]);
        gpsBase(indextmp,21:24)=gps(indexGps,[14,11:13]);
    else
        gpsBase=[];
        gpsBase(:,[1:7,8:11]) = gps(:,[4:6,7,1:3,8,11,9,10]);
        gpsBase(:,21:25)=gps(:,[14,11:13,15]);
    end
    
    [~,indexImu,indexGps]=intersect(IMU(:,end)+18,gpsBase(:,end));
    
    if (~isOD)
        baseVel = sqrt(tmp(:,4).^2+tmp(:,5).^2+tmp(:,6).^2);
        gpsBase(:,end+1) = baseVel;
        gpsBase = gpsBase(:,[end,1:end-1]);
        data(:,1:6)  =  IMU(:,1:6);
        data(indexImu,7:31)=gpsBase(indexGps,1:25);
        data(:,32) = IMU(:,end);
    else
        data(:,1:7)  =  IMU(:,1:7);
        data(indexImu,8:31)=gpsBase(indexGps,1:24);
        data(:,32) = IMU(:,end);
    end
    
    index=find(data(:,9)~=0);
    if (length(index)>1)
        data=data(index(1):index(end),:);
        data = data(:,[end,1:end-1]);
    end
    binfile([datapath1,fileNameOut], data);
    ok = 1;
    disp(sprintf('%s was created!',[datapath1,fileNameOut]));
end

