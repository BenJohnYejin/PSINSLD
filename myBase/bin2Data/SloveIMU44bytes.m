%解析44字节协议IMU
% fid 文件句柄
% Data 数据
% [Gyrx;Gyry;Gyrz;Accx;Accy;Accz;tmpt;od;Week;Second]s
function [ imuData ] = SloveIMU44bytes( fileName)

    fid=fopen(fileName,'rb');%打开文件
    for j=1:10000
        head = fread(fid,1,'uint8'); 
        if (170 == head)
            break;
        end
    end
%     %
%     fseek(fid,j+0,-1);WeekA = dec2hex(fread(fid,[1,inf],'uint8',43));
%     WeekA = str2num(WeekA(:,2));
    %
%     fseek(fid,j+1,-1);WeekB = fread(fid,[1,inf],'uint8',43);
%     Week = WeekA'*256+WeekB;
    fseek(fid,j+2,-1);Second = fread(fid,[1,inf],'float64',36);
    fseek(fid,j+10,-1);Gyrx = fread(fid,[1,inf],'float32',40);
    fseek(fid,j+14,-1);Gyry = fread(fid,[1,inf],'float32',40);
    fseek(fid,j+18,-1);Gyrz = fread(fid,[1,inf],'float32',40);
    
    fseek(fid,j+22,-1);Accx = fread(fid,[1,inf],'float32',40);
    fseek(fid,j+26,-1);Accy = fread(fid,[1,inf],'float32',40);
    fseek(fid,j+30,-1);Accz = fread(fid,[1,inf],'float32',40);
    
    fseek(fid,j+34,-1);tmpt = fread(fid,[1,inf],'int16',42);
    fseek(fid,j+36,-1);od = fread(fid,[1,inf],'int16',42);
    
    fseek(fid,j+42,-1);endline = fread(fid,[1,inf],'uint8',43);
    Length = length(endline);
    Gyrx = Gyrx(1:Length);Gyry = Gyry(1:Length);Gyrz = Gyrz(1:Length);
    Accx = Accx(1:Length);Accy = Accy(1:Length);Accz = Accz(1:Length);
    tmpt = tmpt(1:Length);od = od(1:Length);Week = Gyrz(1:Length);
    Second = Second(1:Length);
    
    glvs;
    Gyr = [Gyrx;Gyry;Gyrz]*glv.deg;
%     Gyr = [Gyrx;Gyry;Gyrz]/125;
    Acc = [Accx;Accy;Accz];
    imuData = [Gyr;Acc;tmpt;od;Second]';
    fclose(fid);
    
    
end

