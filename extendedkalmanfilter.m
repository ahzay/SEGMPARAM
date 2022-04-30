function out = extendedkalmanfilter(P0,Sigma0,Xp,M,Q,W)
%EXTENDEDKALMANFILTER Summary of this function goes here
%   Detailed explanation goes here

N = size(M,1);

pi = P0;
Sigmai = Sigma0;
I = eye(size(sigmai));

for i=1:N
    
    % Measure
    mi = M(i,:);
    
    Hi = Hkj(Xp,mi,pi);
    Ji = Jkj(Xp,mi,pi);
    
    %Observations
    ri = -Fs(Xp,mi,pi);
    Si = Hi*Sigmai*Hi' + Ji*W*Ji';
    
    
    % Gain
    Ki = Sigmai * Hi'/Si;
    
    % Update
    pi_plus = pi + Ki*ri;
    Sigmai_plus = (I - Ki*Hi)* Sigmai;
    
    % Propagation
    pi = pi_plus;
    Sigmai = Sigmai_plus + Q;
end

out = pi;
end

