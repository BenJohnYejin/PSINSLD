function [] = MapPlot(pos)
glvs;
    indexlost = find(pos(:,5) == 34 & pos(:,4) == 0);
    indexsigle = find(pos(:,5) == 34 & pos(:,4) == 1);
    
%     wm = webmap('Open Street Map'); 
%     baseLine = geoshape(pos(1:100:end,1)/glv.deg, pos(1:100:end,2)/glv.deg);  
%     wmline(baseLine ,'Color', 'g', 'Width', 3); 
    
%     lostLine = geopoint(pos(indexlost(1:100:end),1)/glv.deg, pos(indexlost(1:100:end),2)/glv.deg);  
%     if(~isempty(lostLine)) 
% %     lostLine.Geometry = 'point';
%     wmmarker(lostLine ,'Color', 'r'); 
%     end
    dxyz1 = pos2dxyz(pos);
    myfigure;plot(0, 0, 'rp');   
    hold on, plot(dxyz1(:,1), dxyz1(:,2),'g.-'); xygo('est', 'nth');
    plot(dxyz1(indexlost,1), dxyz1(indexlost,2),'ro');
    plot(dxyz1(indexsigle,1), dxyz1(indexsigle,2),'bo');
end
