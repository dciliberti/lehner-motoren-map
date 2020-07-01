% Calculate the Lehner 2280-40 electric motor map from performance data
% issued by the manufacturer. Plot propeller operating points on the map.
% Version 8. Code includes annotations on propeller thrust data and gear
% ratio, accounting for mechanical losses (provided by the user).
close all; clearvars; clc

%% User-provided data
propDiam = 0.3;     % propeller diameter, m
windSpeed = 20;     % wind tunnel speed, m/s
Jconv = windSpeed/propDiam*60;    % J = V/nD = Jconv/RPM

% Plot labels
conditionLabels = {'5-blades wood'};

% Operative points: Thrust (N), Shaft Power (W), RPM
condition{1} = [79.15	3561.2	13333
    38.59	1435.7	10000
    20.47	678.1	8000
    11.00	344.0	6667
    5.49	176.4	5714
    2.01	83.3	5000
    -0.25	28.5	4444];

% condition{1} = [8.8     403     9801
%                 4.0     174     7351];
%
% condition{2} = [14.8	998.5	11446
%                 11.0	697.7	10174
%                 8.3     496.5	9157
%                 6.3     358.3	8324
%                 4.7     261.0	7631
%                 3.6     191.0	7044
%                 2.6     139.3	6541
%                 1.9     100.5	6105
%                 1.3     70.9	5723
%                 0.8     47.9	5386
%                 0.4     29.8	5087];
%
% condition{3} = [9.42	613     10274
%                 6.39	390     8990
%                 4.36	256     7991
%                 2.93	171     7192
%                 1.90	114     6538
%                 1.14	75      5993];
%
% condition{4} = [0.06	6.0     5192
%                 0.22	13.4	5379
%                 0.46	21.9	5568
%                 0.58	32.3	5740
%                 0.85	43.3	5933
%                 1.06	53.6	6123
%                 1.28	64.4	6308
%                 1.48	75.8	6486
%                 1.85	94.6	6760
%                 2.28	118.8	7082
%                 2.74	145.9	7420
%                 3.32	181.6	7815
%                 4.06	225.2	8253
%                 4.71	264.3	8621
%                 5.56	318.4	9061];

% conditionLabels = {'DEP 20cm 8000','TIP 40cm 6000','TIP 40cm 4000','TIP 40cm 3000','TIP 40cm 2000'};
%
% condition{1} = [14.00	467.88	8800];
% condition{2} = [20.456	554.29	6366.2];
% condition{3} = [14.716	376.12	3819.7];
% condition{4} = [21.1	563.41	3183.1];
% condition{5} = [16.33	454.48	2000];

% Gearbox gear ratios, one per condition, used to gain torque at a lower
% speed, i.e. the motor moves the gearbox input shaft at higher rpm with a
% lower torque, while the propeller is linked to the output gearbox shaft,
% rotating at lower rpm with a higher torque. The power is obviuously the
% same, except for the mechanical losses of the gearbox.
% In this code we look at the motor.
gratio = [1]; % gear ratio
gloss = [0]; % gearbox losses
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
