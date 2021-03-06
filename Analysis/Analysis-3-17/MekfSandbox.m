%% Load a data set of quaternions

%% Load the test data
DataFolder = (['C:\Users\Lukas Gemar\thesis\Analysis\Analysis-3-17\', 'Data\Sensor\']); 
AllTestNames = {'roll1', 'pitch1', 'yaw1', 'no_manuever1', 'rollslow1'}; 

TestName = AllTestNames{5}; 

SensorFile = [TestName, '.csv']; 
SensorData = csvread([DataFolder, SensorFile]); SensorData = SensorData(3:end, :); 
tSensor = SensorData(:,1)/1000; % it's in milliseconds 

N = size(SensorData,1); % Number of samples
dt = mean(diff(tSensor)); % Simulation time step
t = tSensor - min(tSensor); 

% Simulation variables
qref = SensorData(:,2:5); % quaternion reference array
qestT = zeros(N,4); % Triad estimates
qestK = zeros(N,4); % Kalman filter estimates
% z = [SensorData(:,6:8)./repmat(VectorNorm(SensorData(:,6:8)),1,3)...
%      SensorData(:,12:14)./repmat(VectorNorm(SensorData(:,12:14)),1,3)]; % sensor measurements
z = [SensorData(:,6:8),...
     SensorData(:,12:14)]; % sensor measurements
omega = SensorData(:,9:11); % gyro measurements
% omega = omega - repmat(mean(omega,1),N,1); % mean-subtracted gyro measurements

% Reference vectors
g = [0; 0; 9.81]; % world coordinates
% b = [cos(-pi/2-0.05)*1; sin(-pi/2-0.05)*1; 0]; % world coordinates
b = z(1,4:6)'; 

figure(1)
subplot(2,2,1)
plot( t, rad2deg( quat2eul( qref ) ) )
title('Quaternion Ref')
legend('yaw', 'pitch', 'roll')
subplot(2,2,2)
plot( t, omega )
title('Omega Input')
legend('X', 'Y', 'Z')
subplot(2,2,3)
plot( t,z(:,1:3) )
title('Accelerometer')
ylim([-1 1])
legend('X', 'Y', 'Z')
subplot(2,2,4)
plot( t, z(:,4:6) )
title('B Field')
legend('X', 'Y', 'Z')


%% Run the TRIAD algorithm over the data set

for i = 1:size(qref,1)
    
    mg = z(i,1:3)'; % measurement of g vector in body
    mb = z(i,4:6)'; % measurement of b vector in body
    
    qe =  triadFun(g,mg,b,mb,eye(3,3)); % column-major quaternion 
    qestT(i,:) = qflip( qe ); % row-major quaternion estimate
    
end

figure(2)
subplot(1,3,1)
degref = rad2deg( quat2eul( qref ) ); 
plot( t, degref )
legend('yaw', 'pitch', 'roll')
% plot( theta, qref )
% legend('w','x','y','z')
title('Reference')
ylim([-181 181])

subplot(1,3,2)
degestT = rad2deg( quat2eul( qestT ) ); 
plot( t, degestT )
legend('yaw', 'pitch', 'roll')
% plot( theta, qestT )
% legend('w','x','y','z')
title('Estimate')
ylim([-181 181])

subplot(1,3,3)
qerrorT = zeros(N,4); 
for i = 1:N
    qerrorT(i,:) = qflip( qmultiply( qflip( qref(i,:) ), qinv( qflip( qestT(i,:) ) ) ) ); 
end

plot( t, rad2deg( 2*qerrorT(:,2:4) ) )
legend('yaw', 'pitch', 'roll')
% plot( theta, qestT )
% legend('w','x','y','z')
title('Error')
ylim([-181 181])

Ptriad = cov(qerrorT(:,2:4));


%% Run the MEKF over the data set

% Compute initial state vector using TRIAD algorithm
mg = z(1,1:3)'; % measurement of g vector in body
mb = z(1,4:6)'; % measurement of b vector in body
qe = triadFun(g,mg,b,mb,eye(3,3)); % column-major quaternion 
qestK(1,:) = qflip( qe ); 

% Initalize the covariance matrix, process noise, and measurement noise
Sp = [deg2rad(10)^2 deg2rad(10)^2 deg2rad(15)^2]; Pe = diag(Sp); 
Sq = 0.1*(1/3)*[2.8e-6 2.8e-6 2.8e-6]'; Q = diag(Sq); 
Sr = (1/3)*[1.1e-6*ones(1,3) 17*ones(1,3)]'; R = diag(Sr); 

% Gyro gain and gyro gain reference
pgain = zeros(N-1,3); 
pgainref = zeros(N-1,3); 
inngain = zeros(N-1,3);

for k = 2:N

    % Covariance prediction (Pp)
    Pp = Pe + Q;

    % State prediction (Qp)
    deltaTheta = deg2rad( omega(k,:) )'; % * dt; 
   
%     if( norm(deltaTheta) > 0 )
%         beta = sin(norm(deltaTheta) / 2); 
%     else
%         beta = 0.5; 
%     end
    qp = [XiMat( qe ) qe] * [(0.7 * deltaTheta); 1]; 
    qp = qp / norm(qp);
    
    % Store gyro input, estimation and reference
    dqp = qmultiply( qp, qinv( qe ) ); 
    pgain(k,:) = 2*dqp(1:3)'; 
    
    dqpref = qmultiply( qflip( qref(k,:) ), qinv( qflip( qref(k-1,:) ) ) ); 
    pgainref(k,:) = 2*dqpref(1:3)'; 

    % Sensitivity matrix
    r1 = g; r2 = b; 
    pB1 = AMat( qp ) * r1; pB2 = AMat( qp ) * r2;
    H = [ 2*CrossMat( pB1 ); 2*CrossMat( pB2 )]; 

    % Kalman gain
    K = Pp * H' / (H * Pp * H' + R);

    % Observation, Prediction error
    Zm = z(k,:)';
    Zm(1:3) = Zm(1:3) / norm(Zm(1:3)); 
    Zm(4:6) = Zm(4:6) / norm(Zm(4:6)); 
    Ze = [ AMat( qp ) * r1 ; AMat( qp ) * r2]; 
    Nu = (Zm - Ze); 

    dq = [K * Nu; 1]; 
    
    % Store innovation gain
    inngain(k,:) = 2*dq(1:3)'; 

    % State update and 
    qe = [XiMat( qp ) qp] * dqe; 
    qe = qe / norm(qe); 
    
    inngain(k,:) = rad2deg( 2*dqe(1:3)' ); 
    
    % Covariance update
    Pe = (eye(3,3) - K * H) * Pp;
    
    sqerror(k) = trace(Pe); 
    
    qestK(k,:) = qflip( qe ); 
        
end

figure(3)
subplot(2,3,1)
plot( t, rad2deg( quat2eul( qref ) ) )
legend('yaw', 'pitch', 'roll')
% plot( theta, qref )
% legend('w','x','y','z')
title('Reference')
ylim([-181 181])

subplot(2,3,2)
plot( t, rad2deg( quat2eul( qestK ) ) )
legend('yaw', 'pitch', 'roll')
% plot( theta, qestT )
% legend('w','x','y','z')
title('Estimate')
ylim([-181 181])

subplot(2,3,3)


% plot( t, rad2deg( quat2eul( qerrorK ) ) )
degerrorK = rad2deg( quat2eul( qestK ) ) - rad2deg( quat2eul( qref ) ); 
plot(t, degerrorK)
legend('yaw', 'pitch', 'roll')
% plot( theta, qestT )
% legend('w','x','y','z')
% title(['E[\epsilon] :', num2str(mean(degerrorK(:,1)))])
title('Error')
ylim([-181 181])

subplot(2,3,4)
plot(t, pgain)
title('Prediction gain: $\delta \hat{\vec{\theta}}{^{(-)}}_k$', 'Interpreter', 'Latex')
ylabel('Rad')

subplot(2,3,5)
plot(t, pgainref)
title('True prediction gain: $\delta \vec{\theta}{^{(-)}}_k$', 'Interpreter', 'Latex')
ylabel('Rad')

subplot(2,3,6)
plot(t, inngain)
title('Innovation gain: $\delta \vec{\theta}{^{(+)}}_k$', 'Interpreter', 'Latex')
ylabel('Rad')


