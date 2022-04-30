function [d,theta] = pointCloudToM(x,y,path)
x=x';y=y';
x_p = path(1); y_p = path(2);
d = vecnorm([x-x_p y-y_p],2,2);
theta = atan2(y-y_p,x-x_p);
end

