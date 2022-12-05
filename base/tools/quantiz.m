function yi = quantiz(x, q, q2)
% Increment quantization.
%
% Prototype: yi = quantiz(x, q)
% Inputs: x - data source to be quantized
%         q - quantitative equivalent
% Output: yi - quantized data output
%
% See also  imuresample.

% Copyright(c) 2009-2021, by Gongmin Yan, All rights reserved.
% Northwestern Polytechnical University, Xi An, P.R.China
% 07/11/2013, 16/06/2021
    if size(x,2)==7  % imu1 = quantiz(imu, qgyro, qacc);
        if nargin==3, q(2)=q2; end
        yi = x;
        yi(:,1:3) = quantiz(x(:,1:3), q(1));
        yi(:,4:6) = quantiz(x(:,4:6), q(2));
        return;
    end
    x = fix(cumsum(x,1)/q);
    yi = diff([zeros(1,size(x,2)); x])*q;
