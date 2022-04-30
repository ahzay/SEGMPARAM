function out = DOP(Xp,mi,p,sigma_d)
%DOP Summary of this function goes here
%   Detailed explanation goes here
H = dFdp(Xp,mi,p);
J_mes = dFdmu(Xp,mi,p);
Sigma_mes = J_mes*sigma_d^2*J_mes';
out = pinv(H'*pinv(Sigma_mes)*H);
end

