function [] = CDFPLOT(ERRO)

	ERRO=abs(ERRO);
    Range=[0:0.01:0.2]';
    N=hist(ERRO,Range);
    hold on;
    
    cdf=cumsum(N(:,1))/sum(N(:,1));
    plot(Range,cdf,'LineWidth',2,'LineStyle','--','color','b');
    cdf=cumsum(N(:,2))/sum(N(:,2));
    plot(Range,cdf,'LineWidth',2,'LineStyle','--','color','g');
    cdf=cumsum(N(:,3))/sum(N(:,3));
    plot(Range,cdf,'LineWidth',2,'LineStyle','--','color','r');
    
    xlabel('Îó²î/¡ã')
    ylabel('CDF')
    ylim([0.1,1.1])
    legend('¸©Ñö½Ç','ºá¹ö½Ç','º½Ïò½Ç')
    grid on;
end

