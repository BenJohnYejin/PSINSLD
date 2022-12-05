function [] =IPOS3INSWordWrite(myWord,myDoc,datapath,fileNameBase,fileNameGNSS,fileNameNav,j,titleHead,isflag)
    mySelection = '';
% 
%     mySelection = myWord.Selection;
%     myContent = myDoc.Content; 
%     mySelection.Start = myContent.end;  % ����ѡ���������ʼλ��Ϊ�ĵ����ݵ�ĩβ
%     mySelection.TypeParagraph;
%     % ��ӵ�һ������
%     % ���ֵĸ�ʽ����
%     mySelection.Font.Name = '����';     % ��������
%     mySelection.Font.Size = 12;         % �����ֺ�
%     mySelection.Font.Bold = 1;          % ����Ӵ�
%     mySelection.paragraphformat.Alignment = 'wdAlignParagraphLeft'; % �������                                              
%     mySelection.paragraphformat.LineSpacingRule = 'wdLineSpace1pt'; % �о�Ϊ1.5���о�                                              
%     mySelection.paragraphs.OutlinePromote();                                             
%     mySelection.Text = sprintf('%d. %s',j,titleHead);          % ��ѡ������������������
%     mySelection.Start = mySelection.end;
%     mySelection.TypeParagraph;          % �س�������һ��
%     %%
%     myContent = myDoc.Content;
%     mySelection = myWord.Selection;
%     mySelection.Start = myContent.end;  % ����ѡ���������ʼλ��Ϊ�ĵ����ݵ�ĩβ
%     mySelection.paragraphformat.Alignment = 'wdAlignParagraphLeft'; % ���ж���
%     mySelection.paragraphformat.FirstLineIndent = 0; % ������������
%     
    %% ����
    datapath0 = [datapath,'\610\'];
    datapath1 = [datapath,'\IPOS3\'];
    BasePos610=binfile([datapath0,fileNameBase],10);
    
    [navIPOS3,IMU] = Slove58Bytes([datapath1,fileNameNav]);
    navIPOS3(:,end) = navIPOS3(:,end)+18;
    navIPOS3(navIPOS3(:,end)<navIPOS3(1,end),:)=[];
    IMU(IMU(:,end) < IMU(1,end),:)=[];
    IMU(IMU(:,end) > IMU(end,end),:) = [];
    
    GPS = load([datapath1,fileNameGNSS]);
    gps = GPS(:,[7,6,8,3:5,15,17,10,11,12:14,16,2]);
    gps(:,9)=yawcvt(gps(:,9),'c360cc180');
    gps(gps(:,9)  ~= 0 ,9) = gps(gps(:,9)  ~= 0,9) - pi/2;
    gps(gps(:,9)<-pi+0.01*pi,9) = gps(gps(:,9)<-pi+0.01*pi,9) + 2*pi;

    [~,indexgps,index610]=intersect(gps(:,end),BasePos610(:,end));
    insgps=[];
    insgps(:,[4:6,7:9,3,10]) = gps(:,[1,2,3,4,5,6,9,7]);
    insgps(indexgps,[1:2,11]) = BasePos610(index610,[1:2,end]);
    insgps(insgps(:,end)<100,:) = [];
    %%
    myfigure;err=avpcmpplot(navIPOS3(:,[1:3,4,5,6,7:9,end]), BasePos610, 'mu');
%     err=avpcmp(navIPOS3(:,[1:3,4,5,6,7:9,end]), BasePos610, 'mu');
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    disp([datapath1,fileNameNav]);
    [~,str]=errShow(err,time,1);
    [~,str]=errShow1(err,time,1);
%     hgexport(gcf,'-clipboard');close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type = 0;
%     mySelection.Start = mySelection.end;
%     
%     mySelection.Font.Bold = 1;          % ���岻�Ӵ�
%     mySelection.Font.Size = 10;         % �����ֺ�
%     mySelection.Font.Name = 'Times New Roman';     % ��������
%     mySelection.Text = str;          % ��ѡ������������������ 
    %%
    if (isflag == 1)     
        %1 IPOS3���ݶԱ�  ---  ��׼
        sub0(myDoc,mySelection,navIPOS3,IMU,BasePos610);
        %2 IPOS3���ݶԱ�  ---  GNSS
        sub1(myDoc,mySelection,navIPOS3,IMU,insgps);
        %3 GNSS���ݶԱ�   ---  ��׼
        sub2(myDoc,mySelection,insgps,BasePos610);
    end
end

function []=sub0(myDoc,mySelection,navIPOS3,IMU,BasePos610)   
    imuplot(IMU(IMU(:,8) == 15,[1:6,end]));
%     hgexport(gcf,'-clipboard');close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type = 0;
%     mySelection.Start = mySelection.end;
    
%     IPOS3plot(navIPOS3(navIPOS3(:,7)>0.1,[1:9,10,13,end]));
%     hgexport(gcf,'-clipboard');close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type = 0;
%     mySelection.Start = mySelection.end;
end

function []=sub1(myDoc,mySelection,navIPOS3,IMU,insgps)   
    gpsvel(:,1)=sqrt(insgps(:,4).*insgps(:,4)+insgps(:,5).*insgps(:,5)+insgps(:,6).*insgps(:,6));
    gpsvel(:,3)=insgps(:,end);gpsvel(:,2)=insgps(:,10);
%     gpsvel(gpsvel(:,1) < 0.05,:)=[];
    
    [~,indexIMU,indexGPS]=intersect(IMU(:,end)+18,gpsvel(:,end));
    kOD=sum(gpsvel(indexGPS,1))/sum(abs(IMU(indexIMU,7)));
    myfigure;
    plot(IMU(indexIMU,end)+18,abs(IMU(indexIMU,7)),'r.-');
    hold on;plot(gpsvel(indexGPS,end),abs(gpsvel(indexGPS,1)),'b.-');
    hold on;plot(gpsvel(indexGPS,end),gpsvel(indexGPS,2),'k.-');
    grid on;legend('odsmo','gpsvel','flag');
    title(sprintf('OD was %0.3f',kOD))
%     hgexport(gcf,'-clipboard');close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type = 7;
    
%     myfigure;err=avpcmpplot(navIPOS3(:,[1:3,4,5,6,7:9,end]),insgps(insgps(:,7)>0,[1:3,4,5,6,7:9,end]), 'mu');
%     time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
%     errShow(err,time,0);
%     hgexport(gcf,'-clipboard');close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type = 7;
end

function []=sub2(myDoc,mySelection,insgps,BasePos610)   
    myfigure;err=avpcmpplot(insgps(insgps(:,7)>0,[1:3,4,5,6,7:9,end]), BasePos610(:,:), 'mu');
%     time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
%     [~,~]=errShow(err,time,0);
%     hgexport(gcf,'-clipboard');close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type = 7;
end