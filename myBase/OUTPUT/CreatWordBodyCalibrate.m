
function [] =CreatWordBody(myWord,myDoc,fileName,j,titleHead)
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
    data = binfile(fileName,49);
    data(:,end) = data(:,end) - data(1,end);

    sub2(data,myDoc,mySelection);
    sub1(data,myDoc,mySelection);
    sub0(data,myDoc,mySelection);
end

function []=sub0(dd,myDoc,mySelection)   
    leverPlot(dd(:,[22:24,31:33,39]));
    hgexport(gcf,'-clipboard');
    close;
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type = 7;
end

%%
function []=sub1(dd,myDoc,mySelection)        
    ODKappaPlot(dd(:,[34:36,39]));
    print(gcf, '-dmeta');
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type = 7;
    close;
end
%%
function []=sub2(dd,myDoc,mySelection)
    figure;
    glvs;
    subplot(2,1,1);plot(dd(:,39),dd(:,38)/glv.deg);grid on;xlabel('time/s');ylabel('dyawGNSS/deg');
    subplot(2,1,2);plot(dd(:,39),dd(:,49));grid on;xlabel('time/s');ylabel('delayt/s');
    print(gcf, '-dmeta');
    mySelection.Range.PasteSpecial;
    myDoc.Shapes.Item(1).WrapFormat.Type=7;
    close;
    
    % 精度统计
    str = '';
    str = strcat(str,sprintf('IMU->GNSS:%.3f m, %.3f m, %.3f m \n',dd(end,[22:24])));
    str = strcat(str,'\n');
    str = strcat(str,sprintf('IMU->OD:%.3f m, %.3f m, %.3f m \n',dd(end,[31:33])));
    str = strcat(str,'\n');
    str = strcat(str,sprintf('ODKappa:%.3f deg,%.5f ,%.3f deg\n',dd(end,34)/glv.deg,dd(end,35),dd(end,36)/glv.deg));
    str = strcat(str,'\n');
    str = strcat(str,sprintf('Yaw:%.3f deg\n',dd(end,38)/glv.deg));
    str = strcat(str,'\n');
    
    mySelection.Start = mySelection.end;
    mySelection.Text = str;          % 在选定区域输入文字内容
    mySelection.Font.Bold = 0;          % 字体不加粗
    mySelection.Font.Size = 10;         % 设置字号
    mySelection.Font.Name = 'Times New Roman';     % 设置字体
    mySelection.Start = mySelection.end;
    mySelection.TypeParagraph;          % 回车，另起一段
end

