function [P,Sigma,bp] = kfbs(P0,Sigma0,Xp,mi,Q,W,tol)
%KFBS Summary of this function goes here
%   Detailed explanation goes here

    I = eye(size(Sigma0));
    bp = 0;
    Pk_plus = P0;
    Sigmak_plus = Sigma0;
    % Propagation
    Pk = P0;
    Sigmak = Sigma0 + Q;
    
    Hk = Hkj(Xp,mi,Pk);
    Jk = Jkj(Xp,mi,Pk);
    
    %Observations
    rk = -Fs(Xp,mi,Pk);
    Sk = Hk*Sigmak*Hk' + Jk*W*Jk';
    
    % Mahalanobis distance
    m_dist = mahalanobisdist(Xp,mi,Pk,Sk);
    %disp([m_dist Sk])
    if m_dist > tol
        % Break point or aberrant measure
        bp = 1;
    end
    
    % Gain
    Kk = Sigmak * Hk'/Sk;

    % Update
    Pk_plus = Pk + Kk*rk;
    Sigmak_plus = (I - Kk*Hk)* Sigma0;

    Sigma = [Sigmak, Sigmak_plus];
    P = [Pk, Pk_plus];
    %bp = m_dist;
end

