function objetivo = funcaoObjetivo(P_3, P_6)
%Declaração das variáveis globais
    global D_raioIntRoda  % Raio interno da roda                             [mm]
    global D_offsetRoda   % Offset do plano de fixação da roda               [mm]
    global A_esterDir A_esterEsq
    global gcEsterDir gcEsterEsq         % Ganho de camber devido a rolagem              [graus]
    
    global D_raioPctFreio % Raio do empacotamento do freio                   [mm]
    global D_hPctFreio

    [pontos, angulos, dim] = calculaRoda(P_3, P_6);
    P_13 = pontos(3,:);
    P_14 = pontos(4,:);
    
    D_raioScrub = dim(1);
    D_raioScrub_max = 40;
    D_raioScrub_min = 10;
    
    D_casTrail = dim(2);
    D_casTrail_max = 20;
    D_casTrail_min = 10;

    A_caster = angulos(2);
    A_caster_max = 5;
    A_caster_min = 0;

    A_kpi = angulos(1);
    A_kpi_max = 8;
    A_kpi_min = 0;

    objetivo = 0;
    vetor = (P_13-P_14)/(norm(P_13 - P_14));
    aux = PtInCyl(P_3, P_14+300*vetor, P_14-(D_offsetRoda-D_hPctFreio)*vetor, D_raioIntRoda);
    if aux > 0
        objetivo = objetivo + aux*1000;
    end
    aux = PtInCyl(P_6, P_14+300*vetor, P_14-(D_offsetRoda-D_hPctFreio)*vetor, D_raioIntRoda);
    if aux > 0
        objetivo = objetivo + aux*1000;
    end
    aux = PtInCyl(P_3, P_14+300*vetor, P_14-200*vetor, D_raioPctFreio);
    if aux < 0
        objetivo = objetivo + -aux*1000;
    end
    aux = PtInCyl(P_6, P_14+300*vetor, P_14-200*vetor, D_raioPctFreio);
    if aux < 0
        objetivo = objetivo + -aux*1000;
    end
    
    if D_raioScrub > D_raioScrub_max
        objetivo = objetivo + abs(D_raioScrub-D_raioScrub_max)*1000;
    elseif D_raioScrub < D_raioScrub_min
        objetivo = objetivo + abs(D_raioScrub-D_raioScrub_min)*1000;
    else
        %objetivo = objetivo + abs(D_raioScrub-D_raioScrub_sp)/1000;
    end
    
    if D_casTrail > D_casTrail_max
        objetivo = objetivo + abs(D_casTrail-D_casTrail_max)*1000;
    elseif D_casTrail < D_casTrail_min
        objetivo = objetivo + abs(D_casTrail-D_casTrail_min)*1000;
    else
        %objetivo = objetivo + abs(D_casTrail-D_casTrail_sp)/1000;
    end
    
    if A_caster > A_caster_max
        objetivo = objetivo + abs(A_caster-A_caster_max)*1000;
    elseif A_caster < A_caster_min
        objetivo = objetivo + abs(A_caster-A_caster_min)*1000;
    else
        %objetivo = objetivo + abs(A_caster-A_caster_sp)/1000;
    end
    
    if A_kpi > A_kpi_max
        objetivo = objetivo + abs(A_kpi-A_kpi_max)*1000;
    elseif A_kpi < A_kpi_min
        objetivo = objetivo + abs(A_kpi-A_kpi_min)*1000;
    else
        %objetivo = objetivo + abs(A_kpi-A_kpi_sp)/1000;
    end
    
    % Avaliação da função objetivo ocorre AQUI    
    gCC = acosd(sind(A_caster)*sind(A_esterDir))-90; %Ganho de camber durante o esterço devido ao caster
    gCK = A_kpi + acosd(sind(A_kpi)*cosd(A_esterDir))-90; %Ganho de camber durante o esterço devido ao kpi
    gcDir = gCC + gCK; % Ganho de camber total durante o esterço
   
    gCC = acosd(sind(A_caster)*sind(A_esterEsq))-90; %Ganho de camber durante o esterço devido ao caster
    gCK = A_kpi + acosd(sind(A_kpi)*cosd(A_esterEsq))-90; %Ganho de camber durante o esterço devido ao kpi
    gcEsq = gCC + gCK; % Ganho de camber total durante o esterço
    
    peso1 = 1;
    peso2 = 1;
    global objetivo1 objetivo2
    objetivo1 = abs(gcEsq-gcEsterEsq);
    objetivo2 = abs(gcDir-gcEsterDir);
    objetivo = objetivo + peso1*objetivo1 + peso2*objetivo2;
    
    
end

