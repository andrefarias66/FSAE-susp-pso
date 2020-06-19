function plotaRoda(pontos, angulos)
%Declaração das variáveis globais
global D_raioPneu    %Raio do pneu                                      [mm]
global D_talaPneu    %Tala do pneu                                      [mm]
global D_raioIntRoda % Raio interno da roda                             [mm]
global P_cp          % Ponto de contato do pneu com o solo (x, y, z)    [mm]
global D_raioPctFreio D_offsetRoda

P_3 = pontos(1,:);
P_6 = pontos(2,:);
P_13 = pontos(3,:);
P_14 = pontos(4,:);
P_scrub = pontos(6,:);

A_kpi = angulos(2);

    data = findall(gca, 'Type', 'Line');
    delete(data);
    data = findall(gca, 'Type', 'Surface');
    delete(data);

hold on

% Plotar o eixo de esterço
l1 = plot3([P_3(1), P_6(1)] , [P_3(2), P_6(2)], [P_3(3), P_6(3)], '-r', 'LineWidth',5, 'DisplayName', 'Eixo de esterçamento');
l2 = plot3([P_3(1), P_6(1)] , [P_3(2), P_6(2)], [P_3(3), P_6(3)], 'ro','MarkerSize',8, 'LineWidth',3, 'DisplayName', 'Pontos P_3 e P_6');

% Plotar o spindle
l3 = plot3([P_13(1), P_14(1)] , [P_13(2), P_14(2)], [P_13(3), P_14(3)], '-g', 'LineWidth', 5, 'DisplayName', 'Eixo de rotação da roda');

% Plotar a roda
if P_14(1) > P_13(1)
    vetor = (P_14-P_13)/(norm(P_14-P_13));
else
    vetor = (P_13-P_14)/(norm(P_13-P_14));
end
filet = 30;
[X,Y,Z] = cylinder2P(D_raioPneu,30, P_14-((D_talaPneu-filet)/2)*vetor,P_14+((D_talaPneu-filet)/2)*vetor);
l4 = surf(X,Y,Z, 'FaceAlpha', 0.01, 'EdgeAlpha', 0.3, 'FaceColor', [0.25, 0.25, 0.25], 'DisplayName', 'Pneu');
[X,Y,Z] = cylinder2P([D_raioPneu, D_raioPneu-filet],30, P_14+((D_talaPneu-filet)/2)*vetor,P_14+((D_talaPneu-filet)/2+filet)*vetor);
surf(X,Y,Z, 'FaceAlpha', 0.01, 'EdgeAlpha', 0.3, 'FaceColor', [0.25, 0.25, 0.25]);
[X,Y,Z] = cylinder2P([D_raioPneu, D_raioPneu-filet],30, P_14-((D_talaPneu-filet)/2)*vetor,P_14-((D_talaPneu-30)/2+filet)*vetor);
surf(X,Y,Z, 'FaceAlpha', 0.01, 'EdgeAlpha', 0.3, 'FaceColor', [0.25, 0.25, 0.25]);

[X,Y,Z] = cylinder2P(D_raioIntRoda, 30, P_14-((D_talaPneu)/2)*vetor,P_14+((D_talaPneu)/2)*vetor);
surf(X,Y,Z, 'FaceAlpha', 0.01, 'EdgeAlpha', 0.3, 'FaceColor', [0.9290, 0.6940, 0.1250]);
plot3([P_cp(1), P_14(1)] , [P_cp(2), P_14(2)], [P_cp(3), P_14(3)], '-k', 'LineWidth',3);

% Restrição interna da roda
[X,Y,Z] = cylinder2P(D_raioPctFreio, 30, P_14-300*vetor,P_14+D_offsetRoda*vetor);
%surf(X,Y,Z, 'FaceAlpha', 0.5, 'FaceColor', [0.9290, 0.6940, 0.1250]);
plot3([P_cp(1), P_14(1)] , [P_cp(2), P_14(2)], [P_cp(3), P_14(3)], '-k', 'LineWidth',3);


% Plotar o contact path
plot3(P_cp(1), P_cp(2), P_cp(3), 'dk');

% Plotar o cruzamento do steering axis com o solo
l5 = plot3([P_cp(1), P_scrub(1)] , [P_cp(2), P_scrub(2)], [P_cp(3), P_scrub(3)], '-b', 'LineWidth',5, 'DisplayName', 'Composição dos vetores y_sc e x_ct');
l6 = plot3([P_3(1), P_scrub(1)] , [P_3(2), P_scrub(2)], [P_3(3), P_scrub(3)], '-c','MarkerSize',8, 'LineWidth',3, 'DisplayName', 'Prolongamento do eixo de esterçamento');
%legend([l1,l2,l3,l4,l5,l6])

%Planos
%X = [P_3(1)-200, P_3(1)+200; P_6(1)-200, P_6(1)+200];
%Y = [P_3(2), P_3(2); P_6(2), P_6(2)];
%Z = [P_3(3), P_3(3); P_6(3), P_6(3)];
%surf(X,Y,Z, 'FaceAlpha', 0.5, 'FaceColor', [0.9290, 0.6940, 0.1250]);
%surf(X,Y,Z, 'FaceAlpha', 0.5);


hold off

%set(gca, 'XDir','reverse');
view(45, 20);
daspect([1 1 1]);
axis([P_cp(1)-300, P_cp(1)+300, P_cp(2)-250, P_cp(1)+250, 0, 600]);


end

