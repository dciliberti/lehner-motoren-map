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

%% Calculate CURRENT from expected shaft power and RPM (propeller data)
[xa, ya] = meshgrid((0:100:11000)./scale, 0:0.1:15);  % x: RPM, y: Ampere
za = griddata(r,c,s,xa,ya);

% Plot section
figure
hold on
surf(xa,ya,za,'FaceColor','interp','LineStyle','none')
voltagePlot3(V,3,1,5,scale,1,1)

for i = 1:numel(condition)
    % create a temporary variable to access part of cell data
    tempMat =  condition{i};
    conditionCurves{i} = plot3(tempMat(:,3),tempMat(:,4),tempMat(:,2)+20,...
        '-o','LineWidth',3.0,'MarkerSize',3,'MarkerEdgeColor','black');
end

hold off, grid on, view(-20,30)
xlabel('RPM'), ylabel('Current, A'), zlabel('Shaft power, W')
colorbar
legend([conditionCurves{:}],conditionLabels,'Location','Best')

% Annotations on surf
annot3(V,3,1,5,scale,1,1)

for i = 1:numel(condition)
    tempMat =  condition{i};
    
    for j = 1:size(tempMat,1)
        text(tempMat(j,3),tempMat(j,4),tempMat(j,2)+20,...
            ['J = ',num2str(tempMat(j,1)), ' \rightarrow'], ...
            'HorizontalAlignment','right')
    end
    
end

% Scaling the RPM thick labels
rpmLabel = xticklabels;
for i = 1:numel(rpmLabel)
    rpmLabel{i} = str2double(rpmLabel{i}) * scale;
    rpmLabel{i} = num2str(rpmLabel{i});
end
xticklabels(rpmLabel)

% Contour plot
figure
hold on
[C,H] = contourf(xa,ya,za,0:50:700);
voltagePlot(V,3,1,scale,1)

for i = 1:numel(condition)
    % create a temporary variable to access part of cell data
    tempMat =  condition{i};
    conditionCurves{i} = plot(tempMat(:,3),tempMat(:,4),...
        'o-','LineWidth',3.0,'MarkerSize',3,'MarkerEdgeColor','black');
end

hold off
clabel(C,H,'FontSize',15,'Color','white')
xlabel('RPM'), ylabel('Current, A'), title('Shaft power contour, W')
% colorbar
legend([conditionCurves{:}],conditionLabels,'Location','Best')

% Annotations on contour
annot(V,3,1,scale,1)

for i = 1:numel(condition)
    tempMat =  condition{i};
    
    for j = 1:size(tempMat,1)
        text(tempMat(j,3),tempMat(j,4),...
            ['J = ',num2str(tempMat(j,1)), ' \rightarrow'], ...
            'HorizontalAlignment','right')
    end
    
end

% Scaling the RPM thick labels
rpmLabel = xticklabels;
for i = 1:numel(rpmLabel)
    rpmLabel{i} = str2double(rpmLabel{i}) * scale;
    rpmLabel{i} = num2str(rpmLabel{i});
end
xticklabels(rpmLabel)

%% Calculate TORQUE and motor EFFICIENCY from expected shaft power and RPM (propeller data)
[xt, yt] = meshgrid((0:100:11000)./scale, 0:1:70);  % x: RPM, y: Ncm
zt = griddata(r,t,h,xt,yt);

figure
hold on
surf(xt,yt,zt,'FaceColor','interp','LineStyle','none')
voltagePlot3(V,3,4,6,scale,1,1)

for i = 1:numel(condition)
    % create a temporary variable to access part of cell data
    tempMat =  condition{i};
    conditionCurves{i} = plot3(tempMat(:,3),tempMat(:,5),tempMat(:,6)+2,...
        'o-','LineWidth',3.0,'MarkerSize',3,'MarkerEdgeColor','black');
end

hold off, grid on, view(-20,30)
xlabel('RPM'), ylabel('Torque, Ncm'), zlabel('Motor Efficiency')
colorbar
legend([conditionCurves{:}],conditionLabels,'Location','Best')

% Annotations on surf
annot3(V,3,4,6,scale,1,1)

for i = 1:numel(condition)
    tempMat =  condition{i};
    
    for j = 1:size(tempMat,1)
        text(tempMat(j,3),tempMat(j,5),tempMat(j,6)+2,...
            ['J = ',num2str(tempMat(j,1)), ' \rightarrow'], ...
            'HorizontalAlignment','right')
    end
    
end

% Scaling the RPM thick labels
rpmLabel = xticklabels;
for i = 1:numel(rpmLabel)
    rpmLabel{i} = str2double(rpmLabel{i}) * scale;
    rpmLabel{i} = num2str(rpmLabel{i});
end
xticklabels(rpmLabel)

% Contour plot
figure
hold on
[C,H] = contourf(xt,yt,zt,[5:10:85,85:2:90,90:0.5:95]);
voltagePlot(V,3,4,scale,1)

for i = 1:numel(condition)
    % create a temporary variable to access part of cell data
    tempMat =  condition{i};
    conditionCurves{i} = plot(tempMat(:,3),tempMat(:,5),...
        'o-','LineWidth',3.0,'MarkerSize',3,'MarkerEdgeColor','black');
end

hold off
clabel(C,H,'FontSize',15,'Color','black')
xlabel('RPM'), ylabel('Torque, Ncm'), title('Motor Efficiency')
% colorbar
legend([conditionCurves{:}],conditionLabels,'Location','Best')

% Annotations on contour
annot(V,3,4,scale,1)

for i = 1:numel(condition)
    tempMat =  condition{i};
    
    for j = 1:size(tempMat,1)
        text(tempMat(j,3),tempMat(j,5),...
            ['J = ',num2str(tempMat(j,1)), ' \rightarrow'], ...
            'HorizontalAlignment','right')
    end
    
end

% Scaling the RPM thick labels
rpmLabel = xticklabels;
for i = 1:numel(rpmLabel)
    rpmLabel{i} = str2double(rpmLabel{i}) * scale;
    rpmLabel{i} = num2str(rpmLabel{i});
end
xticklabels(rpmLabel)