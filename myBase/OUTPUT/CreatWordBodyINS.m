%
%
function [] =CreatWordBodyINS(myWord,myDoc,fileNameBase,fileNameINS,j,titleHead)
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
    myStr1 = [num2str(j),titleHead]; 
                                             % ��1��Ȼ�ε�����
    mySelection.paragraphs.OutlinePromote();
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
%     dd = binfile(fileNameBase, 38);
%     dd(:,32)=dd(:,32)-dd(1,32);
%     dd(1:100,:)=[];
    dataBase = binfile(fileNameBase,28);
    base = dataBase(:,[23:25,26:28,20:22,1]);
    
    [INS,~] = Slove58Bytes(fileNameINS);
%     [INS,~] = Slove63BytesDY(fileNameINS);
    if (INS == 0) return;end 
    myfigure;err=avpcmpplot(INS(INS(:,7)>0.001,:),base(base(:,7)>0.001,:), 'mu');
    % ����ͳ��
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
    mySelection.Start = mySelection.end;
    mySelection.Font.Bold = 0;          % ���岻�Ӵ�
    mySelection.Text = str;          % ��ѡ������������������
    mySelection.Start = mySelection.end;
    
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
       
    
    mySelection.Start = mySelection.end;
    IPOS3plot(INS(INS(:,7)>0.1,[1:9,10:11,end]));
    
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
    
%     mySelection.Start = mySelection.end;
%     figure;plot(INS(:,end),INS(:,end-1));grid on;legend('flag_{IPOS3}');
%     
%     print(gcf, '-dmeta')
%     close;
%     mySelection.Range.PasteSpecial;
%     myDoc.Shapes.Item(1).WrapFormat.Type=7;
end


