function drawSuperEllipse(A,x_c,y_c,phi,a,b,epsilon)
%DRAWELLIPSE Summary of this function goes here
%   Detailed explanation goes here
t=linspace(0,2*pi,10000);
X = abs(cos(t)).^(2/epsilon).*a.*sign(cos(t));
Y = abs(sin(t)).^(2/epsilon).*b.*sign(sin(t));
Xrot = [cos(phi) -sin(phi)]*[X;Y]+x_c;
Yrot = [sin(phi) cos(phi)]*[X;Y]+y_c;
plot(A,Xrot,Yrot,'-r')
axis equal
hold off
% legend('detected points','vehicle location','estimated ellipse')
xlabel('x')
ylabel('y')

end

