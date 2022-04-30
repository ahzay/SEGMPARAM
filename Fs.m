function out = Fs(Xp,mi,p)
%FS Summary of this function goes here
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

out = ((F1.^2).^(1/epsilon) + (F2.^2).^(1/epsilon)).^ epsilon - 1;
end

