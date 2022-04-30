function out = drdp(Xp,mi,p)
%DRDP Summary of this function goes here
%   Detailed explanation goes here
dr_dxc = drdxc(Xp,mi,p);
dr_dyc = drdyc(Xp,mi,p);
dr_dphi = drdphi(Xp,mi,p);
dr_da = drda(Xp,mi,p);
dr_db = drdb(Xp,mi,p);
dr_deps = drdeps(Xp,mi,p);

out = [dr_dxc dr_dyc dr_dphi dr_da dr_db dr_deps];
end

