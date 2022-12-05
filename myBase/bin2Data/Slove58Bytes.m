
%ipos3 58字节解析
%2022、3、24修改  去除掉线后数据
function [ nav,imu ] = Slove58Bytes( fileName )
glvs;ts = 0.01;
    fid=fopen([fileName],'rb');%打开文件
    nav =[];imu=[];
    if(fid == -1) 
        nav=0;
        imu=0;
        return;
    end
    
    for j=1:1000
        head = fread(fid,1,'uint8'); 
        if (189 == head)
            break;
        end
    end
    %Att
    fseek(fid,j+2,-1);Roll = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+4,-1);Pitch = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+6,-1);Yaw = fread(fid,[1,inf],'int16',56);    
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
    %Vel
    fseek(fid,j+32,-1);VnE = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+34,-1);VnN = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+36,-1);VnU = fread(fid,[1,inf],'int16',56);
    %flag
    fseek(fid,j+38,-1);flag = fread(fid,[1,inf],'uint8',57);
    %Statue
    fseek(fid,j+42,-1);Statue = fread(fid,[1,inf],'uint8',57);
    %OD
    fseek(fid,j+43,-1);OD = fread(fid,[1,inf],'int16',56);
    
    %Data for Type
    fseek(fid,j+45,-1);Data1 = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+47,-1);Data2 = fread(fid,[1,inf],'int16',56);
    fseek(fid,j+49,-1);Data3 = fread(fid,[1,inf],'int16',56);
    
    %Time
    fseek(fid,j+51,-1);Second = fread(fid,[1,inf],'uint32',54);
    %Type
    fseek(fid,j+55,-1);Type = fread(fid,[1,inf],'uint8',57);
    %back
    fseek(fid,j+56,-1);back = fread(fid,[1,inf],'uint8',57);    
    Length = length(back); 
%%
    fseek(fid,j-1,-1); check = fread(fid,[58,inf],'uint8',0);
    check = check';
%%  校验
    Second = Second / 4e3;  Second = round(Second*100)/100;
    check0 = check(:,1);
    for j =2:57
       check0 =  bitxor(check0,check(:,j));
    end
    
    index = find(check0 ~= check(:,58));
    
    if( length(index) >0)
        strPos = findstr(fileName,'.');
        fileNameOut = fileName;
        fileNameOut(strPos(:,end):end) = '.log';
        fdOut = fopen(fileNameOut,'w');
        str = sprintf('%s has check error. \n',fileName);
        
        for j = 1:length(index)
            str = [str ,sprintf('time was %.3f s, index was %8.0f, check error! \n',Second(index(j)-1)+ts,index(j))];
        end
        fwrite(fdOut,str);
        fclose(fdOut);
    end
%%
    %舍去不完整的数据，最多一行
    Roll = Roll(1:Length);Pitch = Pitch(1:Length);Yaw = Yaw(1:Length);
    Gyrx = Gyrx(1:Length);Gyry = Gyry(1:Length);Gyrz = Gyrz(1:Length);
    Accx = Accx(1:Length);Accy = Accy(1:Length);Accz = Accz(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Second = Second(1:Length)';
%     Statue = Statue(1:Length)';
    flag = flag(1:Length)';
    Data1 = Data1(1:Length)';
    Data2 = Data2(1:Length)';
    Data3 = Data3(1:Length)';
    OD = OD(1:Length)';Type = Type(1:Length)';
    
    %协议转换
%     glv.g0 = 9.80;
    
    Att = [Roll;Pitch;Yaw]';Att = Att*360/32768;
    Gyr = [Gyry;Gyrx;-Gyrz]';Gyr = Gyr*300/32768;Gyr = Gyr * glv.deg * ts ;
    Acc = [Accy;Accx;-Accz]';Acc = Acc*12/32768; Acc = Acc * glv.g0 * ts ;
%     Acc = Acc ;
    Pos = [Lat;Lon;Hgt]';Pos(:,1:2) = Pos(:,1:2) * 1e-7;Pos(:,3) = Pos(:,3) * 1e-3;
    Vn = [VnN;VnE;VnU]'; Vn = Vn *100/32768;
    %
%     Second = Second / 4e3;  Second = round(Second*100)/100;
    OD = OD/100;
    OD1 = (Vn(:,1).^2+ Vn(:,2).^2+ Vn(:,3).^2).^0.5;
    
    nav = [Att,Vn,Pos,Data1,Data2,Data3,Type,flag,Second];
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.deg;
    nav( 15 ~= nav(:,end-1) ,:) = [];
    
    nav(nav(:,13) == 0,10:12) = exp(nav(nav(:,13) == 0,10:12)/100);
    nav(nav(:,13) == 1,10:12) = exp(nav(nav(:,13) == 1,10:12)/100);
    nav(nav(:,13) == 2,10:12) = exp(nav(nav(:,13) == 2,10:12)/100);
    nav(nav(:,13) == 22,10) = nav(nav(:,13) == 22,10)*200/32768;
    
    
    imu = [Gyr,Acc,OD,flag,Second];
    imu(15 ~= imu(:,end-1),:) = [];
%     index = find(diff(nav(:,end))>0.1);
%     if ~isempty(index)
%        powerOFF =  index(1);
%        nav(powerOFF-10*100:end,:)=[];
%        imu(powerOFF-10*100:end,:)=[];
%     end
    fclose(fid);
end

