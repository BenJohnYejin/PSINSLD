
function [] =CreatWordBody(myWord,myDoc,fileName,j,titleHead)
    mySelection = myWord.Selection;
    myContent = myDoc.Content; 
    mySelection.Start = myContent.end;  % ����ѡ���������ʼλ��Ϊ�ĵ����ݵ�ĩβ
    mySelection.TypeParagraph;
    % ��ӵ�һ������
    % ���ֵĸ�ʽ����
    mySelection.Font.Name = '����';     % ��������
    mySelection.Font.Size = 12;         % �����ֺ�
    mySelection.Font.Bold = 1;          % ����Ӵ�
    mySelection.paragraphformat.Alignment = 'wdAlignParagraphLeft'; 
                                              % �������
    mySelection.paragraphformat.LineSpacingRule = 'wdLineSpace1pt'; 
                                              % �о�Ϊ1.5���о�
    mySelection.paragraphs.OutlinePromote();
%     mySelection.paragraphformat.FirstLineIndent = 25;  % ������������
    % ��Ӷ�������
%     myStr1 = [num2str(j),'.A35��ϵ���Ч��']; 
    myStr1 = [num2str(j),titleHead]; 
                                             % ��1��Ȼ�ε�����
    mySelection.Text = myStr1;          % ��ѡ������������������
    mySelection.Start = mySelection.end;
    mySelection.TypeParagraph;          % �س�������һ��
    %%
    % ��ʽ
    myContent = myDoc.Content;
    mySelection = myWord.Selection;
    mySelection.Start = myContent.end;  % ����ѡ���������ʼλ��Ϊ�ĵ����ݵ�ĩβ
    mySelection.paragraphformat.Alignment = 'wdAlignParagraphLeft'; 
                                                              % ���ж���
    mySelection.paragraphformat.FirstLineIndent = 0; % ������������
    % ����
%     dd = binfile(fileName, 38);
%     dd(:,32)=dd(:,32)-dd(1,32);
%     dd(1:100,:)=[];
    data = binfile(fileName,26);
    data(:,end) = data(:,end) - data(1,end);
    %
    sub3(data,myDoc,mySelection);
    % �����Ա�
%     sub1(dd,myDoc,mySelection);
    % ���ȶԱ�
%     sub2(dd,myDoc,mySelection,j);
    % flag����
%     sub0(dd,myDoc,mySelection);
end

function []=sub0(dd,myDoc,mySelection)   
    flagTest =  dd(:,[37:38,32]);
    figure;
    subplot(2,1,1);plot(flagTest(:,end),flagTest(:,1),'rx');grid on;
    xlabel('time/s'),ylabel('Calibrate_{flag}'),legend('Calibrate ');
    subplot(2,1,2);plot(flagTest(:,end),flagTest(:,2),'rx');grid on;
    xlabel('time/s'),ylabel('flagMeas_{flag}'),legend('Meas ');
    
    hgexport(gcf,'-clipboard');
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type = 7;
end

%%
function []=sub1(dd,myDoc,mySelection)        
    insplot(dd(:,17:32));
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
    
    flagTest =  dd(:,[37:38,32]);
    flagShow(flagTest);    
    print(gcf, '-dmeta')
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type = 7;
    close;
end
%%
function []=sub2(dd,myDoc,mySelection,j)
    base=dd(:,[2,1,3:9,32]);
    err=avpcmpplot(base(base(:,7)>0,:), dd(:,[17,18,19:25,32]), 'mu');
    print(gcf, '-dmeta')
    close;
    % ����ͳ��
    time = find(err(:,end)>(err(1,end)+260) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
%     fileNameXls='A35����������.xlsx';
%     head0 = {'rms','rms','rms','std','std','std','max','max','max','mean','mean','mean'};
%     head1 = {'pos';'vn';'att'};
%     xlswrite(fileNameXls,head0,'ͳ�Ʊ�-ȫ��',strcat('B',num2str(4*j+2)));
%     xlswrite(fileNameXls,head1,'ͳ�Ʊ�-ȫ��',strcat('A',num2str(4*j+3)));
%     xlswrite(fileNameXls,errMatrix,'ͳ�Ʊ�-ȫ��',strcat('B',num2str(4*j+3)));
    
    mySelection.Start = mySelection.end;
    mySelection.Text = str;          % ��ѡ������������������
    mySelection.Font.Bold = 0;          % ���岻�Ӵ�
    mySelection.Font.Size = 10;         % �����ֺ�
    mySelection.Font.Name = 'Times New Roman';     % ��������
    
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
end

%%
function []=sub3(dd,myDoc,mySelection)
    insdata = dd(:,[1,2,3:15,26]);
    base = dd(:,[16,17,18:24,26]);
    err = ODavpcmp(base(base(:,7)>0.1,:),insdata(:,[1:9,end]),dd(:,25),1);
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
    % ����ͳ��
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
    mySelection.Start = mySelection.end;
    mySelection.Font.Bold = 1;          % ���岻�Ӵ�
    mySelection.Font.Size = 10;         % �����ֺ�
    mySelection.Font.Name = 'Times New Roman';     % ��������
    mySelection.Text = str;          % ��ѡ������������������   
end

