function templot(temp)
% Temperature plot.
%
% Prototype: templot(temp)
% Input: temp - temperature
%
% See also  od, imuplot, gpsplot, magplot.

% Copyright(c) 2009-2021, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 17/06/2021
    myfig;
    plot(temp(:,end), temp(:,1:end-1)); xygo('Temp');
