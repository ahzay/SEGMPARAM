function out = r(Xp,mi,p)
%RES Summary of this function goes here
%   Detailed explanation goes here

a = p(4);
b = p(5);

out = sqrt(a*b) * Fs(Xp,mi,p);

end

