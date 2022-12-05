% 将实时GPS板卡输出数据转化为LAT数据
% @fileName 文件名
% @LAT 轨迹数据
function [LAT,k,Countnum]=file2DataGPS0(fileName)
gps=fopen(fileName,'r');
%%
s10='GPGGA';s11='BDGGA';s12='GNGGA';
s20='HEADI';
s30='BESTV';s31='GPVTG';
s40='GNGST';s41='GPGST';s42='BDGST';
s50='INSPV';
s60='GPZDA';
%%
k=0;LAT=zeros(100,23);
Countnum=0;
posValid = 0;
yawValid = 0;
velValid = 0;
timeValid = 0;
Yaw = zeros(5,1);
Vel = zeros(5,1);
stdPos = zeros(3,1);
Pos = zeros(6,1);
Time = zeros(4,1);
%%
while ~feof(gps)
    charLine = fgets(gps);
%     Countnum = Countnum+1;
    if (numel(charLine) < 35)
        continue;
    end
%     if (Countnum == 72)
%        disp('err'); 
%     end
    %Yaw
    if (~isempty(strfind(charLine,s20)))%找到HEADING的帧头
        numLine=str2num(getnum(charLine));
        if (numel(numLine) < 1)
            continue;
        end
        week=numLine(4);
        second=numLine(5);
        yaw=numLine(10);
        stdYaw=numLine(13);
        baseLine=numLine(9);
        if baseLine >0
            headValid = 1;
        end
        Yaw = [week,second,baseLine,yaw,stdYaw];
    end 
    %Vn
    if (~isempty(strfind(charLine,s30)) )
        numLine=str2num(getnum(charLine));
        if (numel(numLine) < 1)
            continue;
        end
        week=numLine(4);
        second=numLine(5);
        horvel=numLine(11);
        vertvel=numLine(13);
        trackAngle=numLine(12);
        velRtcmtime=numLine(10);
        if trackAngle > 0
            velValid = 1;
        end
        Vel = [week,second,horvel*sin(trackAngle*pi/180),horvel*cos(trackAngle*pi/180),vertvel];
    end
    %VEL
    if (~isempty(strfind(charLine,s31)))
        numLine=str2num(getnum(charLine));
        if (numel(numLine) < 1)
            continue;
        end
        week = 0;
        second = 0;
        trackAngle=numLine(1);
        horvel=numLine(2)*1000/3600;
        vertvel=0;
        if trackAngle > 0
            velValid = 1;
        end
        Vel = [week,second,horvel*sin(trackAngle*pi/180),horvel*cos(trackAngle*pi/180),vertvel];
    end
    %stdPos
    if (~isempty(strfind(charLine,s40)) || ~isempty(strfind(charLine,s41))  || ~isempty(strfind(charLine,s42)))%找到GNGST的帧头
        numLine=str2num(getnum(charLine));
        if (numel(numLine) < 1)
            continue;
        end
        stdLat=numLine(6);%%纬度误差
        stdLon=numLine(7);%%经度误差
        stdHgt=numLine(8);%%高度误差
        stdPos = [stdLat,stdLon,stdHgt];
    end
    %POS
    if (~isempty(strfind(charLine,s10))  )  
        numLine=str2num(getnum(charLine));
        if (numel(numLine) < 1)
            continue;
        end
        %pos
        temp1=fix(numLine(2)/100);
        lat=temp1+(numLine(2)-temp1*100)/60;%GPGGA是度分格式的
        
        temp2=fix(numLine(3)/100);
        lon=temp2+(numLine(3)-temp2*100)/60;
        
        hgt=numLine(7) + numLine(8);  %考虑高程异常值！！！
        %Num
        num=numLine(5);
        %Dop
        glag=numLine(4);
        dop=numLine(6);
        gps_rtcmtime =numLine(9);
        Pos = [lat,lon,hgt,glag,num,dop];
        if glag >0
            posValid = 1;
        end   
    end 
    %TIME
    if (~isempty(strfind(charLine,s60)))
        numLine=str2num(getnum(charLine));
%         if (numel(numLine) < 1)
%             continue;
%         end
        year=numLine(4);
        month=numLine(3);
        day=numLine(2);
        second=numLine(1);
        Time = [year,month,day,second];
        if year >0
            timeValid = 1;
        end
    end
    %数据格式定义
    % 1-2 时间 3-5 位置 6 flag标志位
    % 7-9 速度 10 卫星颗数  11 dop
    % 12,13,14 gps时间  基线长
    % 15 航向  
    % 16-19 std_lat,std_lon,std_high,std_yaw
    if ( posValid == 1 && velValid==1 && timeValid == 1)
        k=k+1;
        LAT(k,[1:2,7:9]) = Vel(:,1:5);
        LAT(k,[3:6,10,11]) = Pos(:,[1:6]);
        LAT(k,[12:15,19]) =  Yaw(:,:);
        LAT(k,[16:18]) = stdPos(:,[1:3]);
        LAT(k,[20:23]) = Time(:,[1:4]);
        posValid = 0;velValid = 0;timeValid = 0;
        Yaw = zeros(5,1);Vel = zeros(5,1);
        stdPos = zeros(3,1);Pos = zeros(6,1);
        Time = zeros(4,1);
    end
end  %while结束
fclose(gps);%fclose(gps_v);

end

