function [ganhoCamber] = ganhoCamberPorCaster(est, caster, metodo)
%GANHOCAMBER Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 3
       metodo = 'ang'; 
    end
        
   
    % est e caster s?o angulos em graus
    ganhoCamber = acosd(sind(caster).*sind(est))-90;   
   
end
