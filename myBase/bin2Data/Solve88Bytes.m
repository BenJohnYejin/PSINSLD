%解析88字节协议
% fid 文件句柄
% Data 数据
% [att,vn,pos,statue,second]
function [Data] = Solve88Bytes(fileName)
    fid=fopen(fileName,'rb');%打开文件
    for j=1:1000
        head = fread(fid,1,'uint8'); 
        if (85 == head)
            break;
        end
    end
    %Statue
    fseek(fid,j+0,-1);Statue = fread(fid,[1,inf],'uint8',87);
    
    fseek(fid,j+1,-1);Second = fread(fid,[1,inf],'double',80);
    fseek(fid,j+9,-1);Lat = fread(fid,[1,inf],'double',80);
    fseek(fid,j+17,-1);Lon = fread(fid,[1,inf],'double',80);
    fseek(fid,j+25,-1);Hgt = fread(fid,[1,inf],'float',84);   
    %Att
    fseek(fid,j+41,-1);Roll = fread(fid,[1,inf],'float',84);
    fseek(fid,j+45,-1);Pitch = fread(fid,[1,inf],'float',84);
    fseek(fid,j+49,-1);Yaw = fread(fid,[1,inf],'float',84);  
    %Vn
    fseek(fid,j+73,-1);VnE = fread(fid,[1,inf],'float',84);
    fseek(fid,j+77,-1);VnN = fread(fid,[1,inf],'float',84);
    fseek(fid,j+81,-1);VnU = fread(fid,[1,inf],'float',84);
   
    %back
    fseek(fid,j+86,-1);Back = fread(fid,[1,inf],'uint8',87);
    
    %
    Length = length(Back);
    
    Pitch = Pitch(1:Length);Roll = Roll(1:Length);Yaw = Yaw(1:Length);
    VnE = VnE(1:Length);VnN = VnN(1:Length);VnU = VnU(1:Length);
    Lat = Lat(1:Length);Lon = Lon(1:Length);Hgt = Hgt(1:Length);
    Statue = Statue(1:Length);Second = Second(1:Length);
    
    %Data
    Data=[Roll;Pitch;Yaw;VnE;VnN;VnU;Lon;Lat;Hgt;Statue;Second]';
    glvs;
    Data(:,[1:3,7:8]) = Data(:,[1,3,2,7:8])*glv.deg;
%     Data(4 == Data(:,end-1),:) = [];
%     Data(192 == Data(:,end-1),:) = [];
    
    fclose(fid);
end
