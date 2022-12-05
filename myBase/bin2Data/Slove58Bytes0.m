
%ipos3 58字节解析
%
function [ tmp,imu ] = Slove58Bytes0( pathName,fileName )
glvs;ts = 0.01;
    fid=fopen([pathName,fileName],'rb');%打开文件
    for j=1:58
        head = fread(fid,1,'uint8'); 
        if (189 == head)
            break;
        end
    end
    %Att
    fseek(fid,j+2,-1);OD0 = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+4,-1);yawRMS = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+6,-1);yawGNSS = fread(fid,[1,inf],'int16',56);    
    %Gyr
    fseek(fid,j+8,-1);Gyrx = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+10,-1);Gyry = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+12,-1);Gyrz = fread(fid,[1,inf],'int16',56);
    %Acc
    fseek(fid,j+14,-1);Accx = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+16,-1);Accy = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+18,-1);Accz = fread(fid,[1,inf],'int16',56);
    %Pos
    fseek(fid,j+20,-1);Lon = fread(fid,[1,inf],'int32',54);
    fseek(fid,j+24,-1);Lat = fread(fid,[1,inf],'int32',54);
    fseek(fid,j+28,-1);Hgt = fread(fid,[1,inf],'int32',54);
%     %Vel
    fseek(fid,j+32,-1);VnE = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+34,-1);VnN = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+36,-1);VnU = fread(fid,[1,inf],'int16',56);
%     %Statue
%     fseek(fid,j+38,-1);Statue = fread(fid,[1,inf],'uint8',57);
%     %OD
    fseek(fid,j+43,-1);OD = fread(fid,[1,inf],'int16',56);
%     %Time
    fseek(fid,j+51,-1);Second = fread(fid,[1,inf],'uint32',54);
%     %back
    fseek(fid,j+56,-1);back = fread(fid,[1,inf],'uint8',57);
    Length = length(back); 
    
    %舍去不完整的数据，最多一行
%     Roll = Roll(1:Length);Pitch = Pitch(1:Length);Yaw = Yaw(1:Length);
    Gyrx = Gyrx(1:Length);Gyry = Gyry(1:Length);Gyrz = Gyrz(1:Length);
    Accx = Accx(1:Length);Accy = Accy(1:Length);Accz = Accz(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Second = Second(1:Length)';
%     Statue = Statue(1:Length)';
    OD0 = OD0(1:Length)';yawRMS = yawRMS(1:Length)';yawGNSS = yawGNSS(1:Length)';
    OD = OD(1:Length)';
    %协议转换
%     Att = [Roll;Pitch;Yaw]';Att = Att*360/32768;
    Gyr = [Gyry;Gyrx;-Gyrz]';Gyr = Gyr*300/32768;Gyr = Gyr * glv.deg * ts ;
    Acc = [Accy;Accx;-Accz]';Acc = Acc*12/32768;Acc = Acc * glv.g0 * ts ;
%     Pos = [Lat;Lon;Hgt]';Pos(:,1:2) = Pos(:,1:2) * 1e-7;Pos(:,3) = Pos(:,3) * 1e-3;
    Pos = [Lon;Lat;Hgt]';Pos(:,1:2) = Pos(:,1:2)/180*pi/1*1e-7;Pos(:,3) = Pos(:,3) * 1e-3;
    Vn = [VnE;VnN;VnU]'; Vn = Vn *100/32768;
    Second = Second / 4e3;
    Second = round(Second*1000)/1000;
    OD0 = OD0/100;
    OD = OD/100;yawGNSS=yawGNSS/180*pi*360/32768;
    tmp = [Vn,Pos,OD,OD0,yawGNSS,yawRMS,Second];
    imu = [Gyr,Acc,OD0,Second];
%     nav = [Att,Vn,Pos,Statue,Second];
%     nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.deg;
%     nav(nav(:,10)==0,:)=[];
%     nav(nav(:,11)==0,:)=[];
%     
%     imu = [Gyr,Acc,OD,Second];
    fclose(fid);
end

