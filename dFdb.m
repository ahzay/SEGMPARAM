function out = dFdb(Xp,mi,p)
%DFDB Summary of this function goes here
%   Detailed explanation goes here

xp = Xp(1);
yp = Xp(2);
psip = Xp(3);

xc = p(1);
yc = p(2);
phi = p(3);
a = p(4);
b = p(5);
epsilon = p(6);

di = mi(:,1);
thetai = mi(:,2);

F1 = ((xp+di.*cos(thetai+psip)-xc)*cos(phi) + ...
    (yp + di.*sin(thetai+psip)-yc)*sin(phi))/a;
F2 = ((xp+di.*cos(thetai+psip)-xc)*sin(phi) - ...
    (yp + di.*sin(thetai+psip)-yc)*cos(phi))/b;

s = 1/epsilon;

dF1db = 0;
dF2db = -((xp+di.*cos(thetai+psip)-xc)*sin(phi) - ...
    (yp + di.*sin(thetai+psip)-yc)*cos(phi))/b^2;

out = 2 * (dF1db.*F1.*(F1.^2).^(s-1) + dF2db.*F2.*(F2.^2).^(s-1))...
    .*((F1.^2).^(s) + (F2.^2).^(s)).^ (epsilon - 1);

end
