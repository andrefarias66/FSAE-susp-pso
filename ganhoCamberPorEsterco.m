function [ganhoCamber] = ganhoCamberPorEsterco(est, caster, KPI)
%GANHOCAMBER Summary of this function goes here
%   Detailed explanation goes here
    gcCaster = ganhoCamberPorCaster(est, caster);
    gcKPI = ganhoCamberPorKPI(est, KPI);
    ganhoCamber = gcCaster+gcKPI;
    %retorno = [est; gcCaster(2,:)+gcKPI(2,:)];
end