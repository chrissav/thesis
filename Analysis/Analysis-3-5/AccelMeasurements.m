clear all; 
current_folder = pwd; 
data_folder = ([pwd, '\Data']); 
file_name = 'test4test4.csv'; 
params1 = [277.17 276.8257 325.7718 253.6234]; % fx fy cx cy, tests 1-5, 7
dC = 25; % (mm), object size ... not sure if this is right

M = csvread([data_folder, '\', file_name]); 
M = M(2:end, :); 
N = size(M, 1);

t = M(:, 1);
QuatRef = M(:, 21:24); % (w, x, y, z)
pU = M(:, 2:4)'; % position measurements from the undistorted image, image center already subtracted off
aS = M(:, 9:11)'; 

% Intrinsic camera parameters
params = params1; 
fx = params(1); 
fy = params(2); 
cx = params(3); cy = params(4); 
% Extrinsic camera parameters
R1 = [1 0 0; 0 0 -1; 0 1 0]; 
R2 = [0 1 0; -1 0 0; 0 0 1];
R3 = [1 0 0; 0 1 0; 0 0 1]; 
Ralign = R3 * R2 * R1; 
Talign = [38.2; -18.3; 490.5]; 
% Direct observations: position of the object in camera coordinates
zC = dC ./ (pU(3,:) * sqrt( 1/fx^2 + 1/fy^2 )); 
yC = zC .* pU(2,:) / fy; 
xC = zC .* pU(1,:) / fx; 
pC = cat(1, xC, yC, zC); 
% position of the object in world coordinates
pW = Ralign * pC + repmat(Talign, 1, size(pC, 2)); 

% Multiply by rotation matrix from body to world
sTb = [0 1 0; -1 0 0; 0 0 1]; 
bTs = sTb'; % rotation matrix from the sensor to the body
aW = zeros(size(aS)); 
for i = 1:N
    wRb = quat2rotm(QuatRef(i, :)); 
    aW(:, i) = wRb * bTs * aS(:, i); 
end


figure(1)
subplot(1,2,1)
plot(t, pW')
title('State observations (World)')
xlabel('Time stamp (s)')
ylabel('Position (mm)')
legend('x_{w}', 'y_{w}', 'z_{w}')
subplot(1,2,2)
plot(t, aW')
title('Acceleration Measurement')
xlabel('Time stamp (s)')
ylabel('Position (m / s^2)')
legend('x_{w}', 'y_{w}', 'z_{w}')