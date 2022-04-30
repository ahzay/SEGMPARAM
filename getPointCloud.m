function [err,x,y,z] = getPointCloud(sim,clientID,label)
%GETPOINTCLOUD Summary of this function goes here
%   Detailed explanation goes here
[err, data] = sim.simxGetStringSignal(clientID,label,sim.simx_opmode_buffer);
pointCloudfloat = sim.simxUnpackFloats(data);
%%% UNPACK MAP
n=1;
for i = 1:(length(pointCloudfloat)/3-3)
    if pointCloudfloat(3*i+3) > 0.01
        x(n) = pointCloudfloat(3*i+1);
        y(n) = pointCloudfloat(3*i+2);
        z(n) = pointCloudfloat(3*i+3);
    end
    n=n+1;
end 
end

