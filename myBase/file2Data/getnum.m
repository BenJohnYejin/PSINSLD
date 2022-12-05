function s1 = getnum(s)%s是一个字符串数组，相当于一个一维的数组。
  len = size(s);
  for i = 1:len(2)
      ch1 = s(i:i);
      asc1 = abs(ch1);%fgets之后所有的东西都变成字符了，所以再讲字符转换成ASCII码
      if(asc1<45)
          asc1 = 32;
      end
      if(asc1==47)
          asc1 = 32;
      end
      if(asc1>57)%将字母等其他数字变成空格
          asc1 =32;
      end

      ch1 = char(asc1);
      s1(i:i)=ch1;
  end
end

