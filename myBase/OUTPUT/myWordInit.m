function [myWord,myDoc] = myWordInit(title) 
%%
try     % ���Word�������Ѵ򿪣��򷵻ؾ��
    myWord = actxGetRunningServer('Word.Application');
catch   % ���򴴽�Word�������������ؾ��
    myWord = actxserver('Word.Application'); 
end
set(myWord,'Visible',1);      % ����Word�������ɼ�
myDoc = myWord.Document.Add;  % �½��հ��ĵ�
%% д�����
% Content�ӿڲ���
myContent = myDoc.Content;    % �����ĵ���Content�ӿڵľ��
myContent.Start = 0;          % �����ĵ�Content����ʼλ��
myContent.text = title;       % д���ĵ�������
myContent.Font.Size = 20;     % �����ֺ�
myContent.ParagraphFormat.Alignment = 'wdAlignParagraphCenter'; % ���ж���
