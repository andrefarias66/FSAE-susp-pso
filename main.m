clear all
clc
%format shortG %bank 

%Declara��o das vari�veis globais
    global A_camber       % �ngulo de Camber                                  [graus]
    global A_toe          % �ngulo de TOE                                     [graus]
    global A_esterEsq     % �ngulo m�nimo de ester�o (+ para fora do carro)   [graus]
    global A_esterDir     % �ngulo m�ximo de ester�o (- para dentro do carro) [graus]
    global D_raioPneu     % Raio do pneu                                         [mm]   
    global D_talaPneu     % Tala do pneu                                         [mm]   
    global D_raioIntRoda  % Raio interno da roda                                 [mm]
    global D_offsetRoda   % Offset do plano de fixa��o da roda                   [mm]
    global D_raioPctFreio % Raio do empacotamento do freio                       [mm]
    global D_hPctFreio    % Altura do cilindro de empacotamento do freio         [mm]
    global P_cp           % Ponto de contato do pneu com o solo (x, y, z)        [mm]
    global gcEsterEsq     % Ganho de camber devido ao ester�amento m�ximo     [graus]
    global gcEsterDir     % Ganho de camber devido ao ester�amento m�nimo     [graus]
    
%Atribui��o dos par�metros �s vari�veis globais    
    A_camber = -2;
    A_toe = -0.25;       
    A_esterEsq = -30;
    A_esterDir = 25;
    
    gcEsterEsq = 1.63;
    gcEsterDir = -1.32;
    
    D_raioPneu = 266.77;
    D_talaPneu = 150;
    D_raioIntRoda = 170;
    D_offsetRoda = 34.5;
    D_raioPctFreio = 150;
    D_hPctFreio = 50;
    P_cp = [629.9914, 624.9999, 0];
    

    
%Declara��o da fun��o objetivo    
    fun = @(p)funcaoObjetivo([p(1), p(2), p(3)], [p(4), p(5), p(6)]);
        
%Declara��o dos limites superiores e inferiores   
    tol = 150;
    lb = [P_cp(1)-tol, P_cp(2)-tol, 50, P_cp(1)-tol, P_cp(2)-tol, 300];
    ub = [P_cp(1)+tol, P_cp(2)+tol, 200, P_cp(1)+tol, P_cp(2)+tol, 550];
    
%Configura��o do algoritmo PSO    
    options = optimoptions('particleswarm','SwarmSize',100);                % N�mero de pontos do enxame
    %options = optimoptions(options, 'MaxIterations', 1000*6);               % N�mero m�ximo de itera��es
    options = optimoptions(options, 'ObjectiveLimit', 0);                  % Limite da minimiza��o da fun��o objetivo
    %options = optimoptions(options,'PlotFcn',@plotSwarm);                  % Fun��o de plotagem a cada itera��o
    %options = optimoptions(options,'OutputFcn', @plotSwarm);                  % Fun��o de plotagem a cada itera��o
    %options = optimoptions(options, 'MaxStallIterations', 20);        
    %options = optimoptions(options, 'FunctionTolerance', 1e-10);              
    %options = optimoptions(options,'SelfAdjustmentWeight',1);
    %options = optimoptions(options,'SocialAdjustmentWeight',0.4);
    
    tic()                                                                  % Inicio do contador do tempo de execu��o
    rng default
    [x, fval, flag, out] =  particleswarm(fun, 6, lb, ub, options);                    % Inicio da otimiza��o
    toc()                                                                  % Fim do contador do tempo de execu��o
    fval
    out

% Vizualiza��o dos resultados
    [pontos, angulos, dim] = calculaRoda([x(1), x(2), x(3)], [x(4), x(5), x(6)]);
    %plotaRoda(pontos, angulos)
    P_3 = [x(1), x(2), x(3)]
    P_6 = [x(4), x(5), x(6)]
    P_13 = pontos(3,:)
    P_14 = pontos(4,:)
    D_raioScrub = dim(1)
    D_casTrail = dim(2)
    A_caster = angulos(2)
    A_kpi = angulos(1)
    Raio = norm(P_6-P_3)                                                   % Dist�ncia entre os pontos P_3 e P_6

    gCC = acosd(sind(A_caster)*sind(A_esterDir))-90; %Ganho de camber durante o ester�o devido ao caster
    gCK = A_kpi + acosd(sind(A_kpi)*cosd(A_esterDir))-90; %Ganho de camber durante o ester�o devido ao kpi
    gCamberDir = gCC + gCK % Ganho de camber total durante o ester�o
    
    gCC = acosd(sind(A_caster)*sind(A_esterEsq))-90; %Ganho de camber durante o ester�o devido ao caster
    gCK = A_kpi + acosd(sind(A_kpi)*cosd(A_esterEsq))-90; %Ganho de camber durante o ester�o devido ao kpi
    gCamberEsq = gCC + gCK % Ganho de camber total durante o ester�o