function [] =CreatWordBody1(myWord,myDoc,fileName,j,titleHead)
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
    data = binfile(fileName,28);
    data(:,end) = data(:,end) - data(1,end);
    
    sub0(myDoc,mySelection,data);
    
    sub1(myDoc,mySelection,data);
    
    sub2(myDoc,mySelection,data);
    
%     sub3(myDoc,mySelection,data);
end
%%
function [] =sub0(myDoc,mySelection,data)
glvs;
    vpGNSS0 = data(:,[13:15,9:11,1]);
    base0 = data(:,[23:25,26:28,20:22,1]);
    err=avpcmpplot(vpGNSS0(vpGNSS0(:,4)>0.001,:),base0(base0(:,7)>0.001,:), 'vp');
    
    print(gcf, '-dmeta')
    close;
    
    % ����ͳ��
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
    mySelection.Start = mySelection.end;
    mySelection.Font.Bold = 0;          % ���岻�Ӵ�
    mySelection.Text = str;          % ��ѡ������������������
    mySelection.Start = mySelection.end;
    mySelection.TypeParagraph;          % �س�������һ��
    
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
end
%%
function [] =sub1(myDoc,mySelection,data)
glvs;
    IMU = data(:,[2:7,1]);
    imuplot(IMU);
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
end

%%
function [] =sub2(myDoc,mySelection,data)
glvs;
    V = data(:,[13:15,12,9:11,1]);
    OD = data(:,[8,1]);
    V(V(:,5)<0.01,:)=[];
    [~,indexOD,indexV]=intersect(OD(:,end)+18,V(:,end));
    gpsV(:,1)=sqrt(V(:,1).*V(:,1)+V(:,2).*V(:,2)+V(:,3).*V(:,3));

    figure;plot(OD(indexOD,end),OD(indexOD,1),'r.-');
    hold on;plot(V(indexV,end),gpsV(indexV,1),'b.-');
    hold on;plot(V(indexV,end),V(indexV,4),'k.-');
    grid on;legend('od','gnssvel','flag');
    
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
end
%%
function [] =sub3(myDoc,mySelection,data)
glvs;
    V = data(:,[13:15,1]);
    OD = data(:,[8,1]);
    [~,indexOD,indexV]=intersect(OD(:,end)+18,V(:,end));
    gpsV(:,1)=sqrt(V(:,1).*V(:,1)+V(:,2).*V(:,2)+V(:,3).*V(:,3));
    
    figure;plot(OD(indexOD,end),OD(indexOD,7),'r.-');
    hold on;plot(V(indexV,end),gpsV(indexV,1),'b.-');
    hold on;plot(V(indexV,end),gps(indexV,7),'k.-');
    grid on;legend('odsmo','gpsvel','flag');
    
    print(gcf, '-dmeta')
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
end