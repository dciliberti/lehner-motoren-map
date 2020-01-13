% Calculate the Lehner 2280-40 electric motor map from performance data
% issued by the manufacturer. Plot propeller operating points on the map.
% Version 6. Code compacted with functions, now it should be easier to add
% other charts or features.
close all; clearvars; clc

%% User-provided data
conditionLabels = {'Desired values','XROTOR','CFD'};

% Operative points: J, Shaft Power (W), RPM
condition{1} = [1.46    403   9801
                1.95    174   7351];

condition{2} = [1.57	849     9162
                1.73	585     8329
                1.88	411     7635
                2.04	293     7047
                2.20	211     6544
                2.36	153     6108
                2.51	112     5726
                2.67	83      5389
                2.83	67      5090];

condition{3} = [1.4     1137	10274
                1.6     679     8990
                1.8     429     7991
                2.0     284     7192
                2.2     195     6538
                2.4     141     5993];

% conditionLabels = {'diretta 1:1', 'ridotta 1:2'};
% condition{1} = [
%     0.47	12939	11141
%     0.63	5497	8356
%     0.79	3034.3	6685
%     0.94	1942.5	5570
%     1.10	1374.1	4775
%     1.26	1038.4	4178
%     1.41	787.28	3714
%     1.57	557.28	3342
%     1.73	383.67	3038
%     1.88	259.54	2785
%     2.04	169.35	2571
%     2.20	102.46	2387
%     ];
% 
% condition{2} = [
%     0.47	12939	22282
%     0.63	5497	16711
%     0.79	3034.3	13369
%     0.94	1942.5	11141
%     1.10	1374.1	9549
%     1.26	1038.4	8356
%     1.41	787.28	7427
%     1.57	557.28	6685
%     1.73	383.67	6077
%     1.88	259.54	5570
%     2.04	169.35	5142
%     2.20	102.46	4775
%     ];

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
for i = 1:numel(condition)
    % create a temporary variable to access cell data
    tempMat =  condition{i};
    tempMat(:,4) = griddata(s,r,c,tempMat(:,2),tempMat(:,3)); % current
    tempMat(:,5) = griddata(s,r,t,tempMat(:,2),tempMat(:,3)); % torque
    tempMat(:,6) = griddata(s,r,h,tempMat(:,2),tempMat(:,3)); % efficiency
    condition{i} = tempMat;
end

% CONDITION = [J, SHAFT POWER, RPM, CURRENT, TORQUE, EFFICIENCY];

%% Calculate SHAFT POWER from RPM and CURRENT
[xsrc, ysrc] = meshgrid((0:100:11000)./scale, 0:0.1:15);  % x: RPM, y: Ampere
zsrc = griddata(r,c,s,xsrc,ysrc);

plotData(condition,conditionLabels,V,...
    xsrc,ysrc,zsrc,3,1,5,scale,1,1)

%% Calculate EFFICIENCY from RPM and TORQUE
[xert, yert] = meshgrid((0:100:11000)./scale, 0:1:70);  % x: RPM, y: Ncm
zert = griddata(r,t,h,xert,yert);

plotData(condition,conditionLabels,V,...
    xert,yert,zert,3,4,6,scale,1,1)

%% Calculate EFFICIENCY from RPM and CURRENT
[xerc, yerc] = meshgrid((0:100:11000)./scale, 0:0.1:15);  % x: RPM, y: Ncm
zerc = griddata(r,c,h,xerc,yerc);

plotData(condition,conditionLabels,V,...
    xerc,yerc,zerc,3,1,6,scale,1,1)
