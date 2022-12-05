%% �������� matlab�ű�
%  A14b��׼  IPOS3����  GNSS NIME��ʽ����
%  ��ͼ��ԭʼ���ݣ�IMU,OD,GNSSFLAG��IPOS3flag��  
%  GNSS���׼�Ա�  IPOS3���׼�Ա�
%  ���ɷ������ݣ� imu_gps_base 28������
%  2022/03/21 ����  
%%
function []= file2Bin1(datapath,fileNameBase,fileNameGNSS,fileNameNav,fileNameOut)
format longG; glvs;
datapath0 = [datapath,'\610\'];
datapath1 = [datapath,'\dy\'];
%%
%��׼���ݴ���
BasePos610=binfile([datapath0,fileNameBase],10);
BasePos610(end-100*100:end,:)=[];
% gps = binfile([datapath1,fileNameGNSS],15);
% [navIPOS3,IMU] = Slove63BytesDY([datapath1,fileNameNav]);
% GPS = load([datapath1,fileNameGNSS]);
% gps = GPS(:,[7,6,8,3:5,15,17,10,11,12:14,16,2]);
% gps(:,9)=yawcvt(gps(:,9),'c360cc180');
% gps(gps(:,9)  ~= 0 ,9) = gps(gps(:,9)  ~= 0,9) - pi/2;
% gps(gps(:,9)<-pi+0.01*pi,9) = gps(gps(:,9)<-pi+0.01*pi,9) + 2*pi;
% 
% [~,indexgps,index610]=intersect(gps(:,end),BasePos610(:,end));
% insgps=[];
% insgps(:,[4:6,7:9,3,10]) = gps(:,[1,2,3,4,5,6,9,7]);
% insgps(indexgps,[1:2,11]) = BasePos610(index610,[1:2,end]);
% insgps(insgps(:,end)<100,:) = [];


[navDY,IMU] = file2DataDY([datapath1,fileNameNav]);
% navDY(1:24*100,:) = [];
% IMU(1:24*100,:) = [];
IMU(IMU(:,end)<IMU(1,end) | IMU(:,end)>IMU(end,end),:)=[];
navDY(navDY(:,end)<navDY(1,end) | navDY(:,end)>navDY(end,end),:)=[];
%% ��ͼ����
%% ԭʼ����
%IMU
imuplot(IMU(:,[1:6,end]));
%��̼�
% odplot(IMU(:,[7,end]),5,1,1);
% IMU = imurepair(IMU);
% IMU(:,1:3) = IMU(:,1:3);
%IPOS3ʵ�ʹ켣�붪ʧ·�λ���
% IPOS3plot(navDY(navDY(:,7)>0.1,[1:9,10:11,end]));
%gps���׼�Ƚ�
% [~,indexgps,index610]=intersect(gps(:,end),BasePos610(:,end));
% insgps=[];
% insgps(:,[4:6,7:9,3]) = gps(:,[1:6,9]);
% insgps(indexgps,[1:2,10]) = BasePos610(index610,[1:2,end]);
% insgps(insgps(:,end) < 100,:) = [];
% myfigure;avpcmpplot(BasePos610,insgps(insgps(:,7)>0 & insgps(:,8)>0,:),'mu');
%% �����켣���׼�Ƚ�
% BasePos610(:,9) = BasePos610(:,9)+13.5;
% navDY(navDY(:,7) < 0.0001,:) = [];
% % insplot(navDY(:,[1:9,end]));
% figure;plot(navDY(:,end),[0.01;diff(navDY(:,end))]);grid on;
% navDY(diff(navDY(:,end))<0.005,:)=[];
myfigure;err=avpcmpplot(BasePos610,navDY(:,[1:3,4,5,6,7:9,end]), 'mu');
time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
[~,str]=errShow(err,time);
[~,str]=errShow1(err,time);
%% ����bin����
% [~,indexIMU,indexGPS]=intersect(IMU(:,end),gps(:,end));
% gpsvel= [];
% gpsvel(:,1)=sqrt(gps(:,1).*gps(:,1)+gps(:,2).*gps(:,2)+gps(:,3).*gps(:,3));
% kOD=sum(gpsvel(indexGPS,1))/sum(IMU(indexIMU,7));
% IMU(:,7)=IMU(:,7)*kOD;
% IMU(:,7)=IMU(:,7)*ts;
% IMU(:,7)=odplot(IMU(:,[7,end]),100);
% figure;
% % plot(IMU(indexIMU,end),IMU(indexIMU,7),'r.-');
% hold on;plot(gps(indexGPS,end),gpsvel(indexGPS,1),'b.-');
% hold on;plot(gps(indexGPS,end),gps(indexGPS,7),'k.-');
% grid on;
% legend('odsmo','gpsvel','flag');
% %%
% %%
%     tmp = BasePos610;
%     [~,indextmp,indexGps]=intersect(tmp(:,end),gps(:,end));
%     
% %     %num dop ----> v5double
% %     gps(:,8)=v5double([gps(:,8),gps(:,14)*10]);
% %     %POS std*3  ---> v5double
% %     gps(:,11)=v5double(gps(:,11:13)*10);
%   
% %     gpsBase=[];
% %     gpsBase(:,12:21)=tmp(:,[7:9,1:3,4:6,10]);
% %     gpsBase(indextmp,[1:7,8:11]) = gps(indexGps,[4:6,7,1:3,8,11,9,10]);
% %     gpsBase(:,end+1)=0;
% %     gpsBase = gpsBase(:,[end,1:end-1]);
% 
%     gpsBase=[];
%     gpsBase(:,[12:20,25])=tmp(:,[7:9,1:3,4:6,10]);
%     gpsBase(indextmp,[1:7,8:11]) = gps(indexGps,[4:6,7,1:3,8,11,9,10]);
%     gpsBase(indextmp,21:24)=gps(indexGps,[14,11:13]);
%     gpsBase(:,end+1) = 0;
%     gpsBase = gpsBase(:,[end,1:end-1]);
%             
%     [~,indexImu,indexGps]=intersect(IMU(:,end)+18,gpsBase(:,end));
%     
%     data(:,1:7)  =  IMU(:,1:7);
%     data(indexImu,8:31)=gpsBase(indexGps,2:25);
%     data(:,32) = IMU(:,end);
%     
% %     data(:,1:7)  =  IMU(:,1:7);
% %     data(indexImu,8:28)=gpsBase(indexGps,2:end);
% %     data(:,28) = IMU(:,end);
%     
% %     [~,indexOD,indexData]=intersect(OD(:,end),data(:,end));
% %     data(indexData(1):length(OD)+indexData(1)-1,7) = OD(:,1);
%     
%     index=find(data(:,9)~=0);
%     if (length(index)>1)
%         data=data(index(1):index(end),:);
%         data = data(:,[end,1:end-1]);
%     end
% %%
% binfile([datapath1,fileNameOut], data);