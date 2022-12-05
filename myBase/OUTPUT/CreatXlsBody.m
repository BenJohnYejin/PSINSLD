function []=CreatXlsBody(fileName,j,fileNameXls,sheetName)
    % Êı¾İ
%     dd = binfile(fileName, 38);
%     dd(:,32)=dd(:,32)-dd(1,32);
%     dd(1:100,:)=[];
%     base=dd(:,[2,1,3:9,32]);
%     err=avpcmp(base(base(:,7)>0,:), dd(:,[17,18,19:25,32]), 'mu');

    data = binfile(fileName,26);
    data(:,end) = data(:,end) - data(1,end);
    ins = data(:,[1,2,3:9,26]);
    base = data(data(:,22)>0,[16,17,18:24,26]);
    err = ODavpcmp(base,ins(:,[1:9,end]),data(:,25),0);
    
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [errMatrix]=errShow(err,time,0);

    head0 = {'rms','rms','rms','std','std','std','max','max','max','mean','mean','mean'};
    head1 = {'pos';'vn';'att'};
    xlswrite(fileNameXls,head0,sheetName,strcat('B',num2str(4*j+2)));
    xlswrite(fileNameXls,head1,sheetName,strcat('A',num2str(4*j+3)));
    xlswrite(fileNameXls,errMatrix,sheetName,strcat('B',num2str(4*j+3)));
end