function [ err,Person ,str] = imucmp( imu1, imu0 )
glvs;
    ts = 0.01;dps = glv.dps;g0 = glv.g0;
    [m,n] = size(imu0);
    if m==1 || n==1
        imu0 = imu0(:)';  % convert to row vector
        imu0 = [repmat(imu0,length(imu1),1), imu1(:,end)];
    end
%     [t, i1, i0] = intersect(round(avp1(:,end)*1e4), round(avp0(:,end)*1e4)); t = t/1e4;
%     if length(t)<1
        imu1 = avpinterp1(imu1, imu0(:,end), 'linear');
        [t, i1, i0] = intersect(imu1(:,end), imu0(:,end));
%     end
    imu1 = imu1(i1,1:end-1); imu0 = imu0(i0,1:end-1);
    clm=min(size(imu1,2),size(imu0,2));
    err = [imu1(:,1:clm)-imu0(:,1:clm),t];
    Person = corrcoef(imu1(:,3),imu0(:,3));    
    err(:,1:3) = err(:,1:3)/ts/dps;
    err(:,4:6) = err(:,4:6)/ts/g0;
%     err0(1,1:12) = [rms(err(:,4:6)),std(err(:,4:6)), max(abs(err(:,4:6))),mean(err(:,4:6))];
%     err0(2,1:12) = [rms(err(:,1:3)),std(err(:,1:3)), max(abs(err(:,1:3))),mean(err(:,1:3))];
%     str = sprintf(' %.3f , %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f \n',err0(1,:) );
%     str = [str,sprintf(' %.3f , %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f \n',err0(2,:) )];
    
    err0(1,1:9) = [std(err(:,4:6)), max(abs(err(:,4:6))),mean(err(:,4:6))];
    err0(2,1:9) = [std(err(:,1:3)), max(abs(err(:,1:3))),mean(err(:,1:3))];
    str = sprintf(' %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f \n',err0(1,:) );
    str = [str,sprintf(' %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f \n',err0(2,:) )];
end

