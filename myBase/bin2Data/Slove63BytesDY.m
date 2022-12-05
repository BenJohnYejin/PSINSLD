function [ nav,imu ] = Slove63BytesDY( fileName )
glvs;ts = 0.01;
    fid=fopen(fileName,'rb');%打开文件
    for j=1:10000
        head = fread(fid,1,'uint8'); 
        if (11 == head)
            break;
        end
    end
    %Att
    fseek(fid,j+0,-1);Roll = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+2,-1);Pitch = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+4,-1);Yaw = fread(fid,[1,inf],'int16',61);
    %Gyr    
    fseek(fid,j+6,-1);Gyrx = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+8,-1);Gyry = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+10,-1);Gyrz = fread(fid,[1,inf],'int16',61);
    %Acc
    fseek(fid,j+12,-1);Accx = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+14,-1);Accy = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+16,-1);Accz = fread(fid,[1,inf],'int16',61);
    %Pos
    fseek(fid,j+18,-1);Lon = fread(fid,[1,inf],'int32',59);
    fseek(fid,j+22,-1);Lat = fread(fid,[1,inf],'int32',59);
    fseek(fid,j+26,-1);Hgt = fread(fid,[1,inf],'int32',59);
    %Vel
    fseek(fid,j+30,-1);VnE = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+32,-1);VnN = fread(fid,[1,inf],'int16',61);
    fseek(fid,j+34,-1);VnU = fread(fid,[1,inf],'int16',61);
    %Statue
    fseek(fid,j+36,-1);Statue = fread(fid,[1,inf],'uint8',62);
    %OD
%     fseek(fid,j+43,-1);OD = fread(fid,[1,inf],'int16',61);
    %Time
    fseek(fid,j+49,-1);Second = fread(fid,[1,inf],'uint32',59);
    %back
    fseek(fid,j+59,-1);back = fread(fid,[1,inf],'uint8',62);
    Length = length(back); 
    
    %舍去不完整的数据，最多一行
    Roll = Roll(1:Length);Pitch = Pitch(1:Length);Yaw = -Yaw(1:Length);
    Gyrx = Gyrx(1:Length);Gyry = Gyry(1:Length);Gyrz = Gyrz(1:Length);
    Accx = Accx(1:Length);Accy = Accy(1:Length);Accz = Accz(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Second = Second(1:Length)';Statue = Statue(1:Length)';
%     OD = OD(1:Length)';
    
    %协议转换
    Att = [Roll;Pitch;Yaw]';Att = Att*360/32768;
    Gyr = [Gyry;Gyrx;-Gyrz]';Gyr = Gyr*300/32768;Gyr = Gyr * glv.deg * ts ;
    Acc = [Accy;Accx;-Accz]';Acc = Acc*12/32768;Acc = Acc * glv.g0 * ts ;
    Pos = [Lon;Lat;Hgt]';Pos(:,1:2) = Pos(:,1:2) * 1e-7;Pos(:,3) = Pos(:,3) * 1e-3;
    Vn = [VnN;VnE;VnU]'; Vn = Vn *100/32768;
    Second = Second * 0.25 * 1e-3;
    Second = round(Second*100)/100;
%     Second = Second - 0.12;
    OD = sqrt(Vn(:,1).*Vn(:,1)+Vn(:,2).*Vn(:,2)+Vn(:,3).*Vn(:,3));
    
    nav = [Att,Vn,Pos,Statue,Second];
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.deg;
    imu = [Gyr,Acc,OD,Second];
    
    nav(nav(:,end)<5000,:) = [];
    imu(imu(:,end)<5000,:) = [];
    
    nav(nav(:,end)>nav(end,end),:)=[];
    imu(imu(:,end)>imu(end,end),:)=[];
    
%     index = find(diff(nav(500*100:end,end))>10);
%     nav(index(1):end,:)=[];
%     imu(index(1):end,:)=[];
    fclose(fid);
end
