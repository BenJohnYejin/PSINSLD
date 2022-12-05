%解析84字节协议
% fid 文件句柄
% Data 数据
% [att,vn,pos,statue,second]
function [Data] = Solve84Bytes(pathName,fileName)
    fid=fopen([pathName,fileName],'rb');%打开文件
    for j=1:1000
        head = fread(fid,1,'uint8'); 
        if (85 == head)
            head = [head;fread(fid,3,'uint8')]; 
            break;
        end
    end
    %Statue
    fseek(fid,j+11,-1);Statue = fread(fid,[1,inf],'uint8',83);
    %time
%     fseek(fid,j+15,-1);Year = fread(fid,[1,inf],'uint16',82);
%     fseek(fid,j+17,-1);Month = fread(fid,[1,inf],'uint8',83);
%     fseek(fid,j+18,-1);Day = fread(fid,[1,inf],'uint8',83);
    fseek(fid,j+19,-1);Second = fread(fid,[1,inf],'uint32',80);Second = Second*0.01;
    %pos
    fseek(fid,j+23,-1);Lat = fread(fid,[1,inf],'int32',80);Lat = Lat*180/2147483647;
    fseek(fid,j+27,-1);Lon = fread(fid,[1,inf],'int32',80);Lon = Lon*90/2147483647;
    fseek(fid,j+31,-1);Hgt = fread(fid,[1,inf],'int32',80);
    %Vn
    fseek(fid,j+35,-1);VnE = fread(fid,[1,inf],'int32',80);VnE = VnE*0.01;
    fseek(fid,j+39,-1);VnN = fread(fid,[1,inf],'int32',80);VnN = VnN*0.01;
    fseek(fid,j+43,-1);VnU = fread(fid,[1,inf],'int32',80);VnU = VnU*0.01;
    %Att
    fseek(fid,j+63,-1);Yaw = fread(fid,[1,inf],'uint16',82);Yaw = Yaw*360/65535;
    fseek(fid,j+65,-1);Pitch = fread(fid,[1,inf],'int16',82);Pitch = Pitch*90/32767;
    fseek(fid,j+67,-1);Roll = fread(fid,[1,inf],'int16',82);Roll = Roll*90/32767;
    %back
    fseek(fid,j+83,-1);Back = fread(fid,[1,inf],'uint8',83);
    %
    Length = length(Back);
    Pitch = Pitch(1:Length);Roll = Roll(1:Length);Yaw = Yaw(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    Statue = Statue(1:Length);Second = Second(1:Length);
    %Data
    Data=[Pitch;Roll;Yaw;VnE;VnN;VnU;Lat;Lon;Hgt;Statue;Second]';
    Data(1,:) = [];
    Data(4 == Data(:,end-1),:) = [];
    Data(192 == Data(:,end-1),:) = [];
    
    fclose(fid);
end

