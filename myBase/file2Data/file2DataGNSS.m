%
%
function [ LAT,k ] = file2DataGNSS(fileName)
glvs;
gps=fopen(fileName,'r');
%%
s10='$GPGGA';s11='BDGGA';s12='GNGGA';
s20='HEADING';
s30='#BESTVELA';s31='GPVTG';s32='#BEST';
s40='GNGST';s41='GPGST';s42='BDGST';
s60='GNZDA';
%%
k=0;LAT=zeros(500,20);
posValid = 0;
yawValid = 0;
velValid = 0;
Yaw = zeros(1,5);
Vel = zeros(1,6);
stdPos = zeros(1,4);
Pos = zeros(1,7);
Time = zeros(1,4);
%%
while ~feof(gps)
    charLine = fgets(gps);
    %1 GGA
    if (~isempty(strfind(charLine,s10))  ) 
        cellLine=strsplit(charLine,',');
        
        if length(cellLine) < 12
            lat=0;
            lon=0;
            hgt=0;
            glag=0;
            num=0;
            dop=0;
            second = 0;
        else
            temp1=fix(str2num(cellLine{3})/100);
            lat=temp1+(str2num(cellLine{3})-temp1*100)/60;%GPGGA是度分格式的
            lat=lat*glv.deg;

            temp2=fix(str2num(cellLine{5})/100);
            lon=temp2+(str2num(cellLine{5})-temp2*100)/60;
            lon=lon*glv.deg;

            hgt=str2num(cellLine{10}) + str2num(cellLine{12});  %考虑高程异常值！！！

            glag=str2num(cellLine{7});
            num=str2num(cellLine{8});
            dop=str2num(cellLine{9});
            second = str2num(cellLine{2});
        end
        
       if glag==4 %固定解
            glag=1;
        elseif glag==1 %单点解
            glag=5;
        elseif glag==5 
            glag=3;
        elseif glag==2
            glag=4;
        elseif glag==0
            glag=0;
        end
        Pos = [lat,lon,hgt,glag,num,dop,second]; 
        posValid = 1;
    end
    
    %2. BESTVEL
    if (~isempty(strfind(charLine,s30)))
        cellLine=strsplit(charLine,',');
        
        if length(cellLine) < 16
           vertvel= 0;
           horvel = 0;
           Trj_Angle = 0; 
           Week = 0;
           Second = 0;
        else
            Week = str2num(cellLine{6});
            Second = str2num(cellLine{7});
           vertvel= str2num(cellLine{16});
           horvel = str2num(cellLine{14});
           Trj_Angle = str2num(cellLine{15}); 
        end
        
        velValid = 1;
        try
            Vel = [Week,Second,horvel*sin(Trj_Angle*pi/180),horvel*cos(Trj_Angle*pi/180),vertvel,Trj_Angle];
        catch            
%             horvel = horvel(2);
%             Vel = [Week,Second,horvel*sin(Trj_Angle*pi/180),horvel*cos(Trj_Angle*pi/180),vertvel,Trj_Angle];
        end
    end 
    
    
    
    %3 ZDA
    if ( ~isempty(strfind(charLine,s60)) )
        cellLine=strsplit(charLine,',');
        
        if length(cellLine) < 5
           continue;
        end
        
        second = str2num(cellLine{2});
        day    = str2num(cellLine{3});
        mooth  = str2num(cellLine{4});
        year   = str2num(cellLine{5});
        
        
        Time = [year,mooth,day,second]; 
    end
    
    %4 GNGST
    if ( ~isempty(strfind(charLine,s40)) )
        cellLine=strsplit(charLine,',');
        
        if length(cellLine) < 9
           continue;
        end
        
        Second     = str2num(cellLine{2});
        stdPLat    = str2num(cellLine{7});
        stdPLon    = str2num(cellLine{8});
        
        cellLine   = strsplit(cellLine{9},'*');
        stdPAlt    = str2num(cellLine{1});
        
        
        stdPos = [stdPLat,stdPLon,stdPAlt,Second]; 
    end
    
    %5 Heading
    if ( ~isempty(strfind(charLine,s20)) )
        cellLine=strsplit(charLine,',');
        
        if length(cellLine) < 16
            Week       = 0;
            Second     = 0;
            baseLine   = 0;
            Yaw        = 0;
            stdYaw     = 99;
        else
            Week       = str2num(cellLine{6});
            Second     = str2num(cellLine{7});
            baseLine   = str2num(cellLine{12});
            Yaw        = str2num(cellLine{13});
            stdYaw     = str2num(cellLine{16});
        end

        yawValid   = 1;
        Yaw = [Week,Second,baseLine,Yaw,stdYaw]; 
    end
    
    
    
    % 数据格式定义
    % 1-2 时间 3-5 位置 6 flag标志位
    % 7-9 速度 10 卫星颗数  11 dop
    % 12,13,14 gps时间  基线长
    % 15 航向  
    % 16-19 std_lat,std_lon,std_high,std_yaw
    % Time
    if ( posValid == 1 && velValid==1 && yawValid == 1)
%     if ( posValid == 1 && velValid==1)
        if (length(Time)<4 || length(Pos)<7 || size(Vel,2)<6) 
            continue;
        end
        
        if (Yaw(:,2) ~=  Vel(:,2))
            continue;
        end
        if (Time(:,4)~= Pos(:,7))
            continue;
        end
        if (length(Yaw) <5) 
            Yaw = zeros(1,5);
            Yaw(:,1:2) = Vel(:,1:2);
        end
    
        k=k+1;
        LAT(k,[1:2,7:9]) = Vel(:,1:5);
        LAT(k,[3:6,10,11]) = Pos(:,[1:6]);
        LAT(k,[12:15,19]) =  Yaw(:,[1:5]);
        LAT(k,[16:18]) = stdPos(:,[1:3])';
        LAT(k,20) = Vel(:,6);
        posValid = 0;velValid = 0;yawValid =0;
        Yaw = zeros(1,5);
        Vel = zeros(1,6);
        stdPos = zeros(1,4);
        Pos = zeros(1,7);
        Time = zeros(1,4);
    end
        
end %while结束

LAT(:,15) = LAT(:,15)*glv.deg;
LAT(:,15) = yawcvt(LAT(:,15),'c360cc180');
LAT(:,20) = LAT(:,20)*glv.deg;
LAT(:,20) = yawcvt(LAT(:,20),'c360cc180');
fclose(gps);%fclose(gps_v);
end  


