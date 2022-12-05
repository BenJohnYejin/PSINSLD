function [myWord,myDoc] = myWordInit(title) 
%%
try     % 如果Word服务器已打开，则返回句柄
    myWord = actxGetRunningServer('Word.Application');
catch   % 否则创建Word服务器，并返回句柄
    myWord = actxserver('Word.Application'); 
end
set(myWord,'Visible',1);      % 设置Word服务器可见
myDoc = myWord.Document.Add;  % 新建空白文档
%% 写入标题
% Content接口操作
myContent = myDoc.Content;    % 返回文档的Content接口的句柄
myContent.Start = 0;          % 设置文档Content的起始位置
myContent.text = title;       % 写入文档的内容
myContent.Font.Size = 20;     % 设置字号
myContent.ParagraphFormat.Alignment = 'wdAlignParagraphCenter'; % 居中对齐
