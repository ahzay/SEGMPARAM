function out = dFdp(Xp,mi,p)
%DFDP Summary of this function goes here
%   Detailed explanation goes here

dF_dxc = dFdxc(Xp,mi,p);
dF_dyc = dFdyc(Xp,mi,p);
dF_dphi = dFdphi(Xp,mi,p);
dF_da = dFda(Xp,mi,p);
dF_db = dFdb(Xp,mi,p);
dF_deps = dFdeps(Xp,mi,p);

out = [dF_dxc dF_dyc dF_dphi dF_da dF_db dF_deps];
end

