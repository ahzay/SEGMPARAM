function [xx,yy,zz,path,data] = simSetup(fullPath,shapes,shapelocs,initOnly)
%SIMSETUP Summary of this function goes here
%   shapes is a n x 1 array of shape names
%   locs   is a n x 1 array of 3d coordinates
clear x y z data
xx=[];yy=[];zz=[];
sim=remApi('remoteApi');
sim.simxFinish(-1);
clientID=sim.simxStart('127.0.0.1',19997,true,true,5000,5);
sim.simxLoadScene(clientID,fullPath,-1,sim.simx_opmode_blocking);
if (clientID>-1)
    %disp('Connected to remote API server');
    % Now try to retrieve data in a blocking fashion (i.e. a service call):
    [res,objs]=sim.simxGetObjects(clientID,sim.sim_handle_all,sim.simx_opmode_blocking);
    if (res==sim.simx_return_ok)
        %fprintf('Number of objects in the scene: %d\n',length(objs));
    else
        fprintf('Remote API function call returned with error code: %d\n',res);
    end
        
    pause(0.1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%% MAIN PROGRAM %%%%%%%%%
    %%% GET HANDLES
    [res, lidar] = sim.simxGetObjectHandle(clientID, '/VelodyneVPL16', sim.simx_opmode_oneshot_wait);
    shapeIDs = [];
    for i = 1:size(shapes,1)
        [res, shapeIDs(i)] = sim.simxGetObjectHandle(clientID, convertStringsToChars(shapes(i)), sim.simx_opmode_oneshot_wait);
    end
    %%% SET INITIAL LOCATIONS
    res = sim.simxSetObjectPosition(clientID,lidar,-1,[0,0,0.3],sim.simx_opmode_oneshot_wait);
    for i = 1:size(shapes,1)
        res = sim.simxSetObjectPosition(clientID,shapeIDs(i),-1,shapelocs(i,:),sim.simx_opmode_oneshot_wait);
    end
    %%% START SIMULATION
    sim.simxStartSimulation(clientID,sim.simx_opmode_blocking);
    pause(1);
    %%% GET INITIAL MAP
    [err, data] = sim.simxGetStringSignal(clientID,'measuredDataATT',sim.simx_opmode_streaming);
    pause(0.1);
    % get again, unpack and draw
    [err,x,y,z] = getPointCloud(sim,clientID,'measuredDataATT');
    scatter(x,y,'.')
    axis([-2 2 -2 2])
    hold on
    if initOnly == 1 
        sim.simxStopSimulation(clientID,sim.simx_opmode_oneshot_wait);
        sim.delete(); % call the destructor!
        xx=x;yy=y;zz=z;
        return
    end
    %%% DRAW PATH ON INITIAL MAP
    h = imfreehand('Closed',false);
    path = h.getPosition;
    hold off
    %%% FOLLOW PATH
    for i = 1:size(path,1)
        loc = path(i,:);
        pause(0.01);
        % set lidar loc
        res = sim.simxSetObjectPosition(clientID,lidar,-1,[loc(1),loc(2),0.3],sim.simx_opmode_oneshot_wait);
        pause(0.1);
        [err,x,y,z] = getPointCloud(sim,clientID,'measuredDataATT');
        % assign final data
        xx=[xx,x];yy=[yy,y];zz=[zz,z];
        %scatter3(x,y,z,'.')
        %hold on
        %scatter3(loc(1),loc(2),0.3,'bo')
        data(i).x = x(find(x));
        data(i).y = y(find(y));
        data(i).path = loc;
        %axis([-2 2 -2 2])
    end
    sim.simxStopSimulation(clientID,sim.simx_opmode_oneshot_wait);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    disp('Failed connecting to remote API server');
    xx=-1;yy=-1;zz=-1;
end
sim.simxStopSimulation(clientID,sim.simx_opmode_oneshot_wait);
sim.simxFinish(-1);
sim.delete(); % call the destructor!
end

