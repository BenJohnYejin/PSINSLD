%Îó²î·ÖÎö
%err  att,vn,pos,t
%err0         rms  std  max  mean  
%     pos
%     vn
%     att
function [ err0,str,str1 ] = errShow(err,time,flagShow)
glvs;
err0 = zeros(3,12);
str = '';
    if (nargin < 3) flagShow = 1; end
    if (isempty(time) || time(1)>length(err) ) return; end 
    if (time(end) > length(err)) 
        time= time(1):length(err);
    end
    err = err(time,:);
    err(:,7:8)=err(:,7:8)*glv.Re;
    err(:,1:3)=err(:,1:3)/glv.deg;
    
    err = [err(:,1:9),(err(:,7).^2 + err(:,8).^2).^0.5,(err(:,4).^2 + err(:,5).^2).^0.5,err(:,end)];
    %pos
    err0(1,1:12) = [rms(err(:,7:9)),std(err(:,7:9)),max(abs(err(:,7:9))),mean(err(:,7:9))];
%     err0(1,13:16) = [rms(err(:,10)),std(err(:,10)),max(abs(err(:,10))),mean(err(:,10))];
    %vn
    err0(2,1:12) = [rms(err(:,4:6)),std(err(:,4:6)), max(abs(err(:,4:6))),mean(err(:,4:6))];
%     err0(2,13:16) = [rms(err(:,11)),std(err(:,11)),max(abs(err(:,11))),mean(err(:,11))];
    %att
    err0(3,1:12) = [rms(err(:,1:3)),std(err(:,1:3)), max(abs(err(:,1:3))),mean(err(:,1:3))];
%     err0(3,13:16) = [rms(err(:,11)),std(err(:,11)),max(abs(err(:,11))),mean(err(:,11))];
    
    if (flagShow)  
        disp( sprintf('POS N E H rms = %.3f %.3f %.3f, std = %.3f %.3f %.3f, max = %.3f %.3f %.3f, mean = %.3f %.3f %.3f',...
        err0(1,:) ));
        disp( sprintf('VEL N E H rms = %.3f %.3f %.3f, std = %.3f %.3f %.3f, max = %.3f %.3f %.3f, mean = %.3f %.3f %.3f',...
        err0(2,:) ));    
        disp( sprintf('ATT P R Y rms = %.3f %.3f %.3f, std = %.3f %.3f %.3f, max = %.3f %.3f %.3f, mean = %.3f %.3f %.3f',...
        err0(3,:) ));
    end
    
    str = sprintf('POS N E H rms = %.3f %.3f %.3f, std = %.3f %.3f %.3f, max = %.3f %.3f %.3f, mean = %.3f %.3f %.3f \n',err0(1,:) );
    str = [str,sprintf('VEL N E H rms = %.3f %.3f %.3f, std = %.3f %.3f %.3f, max = %.3f %.3f %.3f, mean = %.3f %.3f %.3f \n',err0(2,:) )];
    str = [str,sprintf('ATT P R Y rms = %.3f %.3f %.3f, std = %.3f %.3f %.3f, max = %.3f %.3f %.3f, mean = %.3f %.3f %.3f \n',err0(3,:) )];
    
    str1 = sprintf(' %.3f,%.3f,%.3f,%.3f,\n %.3f,%.3f,%.3f,%.3f,%.3f,%.3f,\n %.3f,%.3f,%.3f,%.3f,%.3f,%.3f \n',[err0(3,[6,4,5,12]),err0(2,[1:3,7:9]),err0(1,[1:3,7:9])] );

%     str1 = sprintf('%.3f,%.3f,%.3f,%.3f,%.3f,%.3f ,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f \n',err0(1,:) );
%     str1 = [str1,sprintf('%.3f,%.3f,%.3f,%.3f,%.3f,%.3f ,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f \n',err0(2,:) )];
%     str1 = [str1,sprintf('%.3f,%.3f,%.3f,%.3f,%.3f,%.3f ,%.3f,%.3f,%.3f,%.3f,%.3f,%.3f \n',err0(3,:) )];
end