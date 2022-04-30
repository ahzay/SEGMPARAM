function out = drdxc(Xp,mi,p)
%DRDA Summary of this function goes here
%   Detailed explanation goes here

a = p(4);
b = p(5);

% r = sqrt(a*b) * Fs(Xp,mi,p);
out = sqrt(a*b)*dFdxc(Xp,mi,p);
end
