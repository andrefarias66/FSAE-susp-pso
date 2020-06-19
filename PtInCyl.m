function ret = PtInCyl(P, P1, P2, r)
%PTINCYL Summary of this function goes here
%   Detailed explanation goes here
    %P = ponto em análise
    %P1 = ponto inicial do cilindro
    %P2 = ponto final do cilindro
    %r = raio do cilindro
    
    if dot(P-P1, P2-P1) >= 0 && dot(P-P2, P2-P1) <= 0
        dist = norm(cross(P-P1, P2-P1))/norm(P2-P1);
        if dist ~= 0
            ret = dist-r;
        else
            ret = 0;
        end
    else
        ret = 1e+20;
        %ret = (dist-r)*max(dot(P-P1, P2-P1), dot(P2-P, P2-P1));
    end
end

