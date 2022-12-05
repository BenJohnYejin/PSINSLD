%
%
function [] =CreatWordBodyINS(myWord,myDoc,fileNameBase,fileNameINS,j,titleHead)
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
    myStr1 = [num2str(j),titleHead]; 
                                             % 第1自然段的内容
    mySelection.paragraphs.OutlinePromote();
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
%     dd = binfile(fileNameBase, 38);
%     dd(:,32)=dd(:,32)-dd(1,32);
%     dd(1:100,:)=[];
    dataBase = binfile(fileNameBase,28);
    base = dataBase(:,[23:25,26:28,20:22,1]);
    
    [INS,~] = Slove58Bytes(fileNameINS);
%     [INS,~] = Slove63BytesDY(fileNameINS);
    if (INS == 0) return;end 
    myfigure;err=avpcmpplot(INS(INS(:,7)>0.001,:),base(base(:,7)>0.001,:), 'mu');
    % 精度统计
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
    mySelection.Start = mySelection.end;
    mySelection.Font.Bold = 0;          % 字体不加粗
    mySelection.Text = str;          % 在选定区域输入文字内容
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


