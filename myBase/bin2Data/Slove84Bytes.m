
%A35a 84字节解析
function [ nav] = Slove84Bytes( fileName ,Count)
glvs;ts = 0.008;
    fid=fopen([fileName],'rb');%打开文件
    nav =[];
    if(fid == -1) 
        nav=0;
        return;
    end
    
    for j=1:1000
        head = fread(fid,1,'uint8'); 
        if (170 == head)
            break;
        end
    end
    j=j+3;
    %flag
    fseek(fid,j+4,-1);Statue = fread(fid,[1,inf],'uint8',83);
    %Time
    fseek(fid,j+14,-1);Month = fread(fid,[1,inf],'uint8',83);
    fseek(fid,j+15,-1);Day = fread(fid,[1,inf],'uint8',83);
    fseek(fid,j+16,-1);Hour = fread(fid,[1,inf],'uint32',80);
    %Pos
    fseek(fid,j+20,-1);Lon = fread(fid,[1,inf],'int32',80);
    fseek(fid,j+24,-1);Lat = fread(fid,[1,inf],'int32',80);
    fseek(fid,j+28,-1);Hgt = fread(fid,[1,inf],'int32',80);
    %Vel
    fseek(fid,j+32,-1);VnE = fread(fid,[1,inf],'int32',80);
    fseek(fid,j+34,-1);VnN = fread(fid,[1,inf],'int32',80);
    fseek(fid,j+36,-1);VnU = fread(fid,[1,inf],'int32',80);
    
    %Att
    fseek(fid,j+60,-1);Yaw = fread(fid,[1,inf],'uint16',82);   
    fseek(fid,j+62,-1);Roll = fread(fid,[1,inf],'int16',82);
    fseek(fid,j+64,-1);Pitch = fread(fid,[1,inf],'int16',82);

    %back
    fseek(fid,j+76,-1);back = fread(fid,[1,inf],'uint32',80);    
    Length = length(back); 
    %舍去不完整的数据，最多一行
    Roll = Roll(1:Length);Pitch = Pitch(1:Length);Yaw = Yaw(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Statue = Statue(1:Length)';

    Pos = [Lat;Lon;Hgt]';
    Vn = [VnN;VnE;VnU]';
    Att = [Roll;Pitch;Yaw]';
    
    Second = Count*86400  + Hour - 8*3600;

    
    nav = [Att,Vn,Pos,Statue,Second];
    nav(:,[1:3,7,8]) = nav(:,[1:3,7,8])*glv.deg;
    
    fclose(fid);
end

