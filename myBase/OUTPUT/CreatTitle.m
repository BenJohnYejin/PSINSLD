function [  ] = CreatTitle( myWord,myDoc,titleHead )
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
    myStr1 = [titleHead]; 
                                             % ��1��Ȼ�ε�����
    mySelection.Text = myStr1;          % ��ѡ������������������
    mySelection.Start = mySelection.end;
end

