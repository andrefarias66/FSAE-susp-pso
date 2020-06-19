function [pontos, angulos, dim] = calculaRoda(P_3, P_6)
%Declaração das variáveis globais
    global A_camber    %Angulo de Camber                            [graus]
    global A_toe       %Angulo de TOE                               [graus]
    global D_raioPneu  %Raio do pneu                                   [mm]    
    global P_cp        % Ponto de contato do pneu com o solo (x, y, z) [mm]

    %Obtencao da inclinacao do pino mestre (KPI) e o raio de scrub
    A_kpi = atand((P_3(2)-P_6(2))/(P_6(3)-P_3(3)));                        %Equacao  9
    y_sc = P_3(3)*tand(A_kpi)+P_3(2);                                      %Equacao 11
    D_raioScrub = P_cp(2)-y_sc;                                            %Equacao 12

    %Obtencao do angulo de caster, caster trail e offset do pino mestre
    A_caster = atand((P_6(1)-P_3(1))/(P_6(3)-P_3(3)));                     %Equacao 13
    x_ct = P_3(1)-P_3(3)*tand(A_caster);                                   %Equacao 14
    D_casTrail = P_cp(1)-x_ct;                                             %Equacao 15
    P_scrub = [x_ct, y_sc, 0];
    
    P_14 = P_cp + ...                                                      %Equacao 18
        D_raioPneu*[sind(A_camber)*sind(A_toe), ...
        sind(A_camber)*cosd(A_toe), ...
        cosd(A_camber)*cosd(A_toe)];

    s = (cosd(A_camber)*cosd(A_toe)*sind(A_toe)* ...                       %Equação 36
        (P_14(2)*cosd(A_kpi) - y_sc*cosd(A_kpi) + ...
        P_14(3)*sind(A_kpi))) ...
        / ...
        (cosd(A_camber)*(cosd(A_toe))^2*cosd(A_kpi) - ...
        sind(A_camber)*sind(A_kpi)*(2*(cosd(A_toe))^2-1)^2);

    t = ((cosd(A_toe))^2*cosd(A_camber)) ...                               %Equação 37
        / ...                                                                  
        ((cosd(2*A_toe))^2*sind(A_camber)*tand(A_kpi)- ...
        (cosd(A_toe))^2*cosd(A_camber));

    u = ((cosd(2*A_toe))^2*sind(A_camber)) ...                             %Equação 38
        / ...
        ((cosd(2*A_toe))^2*sind(A_camber)*tand(A_kpi)- ...
        (cosd(A_toe))^2*cosd(A_camber));

    P_13 = [P_14(1)+s, ...                                                 %Equação 24
        P_14(2)-t*(y_sc-P_14(2)-P_14(3)*tand(A_kpi)), ...
        P_14(3)+u*(y_sc-P_14(2)-P_14(3)*tand(A_kpi))];

    pontos = [P_3; P_6; P_13; P_14; P_cp; P_scrub];
    angulos = [A_kpi, A_caster];
    dim = [D_raioScrub, D_casTrail];
end
