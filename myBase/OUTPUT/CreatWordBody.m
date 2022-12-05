
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
    data = binfile(fileName,26);
    data(:,end) = data(:,end) - data(1,end);
    %
    sub3(data,myDoc,mySelection);
    % 参数对比
%     sub1(dd,myDoc,mySelection);
    % 精度对比
%     sub2(dd,myDoc,mySelection,j);
    % flag绘制
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
    % 精度统计
    time = find(err(:,end)>(err(1,end)+260) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
%     fileNameXls='A35仿真批处理.xlsx';
%     head0 = {'rms','rms','rms','std','std','std','max','max','max','mean','mean','mean'};
%     head1 = {'pos';'vn';'att'};
%     xlswrite(fileNameXls,head0,'统计表-全程',strcat('B',num2str(4*j+2)));
%     xlswrite(fileNameXls,head1,'统计表-全程',strcat('A',num2str(4*j+3)));
%     xlswrite(fileNameXls,errMatrix,'统计表-全程',strcat('B',num2str(4*j+3)));
    
    mySelection.Start = mySelection.end;
    mySelection.Text = str;          % 在选定区域输入文字内容
    mySelection.Font.Bold = 0;          % 字体不加粗
    mySelection.Font.Size = 10;         % 设置字号
    mySelection.Font.Name = 'Times New Roman';     % 设置字体
    
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
    % 精度统计
    time = find(err(:,end)>(err(1,end)+100) & err(:,end)<(err(1,end)+8000));
    [~,str]=errShow(err,time,0);
    
    mySelection.Start = mySelection.end;
    mySelection.Font.Bold = 1;          % 字体不加粗
    mySelection.Font.Size = 10;         % 设置字号
    mySelection.Font.Name = 'Times New Roman';     % 设置字体
    mySelection.Text = str;          % 在选定区域输入文字内容   
end

