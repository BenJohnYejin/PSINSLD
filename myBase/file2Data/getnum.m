function s1 = getnum(s)%s��һ���ַ������飬�൱��һ��һά�����顣
  len = size(s);
  for i = 1:len(2)
      ch1 = s(i:i);
      asc1 = abs(ch1);%fgets֮�����еĶ���������ַ��ˣ������ٽ��ַ�ת����ASCII��
      if(asc1<45)
          asc1 = 32;
      end
      if(asc1==47)
          asc1 = 32;
      end
      if(asc1>57)%����ĸ���������ֱ�ɿո�
          asc1 =32;
      end

      ch1 = char(asc1);
      s1(i:i)=ch1;
  end
end

