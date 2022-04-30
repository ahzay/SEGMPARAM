%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Project: ELE6209A
%   Author: Aurey Tsemo Djoua
%   Date: 12 March 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = projet(A,data)
%% Load data
% data = load('scene_shape012_data.mat');
% visualize
% Get position of the robot
center = [data.path 0];
N = length(data.x);
x = data.x; y = data.y; path = data.path;
[dist, theta] = pointCloudToM(x,y,path);

%% Initialization
% Sensor noise parameters
sigma_d = 2e-2;
sigma_theta = 2e-2;
sigma = [sigma_d sigma_theta];
tol_flexible = 60;
tol_strict = 2;

%% Kalman Filter
% position of robot
Xp = center';

% Initializing state and error covariance matrix should be done with
% least-square
% P0 = [xc,yc,phi,a,b,epsilon]  

%%
% Initialize Kalman Filter state by using Least-squares
nsamples = 300;
[P0,Sigma0] = LM_LS([path 0]',[dist(1:nsamples,:) ...
    theta(1:nsamples,:)],sigma_d);
%%
% Dimension
n = 6;

% Initializing Q matrix should be done through least square
Q = diag([1e-2 1e-2 1e-2 1e-2 1e-2 1e-2].^2);

% Initializing W matrix should be done with sensors specification
W = diag([sigma_d^2 sigma_theta^2]);
Pk = P0;
Sigmak = Sigma0;

% Initializing both flexible and strict Extended Kalman Filter with the
% same initial state
% Parameters of flexible kalman filter
Pk_flexible = Pk;
Sigmak_flexible = Sigmak;
% Parameters of strict kalman filter
Pk_strict = Pk;
Sigmak_strict = Sigmak;
%P = [P0' 0];

% Matrix 3D to save measures for each aggregate
Mes.num = 1;
Mes.aggregates(Mes.num).data = [];

% Intialize break point flag to one
bp = 1;
for k=1:N
    mi = [dist(k) theta(k)];
    % Detection of aberrant measures
    if bp == 1
        % The flexible criteria is verifyed at the begining or if a break
        % point is reached
        [P_flexible,Sigma_flexible,am] = kfbs(Pk_flexible,Sigmak_flexible,...
            Xp,mi,Q,W,tol_flexible);
    end
%    P = [P;P_flexible(:,2)' am];

    if am == 0
        % Detection of break point
        [P_strict,Sigma_strict,bp] = kfbs(Pk_strict,Sigmak_strict,...
            Xp,mi,Q,W,tol_strict);
        if bp == 1
            % Break point
            % Initializing strict kalman filter parameters
            [Pk_strict,Sigmak_strict] = LM_LS([path 0]',[dist(k:k+nsamples,:) ...
                theta(k:k+nsamples,:)],sigma_d);
            
            Mes.num = Mes.num + 1;
            Mes.aggregates(Mes.num).data = [];
%             disp([k bp])

        else
            % Measure can be used as input in Least Square
            Pk_strict = P_strict(:,2);
            Sigmak_strict = Sigma_strict(:, n+1:end);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Here we can estimate the state by least-square
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Mes.aggregates(Mes.num).data = [Mes.aggregates(Mes.num).data;...
                mi];
        end

    else
        % Aberrant measure
        % Initializing flexible kalman filter parameters
        Pk_flexible = P_flexible(:,2);
        Sigmak_flexible = Sigma_flexible(:, n+1:end);
%         disp([k am])
    end

end
%% visualisation
scatter(A,path(1),path(2),'o')
hold on
for i = 1:Mes.num
    xvis = path(1) + Mes.aggregates(i).data(:,1).*cos(Mes.aggregates(i).data(:,2));
    yvis = path(2) + Mes.aggregates(i).data(:,1).*sin(Mes.aggregates(i).data(:,2));
    scatter(A,xvis,yvis,'.')
    hold on
    [P,] = LM_LS([path 0]',[Mes.aggregates(i).data(:,1) Mes.aggregates(i).data(:,2)],0);
    drawSuperEllipse(A,P(1),P(2),P(3),P(4),P(5),2/P(6))
    hold on
end
axis equal
hold off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end