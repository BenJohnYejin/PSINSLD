function [] =CreatWordBody1(myWord,myDoc,fileName,j,titleHead)
    mySelection = myWord.Selection;
    myContent = myDoc.Content; 
    mySelection.Start = myContent.end;  % 设置选定区域的起始位置为文档内容的末尾
    mySelection.TypeParagraph;
    % 添加第一段文字
    % 文字的格式设置
    mySelection.Font.Name = '宋体';     % 设置字体
    mySelection.Font.Size = 12;         % 设置字号
    mySelection.Font.Bold = 1;          % 字体加粗
    mySelection.paragraphformat.Alignment = 'wdAlignParagraphLeft'; 
                                              % 居左对齐
    mySelection.paragraphformat.LineSpacingRule = 'wdLineSpace1pt'; 
                                              % 行距为1.5倍行距
    mySelection.paragraphs.OutlinePromote();
%     mySelection.paragraphformat.FirstLineIndent = 25;  % 首行缩进磅数
    % 添加段落内容
%     myStr1 = [num2str(j),'.A35混合导航效果']; 
    myStr1 = [num2str(j),titleHead]; 
                                             % 第1自然段的内容
    mySelection.Text = myStr1;          % 在选定区域输入文字内容
    mySelection.Start = mySelection.end;
    mySelection.TypeParagraph;          % 回车，另起一段
    %%
    % 格式
    myContent = myDoc.Content;
    mySelection = myWord.Selection;
    mySelection.Start = myContent.end;  % 设置选定区域的起始位置为文档内容的末尾
    mySelection.paragraphformat.Alignment = 'wdAlignParagraphLeft'; 
                                                              % 居中对齐
    mySelection.paragraphformat.FirstLineIndent = 0; % 首行缩进磅数
    % 数据
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
    
    % 精度统计
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
    mySelection.Start = mySelection.end;
    mySelection.Font.Bold = 0;          % 字体不加粗
    mySelection.Text = str;          % 在选定区域输入文字内容
    mySelection.Start = mySelection.end;
    mySelection.TypeParagraph;          % 回车，另起一段
    
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