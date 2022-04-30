function [p,dop] = LM_LS(Xp,mi,sigma_d)
%LS Summary of this function goes here
%   Detailed explanation goes here
% remaking LS
dop = 0;
p=0;
xp = Xp(1);
yp = Xp(2);
psip = Xp(3);

di = mi(:,1);
thetai = mi(:,2);

x = xp+di.*cos(thetai+psip);
y = yp + di.*sin(thetai+psip);
% plot
% scatter(x,y,'.b')
% hold on
%%%%%%%%%% ACP FOR INITIAL GUESSES
M = cov(x,y);
[V,D,] = svd(M);
phi0 = atan2(V(2,1),V(1,1));
a0 = sqrt(2*D(1,1));
b0 = sqrt(2*D(2,2));
x_c0 = mean(x);
y_c0 = mean(y);
%%%%%%%%% INIT VALUES
p = [x_c0;y_c0;phi0;a0;b0;5];           % REORDERED
n = 1;
u = 1; % L-M parameter
J = drdp(Xp,mi,p);
H = J'*J;
R = r(Xp,mi,p);
g = J'*R;
cost(1) = 0.5*(R'*R);
d = [1;1;1;1;1;1]*0.000001;
D = diag([1 1 1 1 1 1]);
%%%%%%%%% LOOP
k = 1;
K = 100000;
while k < K
    if d'*d < 1e-15 || isnan(cost(end))
        break
    end
    n=n+1;
    % computing delta_k
    while 1
        % break condition
        if d'*d < 1e-15 || isnan(cost(end)) || n == 30
            break
        end
        %
        d = -(H+u*(D'*D))\g;
        R = r(Xp,mi,p+d);
        % evaluating the step
        cost(n) = 0.5*(R'*R);
        % if d_k accepted mu is decreased
        if cost(n)<cost(n-1)
            p = p+d;
            u = u/5;
            J = drdp(Xp,mi,p);
            H = J'*J;
            g = J'*R;
            dop = 0;%DOP(Xp,mi,p,sigma_d);
            break
        else
            u = u*1.5;
        end
    end 
    k = k + 1;
end

end

