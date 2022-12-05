% ������ӿ�
% datapath  �ļ�·��
function [ INS ] = summaryAll( datapath,dex0,flagShow,fileName)
glvs;
    %��ȡ�ļ���׺
    fileDir = dir([datapath,'*.',dex0]);    
    fileOut = fileName;
    Length = length(fileDir);
    INS(1:Length,1) = struct('err',[]);
    %����ı���ԭʼ����
    fid = fopen(fileOut,'w+');
    fprintf(fid,'------������ʼ------\n');
    fclose(fid);
    
    fid = fopen([fileOut,'ins'],'w+');
    fclose(fid);
    
    %������
    for j=1:Length
        str = '';
        %�ļ���
        file0Name = [datapath,fileDir(j).name]; 
        %������
        data = binfile(file0Name,26+3);
        insdata = data(:,[1,2,3:15,end]);
        base = data(data(:,22)>0,[17,16,18:24,end]);
        err = ODavpcmp(base,insdata(:,[1:9,end]),data(:,25),0);
        %�궨
%         data = binfile(file0Name,49);
%         base = data(:,[40,41,42:48,39]);
%         nav = data(:,[1,2,3,16:18,19:21,39]);
%         err = ODavpcmp(base,nav,[],0);
%         err = avpcmp(base,insdata(:,[1:9,end]),'mu');
        %����õ�
        time = find(err(:,end)>err(1,end)+100 &err(:,end)<(err(1,end)+8500));
        [errMatrix,str,str1]=errShow(err,time,flagShow);
%         [errMatrix,str,str1]=errShow(err,time,1);
        %д���ı�
        fid = fopen(fileOut,'a+');
        fprintf(fid,'---------------------');
        fprintf(fid,fileDir(j).name);
        fprintf(fid,' summary---------------\n');
        fprintf(fid,str);
        
        fid0 = fopen([fileOut,'ins'],'a+');
        fprintf(fid0,str1);
        
        INS(j,1).data = data;
        INS(j,1).err = err;
        INS(j,1).errMatrix = errMatrix;
        disp([file0Name,' INS summary done!!!']);
        
        %ʧ�����ͳ��
        %���� 10 s����ʧ��
        [errMatrixSum,str,str1] = errShowUnlock(err,data(:,[25,end]),flagShow);
        INS(j,1).sumGNSSLost = errMatrixSum;
        
        fprintf(fid,str);
        fprintf(fid,'\n');
        fclose(fid);
        
        
        fprintf(fid0,str1);
        fprintf(fid0,'\n');
        fclose(fid0);
        
        disp([file0Name,' UNLOCK summary done!!!']);

        
        %�궨����
%         dd = binfile(file0Name, 49);
% %         time = length(dd)-10:length(dd);
%         time = 300*100:400*100;
%         str = strcat(str,sprintf('%.3f, %.3f, %.3f \n',mean(dd(time,[22:24]))));
%         str = strcat(str,'\n');
%         str = strcat(str,sprintf('%.3f, %.3f, %.3f \n',mean(dd(time,[31:33]))));
%         str = strcat(str,'\n');
%         str = strcat(str,sprintf('%.3f ,%.5f ,%.3f \n',mean([dd(time,34)/glv.deg,dd(time,35),dd(time,36)/glv.deg])));
%         str = strcat(str,'\n');
%         str = strcat(str,sprintf('%.3f \n',mean(dd(time,38)/glv.deg)));
%        
%         fid = fopen(fileOut,'a+');
%         fprintf(fid,'\n');
%         fprintf(fid,str);
%         fclose(fid);
    end

end

