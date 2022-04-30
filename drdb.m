function out = drdb(Xp,mi,p)
%DRDA Summary of this function goes here
%   Detailed explanation goes here

a = p(4);
b = p(5);

% r = sqrt(a*b) * Fs(Xp,mi,p);
% drdb  = d(sqrt(a*b)db * Fs(Xp,mi,p) + sqrt(a*b) * dFdb(Xp,mi,p)
out = a/(2*sqrt(a*b)).*Fs(Xp,mi,p) + sqrt(a*b).*dFdb(Xp,mi,p);



