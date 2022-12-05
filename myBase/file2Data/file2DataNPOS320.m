%
function [ LAT,Std ] = file2DataNPOS320(fileName)
gps=fopen(fileName,'r');
%%
s10='#INSPVAXA';
%%
avpValid = 0;
k=0;
LAT=zeros(500,11);
Std=zeros(500,11);
avpt = zeros(1,11);
stdt = zeros(1,11);
%%
while ~feof(gps)
    charLine = fgets(gps);
    %avp std
    if (~isempty(strfind(charLine,s10)))
        cellLine=strsplit(charLine,',');
        if length(cellLine) < 30
           continue; 
        end
        Week = str2num(cellLine{6});
        Second = str2num(cellLine{7});
        
        Lon = str2num(cellLine{12});
        Lat = str2num(cellLine{13});
        Height = str2num(cellLine{14})+ str2num(cellLine{15});
        
        Vn = str2num(cellLine{16});
        Ve = str2num(cellLine{17});
        Vu = str2num(cellLine{18});
        
        Roll = str2num(cellLine{19});
        Pitch = str2num(cellLine{20});
        Yaw = str2num(cellLine{21});
        
        avpt = [Roll,Pitch,Yaw,Ve,Vn,Vu,Lon,Lat,Height,Week,Second];
        avpValid = 1;
        
        stdLon = str2num(cellLine{22});
        stdLat = str2num(cellLine{23});
        stdHeight = str2num(cellLine{24});
        
        stdVn = str2num(cellLine{25});
        stdVe = str2num(cellLine{26});
        stdVu = str2num(cellLine{27});
          
        stdRoll = str2num(cellLine{28});
        stdPitch = str2num(cellLine{29});
        stdYaw = str2num(cellLine{30});
        stdt = [stdRoll,stdPitch,stdYaw,stdVe,stdVn,stdVu,stdLon,stdLat,stdHeight,Week,Second];
    end 
    
    if ( avpValid == 1 )
        k=k+1;
        LAT(k,:) = avpt;
        Std(k,:) = stdt;
        avpValid = 0;
    end
       
end  %while½áÊø
glvs;
LAT(:,[1:3,7:8]) = LAT(:,[1:3,7:8])*glv.deg;
LAT(:,3) = yawcvt(LAT(:,3),'c360cc180');
Std(:,1:3) = Std(:,1:3)*glv.deg;
fclose(gps);