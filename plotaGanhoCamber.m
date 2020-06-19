function plotaGanhoCamber(A_kpi, A_caster)
global A_esterEsq A_esterDir

ester = A_esterEsq:1:A_esterDir;

gcKpi = ganhoCamberPorKPI(ester, A_kpi);
gcCaster = ganhoCamberPorCaster(ester, A_caster);
gcEsterco = ganhoCamberPorEsterco(ester, A_caster, A_kpi);

data = findall(gca, 'Type', 'Line');
delete(data);

%title('Ganho de camber devido ao esterço');
grid on;
xlabel(['Esterçamento da roda [' char(176) ']']);
ylabel(['Ganho de camber [' char(176) ']']);

hold on

plot(ester, gcKpi, 'r', 'LineWidth',1);
%plot([0, 0], [min(gcKpi), max(gcKpi)], 'k', 'LineWidth',1, 'Color', [180 180 180]/255);
plot(ester, gcCaster, 'g', 'LineWidth',1);
%plot([0, 0], [min(gcCaster), max(gcCaster)], 'k', 'LineWidth',1, 'Color', [180 180 180]/255);
plot(ester, gcEsterco, 'b', 'LineWidth',3);
plot([0, 0], [min(min(gcCaster), min(gcKpi)), max([max(gcCaster), max(gcKpi), max(gcEsterco)])], 'k', 'LineWidth',1, 'Color', [180 180 180]/255);

plot([A_esterEsq, A_esterDir], [1.63, -1.32], 'k', 'LineWidth',1, 'Color', [180 180 180]/255);
plot([A_esterEsq, A_esterDir], [1.63, -1.32], 'ok');

%gcCaster(1)
%gcCaster(length(gcCaster))
lgd = legend('Ganho pelo KPI', 'Ganho pelo caster', 'Ganho total pelo esterço');
%lgd.Location = 'North';

hold off


end