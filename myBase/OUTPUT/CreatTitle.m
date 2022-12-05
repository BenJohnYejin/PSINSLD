function [  ] = CreatTitle( myWord,myDoc,titleHead )
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
    myStr1 = [titleHead]; 
                                             % 第1自然段的内容
    mySelection.Text = myStr1;          % 在选定区域输入文字内容
    mySelection.Start = mySelection.end;
end

