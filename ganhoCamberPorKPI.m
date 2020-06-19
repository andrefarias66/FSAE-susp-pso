function [ganhoCamber] = ganhoCamberPorKPI(est, KPI)
%GANHOCAMBER Summary of this function goes here
%   Detailed explanation goes here
    ganhoCamber = KPI + acosd(sind(KPI)*cosd(est))-90;
    %retorno = [est;ganhoCamber];
end

