
%ipos3 76字节解析
%2022、3、24修改  去除掉线后数据
%
function [ nav,imuOri,imuBody,GNSS] = Slove76Bytes( fileName)
glvs;ts = 0.01;
%%
    fid=fopen([fileName],'rb');%打开文件
    nav =[];imuOri=[];imuBody=[];GNSS=[];check=[];
    if(fid == -1) 
        nav=0;
        imuOri=0;
        return;
    end
    
    for j=1:1000
        head = fread(fid,1,'uint8'); 
        if (189 == head)
            break;
        end
    end
    
    %Att
    fseek(fid,j+2,-1);Roll = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+4,-1);Pitch = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+6,-1);Yaw = fread(fid,[1,inf],'int16',74);    
    %Gyr
    fseek(fid,j+8,-1);Gyrx = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+10,-1);Gyry = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+12,-1);Gyrz = fread(fid,[1,inf],'int16',74);
    %Acc
    fseek(fid,j+14,-1);Accx = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+16,-1);Accy = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+18,-1);Accz = fread(fid,[1,inf],'int16',74);
    %Pos
    fseek(fid,j+20,-1);Lon = fread(fid,[1,inf],'int32',72);
    fseek(fid,j+24,-1);Lat = fread(fid,[1,inf],'int32',72);
    fseek(fid,j+28,-1);Hgt = fread(fid,[1,inf],'int32',72);
    %Vel
    fseek(fid,j+32,-1);VnE = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+34,-1);VnN = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+36,-1);VnU = fread(fid,[1,inf],'int16',74);
    %flag
    fseek(fid,j+38,-1);flag = fread(fid,[1,inf],'uint8',75);
    %Statue
    fseek(fid,j+42,-1);Statue = fread(fid,[1,inf],'uint8',75);
    %OD
    fseek(fid,j+43,-1);OD = fread(fid,[1,inf],'int16',74);
    
    %Data for Type
    fseek(fid,j+45,-1);Data1 = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+47,-1);Data2 = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+49,-1);Data3 = fread(fid,[1,inf],'int16',74);
    
    %Time
    fseek(fid,j+51,-1);Second = fread(fid,[1,inf],'uint32',72);
    %Type
    fseek(fid,j+55,-1);Type = fread(fid,[1,inf],'uint8',75);
%%
    %check
    fseek(fid,j-1,-1); check = fread(fid,[76,inf],'uint8',0);
    check = check';
%%  校验
    Second = Second / 4e3;  Second = round(Second*100)/100;
    %
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
            str = [str ,sprintf('time was %.3f s, index was %8.0f( 0x%s ), check error! \n',Second(index(j)-1)+ts,index(j),dec2hex(index(j)))];
        end
        fwrite(fdOut,str);
        fclose(fdOut);
    end
    
%%
    Length = length(check); 
    %舍去不完整的数据，最多一行
    Roll = Roll(1:Length);Pitch = Pitch(1:Length);Yaw = Yaw(1:Length);
    Gyrx = Gyrx(1:Length);Gyry = Gyry(1:Length);Gyrz = Gyrz(1:Length);
    Accx = Accx(1:Length);Accy = Accy(1:Length);Accz = Accz(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Second = Second(1:Length)';Statue = Statue(1:Length)';
    flag = flag(1:Length)';
    Data1 = Data1(1:Length)';
    Data2 = Data2(1:Length)';
    Data3 = Data3(1:Length)';
    OD = OD(1:Length)';Type = Type(1:Length)';
    
%%  
    %协议转换
    Att = [Roll;Pitch;Yaw]';Att = Att*360/32768;
    Gyr = [Gyry;Gyrx;-Gyrz]';Gyr = Gyr*300/32768;Gyr = Gyr * glv.deg * ts ;
    Acc = [Accy;Accx;-Accz]';Acc = Acc*12/32768; Acc = Acc * glv.g0 * ts ;
    Pos = [Lat;Lon;Hgt]';Pos(:,1:2) = Pos(:,1:2) * 1e-7;Pos(:,3) = Pos(:,3) * 1e-3;
    Vn = [VnN;VnE;VnU]'; Vn = Vn *100/32768;
    
    OD = OD/100;
%     OD1 = (Vn(:,1).^2+ Vn(:,2).^2+ Vn(:,3).^2).^0.5;
    
    nav = [Att,Vn,Pos,Data1,Data2,Data3,Type,flag,Second];
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.deg;
    nav( 15 ~= nav(:,end-1) ,:) = [];
    
    nav(nav(:,13) == 0,10:12) = exp(nav(nav(:,13) == 0,10:12)/100);
    nav(nav(:,13) == 1,10:12) = exp(nav(nav(:,13) == 1,10:12)/100);
    nav(nav(:,13) == 2,10:12) = exp(nav(nav(:,13) == 2,10:12)/100);
    nav(nav(:,13) == 22,10) = nav(nav(:,13) == 22,10)*200/32768;
    
    
    imuOri = [Gyr,Acc,OD,flag,Second];
    imuOri(15 ~= imuOri(:,end-1),:) = [];
    
%%
    fseek(fid,j+57,-1);Gyrx0 = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+59,-1);Gyry0 = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+61,-1);Gyrz0 = fread(fid,[1,inf],'int16',74);

    fseek(fid,j+63,-1);Accx0 = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+65,-1);Accy0 = fread(fid,[1,inf],'int16',74);
    fseek(fid,j+67,-1);Accz0 = fread(fid,[1,inf],'int16',74);
    
    fseek(fid,j+69,-1);Type0 = fread(fid,[1,inf],'uint8',75);
    fseek(fid,j+70,-1);
    Data40 = fread(fid,[1,inf],'int32',72);
    fseek(fid,j+70,-1);
    Data41 = fread(fid,[1,inf],'float',72);
    fseek(fid,j+70,-1);
    Data42 = fread(fid,[1,inf],'uint16',74);
    
    fseek(fid,j+74,-1);back0 = fread(fid,[1,inf],'uint8',75);
    
    fclose(fid);
