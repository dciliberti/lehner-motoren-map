% Calculate the Lehner 2280-40 electric motor map from performance data
% issued by the manufacturer. Plot propeller operating points on the map.
% Version 8. Code includes annotations on propeller thrust data and gear
% ratio, accounting for mechanical losses (provided by the user).
close all; clearvars; clc

%% User-provided data
propDiam = 0.3;     % propeller diameter, m
windSpeed = 20;     % wind tunnel speed, m/s
Jconv = windSpeed/propDiam*60;    % J = V/nD = Jconv/RPM
% Jconv is used as reference value to plot both RPM and J axes. Therefore,
% if the propeller data refer to other values of wind speed or diameter,
% the match between J and RPM will be not correct and only RPM should be
% taken in consideration.

% Operative points: Thrust (N), Shaft Power (W), RPM
conditionLabels = {'DEP prop 30cm','TIP prop 40cm'};

condition{1} = [74.15	3179.4	13333
    37.32	1317.6	10000
    20.72	645.7	8000
    11.94	345.3	6667
    6.82	191.2	5714
    3.61	104.4	5000
    1.50	52.1	4444];

condition{2} = [140.73	9677.2	6667
    73.68	4106.3	5000
    43.37	2098.7	4000
    27.30	1198.4	3333
    17.82	732.3	2857
    11.77	465.2	2500
    7.69	300.6	2222
    4.83	193.6	2000
    2.76	121.3	1818];

% Gearbox gear ratios, one per condition, used to gain torque at a lower
% speed, i.e. the motor moves the gearbox input shaft at higher rpm with a
% lower torque, while the propeller is linked to the output gearbox shaft,
% rotating at lower rpm with a higher torque. The power is obviuously the
% same, except for the mechanical losses of the gearbox.
% In this code we look at the motor.

gratio = [1, 4]; % gear ratio
gloss = [0.05, 0.05]; % gearbox losses
for i = 1:numel(condition)
    condition{i}(:,3) = condition{i}(:,3) .* gratio(i);
    condition{i}(:,2) = condition{i}(:,2) .* (1+gloss(i));
end

% Update plot labels with gear ratio e gearbox losses
for i = 1:numel(condition)
    conditionLabels{i} = [conditionLabels{i}, ' 1:',num2str(gratio(i))];
end

%% Lehner performance data
v = 0;
for i = 1:12
    v = v + 5;
    V{i} = csvread(['data\V', num2str(v), '.csv']);
end

scale = 1000; % Scale factor over RPM for better interpolation
for i = 1:numel(condition)
    % create a temporary variable to manipulate part of cell data
    tempMat =  condition{i};
    tempMat(:,3) = tempMat(:,3) ./ scale;
    condition{i} = tempMat;
end

% Current	Input power     RPM     Momentum	Output power	Efficiency
% A         W               /min	Ncm         W	            %
c = [];
e = [];
r = [];
t = [];
s = [];
h = [];
limCur = [];
limInp = [];
limRPM = [];
limMom = [];
limPow = [];
limEta = [];
for i = 1:12
    % gather data for interpolation
    c = [c; V{i}(:,1)]; % Current
    e = [e; V{i}(:,2)]; % Input (electric) power
    r = [r; V{i}(:,3)]; % RPM (scaled)
    t = [t; V{i}(:,4)]; % Momentum (torque)
    s = [s; V{i}(:,5)]; % Output (shaft) power
    h = [h; V{i}(:,6)]; % Efficiency
    % limit curves
    limCur = [limCur; V{i}(end,1)];
    limInp = [limInp; V{i}(end,2)];
    limRPM = [limRPM; V{i}(end,3)];
    limMom = [limMom; V{i}(end,4)];
    limPow = [limPow; V{i}(end,5)];
    limEta = [limEta; V{i}(end,6)];
end
r = r ./ scale;
limRPM = limRPM ./ scale;

% Interpolate data to caclculate current drawn, motor torque and propeller
% efficiency at assigned operating points
warning('off','backtrace')
for i = 1:numel(condition)
    % create a temporary variable to access cell data
    tempMat =  condition{i};
    tempMat(:,4) = griddata(s,r,c,tempMat(:,2),tempMat(:,3)); % current
    tempMat(:,5) = griddata(s,r,t,tempMat(:,2),tempMat(:,3)); % torque
    tempMat(:,6) = griddata(s,r,h,tempMat(:,2),tempMat(:,3)); % efficiency
    condition{i} = tempMat;
    
    % Display a warning if no solution is found for the i-th condition
    % (i.e. the required performance is out of the motor map)
    if any(all(isnan(tempMat(:,4:6)),1))
        warning(['Outside motor map with ',conditionLabels{i}])
    end
end
warning('on','backtrace')

% CONDITION = [J, SHAFT POWER, RPM, CURRENT, TORQUE, EFFICIENCY];

%% Calculate SHAFT POWER from RPM and CURRENT
[xsrc, ysrc] = meshgrid((0:100:11000)./scale, 0:0.1:15);  % x: RPM, y: Ampere
zsrc = griddata(r,c,s,xsrc,ysrc);

plotData(condition,conditionLabels,V,...
    xsrc,ysrc,zsrc,3,1,5,scale,1,1,Jconv)

%% Calculate EFFICIENCY from RPM and TORQUE
[xert, yert] = meshgrid((0:100:11000)./scale, 0:1:70);  % x: RPM, y: Ncm
zert = griddata(r,t,h,xert,yert);

plotData(condition,conditionLabels,V,...
    xert,yert,zert,3,4,6,scale,1,1,Jconv)

%% Calculate EFFICIENCY from RPM and CURRENT
[xerc, yerc] = meshgrid((0:100:11000)./scale, 0:0.1:15);  % x: RPM, y: Ncm
zerc = griddata(r,c,h,xerc,yerc);

plotData(condition,conditionLabels,V,...
    xerc,yerc,zerc,3,1,6,scale,1,1,Jconv)
