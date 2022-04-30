function out = drda(Xp,mi,p)
%DRDA Summary of this function goes here
%   Detailed explanation goes here

a = p(4);
b = p(5);

% r = sqrt(a*b) * Fs(Xp,mi,p);
% drda  = d(sqrt(a*b)da * Fs(Xp,mi,p) + sqrt(a*b) * dFda(Xp,mi,p)
out = b/(2*sqrt(a*b)) * Fs(Xp,mi,p) + sqrt(a*b) * dFda(Xp,mi,p);


end