%%
    Length = length(back0);
    Gyrx0 = Gyrx0(1:Length);Gyry0 = Gyry0(1:Length);Gyrz0 = Gyrz0(1:Length);
    Accx0 = Accx0(1:Length);Accy0 = Accy0(1:Length);Accz0 = Accz0(1:Length);
    Type0 = Type0(1:Length)';Data40 = Data40(1:Length)';Data41 = Data41(1:Length)';
    Second = Second(1:Length);OD = OD(1:Length);flag = flag(1:Length);
    
%%
    Gyr = [Gyry0;Gyrx0;-Gyrz0]';Gyr = Gyr*300/32768;Gyr = Gyr * glv.deg * ts ;
    Acc = [Accy0;Accx0;-Accz0]';Acc = Acc*12/32768; Acc = Acc * glv.g0 * ts ;
    
    GNSSFlag = bitand(Type0,15);
    Type2    = bitand(Type0,240)/16;
    
%     Data4(Type2 == 0 | Type2 == 1, :) = Data4(Type2 == 0 | Type2 == 1, :)*10e7;
%     Data4(Type2 == 3, :) = Data4(Type2 == 3, :)*10e3;
    
    imuBody = [Gyr,Acc,OD,flag,Second];
    GNSS = [Data41,Type2,GNSSFlag,flag,Second];
    
    Data40(Type2 == 1 | Type2 == 0) = Data40(Type2 == 1 | Type2 == 0)/10e6;
    Data40(Type2 == 2) = Data40(Type2 == 2)/10e2;
    
    index = (Type2 == 0 | Type2 == 1 | Type2 == 2);   
    GNSS(index,1) = Data40(index);
    
    index = (Type2 == 12);   
    GNSS(index,1) = Data42(index);   
    
    imuBody(15 ~= imuBody(:,end-1),:) = [];
    GNSS(15 ~= GNSS(:,end-1),:) = [];
    index = (diff(GNSS(:,2))==0);
    GNSS(index,:) = [];
    index = find(diff(diff(GNSS(:,2))~=1 & diff(GNSS(:,2))~=-15)==-1);
    GNSS(1:index,:)=[];

%%
    posLat = GNSS(GNSS(:,2) == 0,1);posLon = GNSS(GNSS(:,2) == 1,1);posHgt = GNSS(GNSS(:,2) == 2,1);
    vnE    = GNSS(GNSS(:,2) == 3,1);vnN    = GNSS(GNSS(:,2) == 4,1);vnU    = GNSS(GNSS(:,2) == 5,1);
    posStdE= GNSS(GNSS(:,2) == 6,1);posStdN= GNSS(GNSS(:,2) == 7,1);posStdU= GNSS(GNSS(:,2) == 8,1);
    yawGNSS= GNSS(GNSS(:,2) == 9,1);Hoop   = GNSS(GNSS(:,2) == 10,1);yawRMS= GNSS(GNSS(:,2) == 11,1);
    INSFLAG= GNSS(GNSS(:,2) == 12,1);gnssFLAG= GNSS(GNSS(:,2) == 12,[3,end]);
%%
%     timeInter = intersect(posLat(:,end),INSFLAG(:,end));
    GNSS = [posLat,posLon,posHgt,vnE,vnN,vnU,posStdE,posStdN,posStdU,yawGNSS,Hoop,yawRMS,INSFLAG,gnssFLAG];
    glvs;
    GNSS(:,[1:2,10]) = GNSS(:,[1:2,10])*glv.deg;
    GNSS(:,10)=yawcvt(GNSS(:,10),'c360cc180');
    GNSS(:,end) = GNSS(:,end) + 18 - 0.320;
end

