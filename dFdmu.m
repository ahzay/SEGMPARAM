function out = dFdmu(Xp,mi,p)
%DFDMU Summary of this function goes here
%   Detailed explanation goes here

dF_dmud = dFdmud(Xp,mi,p);
dF_dmutheta = dFdmutheta(Xp,mi,p);

out = [dF_dmud dF_dmutheta];

end

