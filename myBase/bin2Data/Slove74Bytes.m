function [ navA28 ] = Slover74Bytes( fileName )
    glvs;
    fid=fopen([fileName],'rb');%打开文件
    for j=1:1000
        head = fread(fid,1,'uint8'); 
        if (172 == head)
            break;
        end
    end
    %Pos
    fseek(fid,j+0,-1);Lat = fread(fid,[1,inf],'double',66);
    fseek(fid,j+8,-1);Lon = fread(fid,[1,inf],'double',66);
    %Att
    fseek(fid,j+16,-1);Yaw = fread(fid,[1,inf],'double',66);  
    fseek(fid,j+24,-1);Roll = fread(fid,[1,inf],'double',66);
    fseek(fid,j+32,-1);Pitch = fread(fid,[1,inf],'double',66);
    %Second
    fseek(fid,j+40,-1);Second = fread(fid,[1,inf],'double',66);
    %height
    fseek(fid,j+48,-1);Hgt = fread(fid,[1,inf],'float',70);
    %Vel
    fseek(fid,j+52,-1);VnN = fread(fid,[1,inf],'float',70);
    fseek(fid,j+56,-1);VnE = fread(fid,[1,inf],'float',70);
    fseek(fid,j+60,-1);VnU = fread(fid,[1,inf],'float',70);
    %stdYaw
    fseek(fid,j+64,-1);stdYaw = fread(fid,[1,inf],'float',70);
    
    %flag
    fseek(fid,j+68,-1);flag0 = fread(fid,[1,inf],'uint8',73);
    %Statue
    fseek(fid,j+69,-1);flag1 = fread(fid,[1,inf],'uint8',73);
    %OD
    fseek(fid,j+70,-1);flag2 = fread(fid,[1,inf],'uint8',73);
    %
    fseek(fid,j+71,-1);back = fread(fid,[1,inf],'uint8',73);    
    Length = length(back); 
    %舍去不完整的数据，最多一行
    Roll = Roll(1:Length);Pitch = Pitch(1:Length);Yaw = Yaw(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Second = Second(1:Length)';stdYaw = stdYaw(1:Length)';
    flag0 = flag0(1:Length)';flag1 = flag1(1:Length)';
    flag2 = flag2(1:Length)';
    
    %协议转换
    Att = [Roll;Pitch;Yaw]';
    Pos = [Lat;Lon;Hgt]';
    Vn = [VnN;VnE;VnU]'; 
    
    navA28 = [Att,Vn,Pos,stdYaw,flag0,flag1,flag2,Second];
%     navA28(:,[1:2,7,8]) = navA28(:,[1:2,7,8])*glv.deg;
    
    fclose(fid);
end

