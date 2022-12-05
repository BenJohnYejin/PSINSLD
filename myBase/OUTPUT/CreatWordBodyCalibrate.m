
function [] =CreatWordBody(myWord,myDoc,fileName,j,titleHead)
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
    
    % ����ͳ��
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
    mySelection.Text = str;          % ��ѡ������������������
    mySelection.Font.Bold = 0;          % ���岻�Ӵ�
    mySelection.Font.Size = 10;         % �����ֺ�
    mySelection.Font.Name = 'Times New Roman';     % ��������
    mySelection.Start = mySelection.end;
    mySelection.TypeParagraph;          % �س�������һ��
end

