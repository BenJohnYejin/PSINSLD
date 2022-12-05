%失锁时间段误差统计
%
%
function [ errSummary,str ,str1 ] = errShowUnlock(err,flagGNSS,flagShow )

glvs;
    if (nargin<3) flagShow=1;end
    time = flagGNSS(:,2);
    indexLostB = find(diff(flagGNSS(:,1)) == -1);
    indexLostE = find(diff(flagGNSS(:,1)) == 1);
    if(length(indexLostB)<1)  errSummary =[];str ='';str1 = '';return; end;
    Length = min(length(indexLostB),length(indexLostE));
    Ts = flagGNSS(2,2) - flagGNSS(1,2);
    errSummary(1:Length,:) = struct('err',[]);
    str = '*********失锁统计***********\n';
    str1 = ' ';
    indexLostE=[1;indexLostE];
    
    timeLost = 0;
    index = 1;
   
%     timeLast = 0;
    for j=1:Length
        %失锁时间
        timeLengthj = (indexLostE(j+1)-indexLostB(j))*Ts;
        timeLengthk = time(indexLostB(j))-time(indexLostE(j));
        
        if (timeLengthk < 1)
            timeLost = timeLost + timeLengthj;
            continue;
        end
        
        if (timeLengthj+timeLost < 1)
            continue;
        end
        
        if (timeLengthj+timeLost > 10)
            if (flagShow)
                disp( sprintf('未失锁时间为%.3f s：%.3f s , 未失锁时长为 %0.3f s. \n',  time(indexLostE(index)),time(indexLostB(j))-timeLost,timeLengthk+timeLost));
                disp( sprintf('  失锁时间为%.3f s：%.3f s ,   失锁时长 %.3f s \n', time(indexLostB(j)),time(indexLostE(j+1)),timeLengthj));
            end
            str = [str,sprintf('未失锁时间为%.3f s：%.3f s , 未失锁时长为 %0.3f s. \n',  time(indexLostE(index)),time(indexLostB(j))-timeLost,timeLengthk+timeLost)];
            str = [str,sprintf('  失锁时间为%.3f s：%.3f s ,   失锁时长为 %0.3f s. \n',  time(indexLostB(j))-timeLost,time(indexLostE(j+1)),timeLost+timeLengthj)];           

%             str1 = [str1,sprintf(' %.3f %.3f %.3f \n',  time(indexLostB(j))-timeLost,time(indexLostE(j+1)),timeLost+timeLengthj)];
            
            [errSummary(j).err,str0,strtmp]=errShow(err,[indexLostB(j):indexLostE(j+1)],flagShow);
            errSummary(j).timeLength=timeLengthj;
            errSummary(j).timeStart=time(indexLostB(j));
            errSummary(j).timeEnd=time(indexLostE(j+1));
            
            str = [str,str0];           
            str1 = [str1,'\n',strtmp];
            
            timeLost = 0;
            index = j+1;
        end
    end
    str1 = [str1,'\n'];
    
end
