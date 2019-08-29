% Calculate the Lehner 2280-40 electric motor map from performance data
% issued by the manufacturer. Plot propeller operating points on the map.
% Version 5. Define and compare as many propeller operating conditions as
% desired.
close all; clearvars; clc

%% User-provided data
conditionLabels = {'Desired values','XROTOR','CFD'};

% Operative points: J, Shaft Power (W), RPM
condition{1} = [1.46    403   9801
                1.95    174   7351];

condition{2} = [1.38	1329	10411
                1.44	1116	9958
                1.51	941     9543
                1.57	798     9162
                1.63	679     8809
                1.70	580     8483
                1.76	498     8180
                1.82	428     7898
                1.88	368     7635
                1.95	318     7388
                2.01	274     7157];

condition{3} = [1.4     1013	10274
                1.6     593     8990
                1.8     367     7991
                2       236     7192];

%% Lehner performance data
V1 = csvread('data\V5.csv');
V2 = csvread('data\V10.csv');
V3 = csvread('data\V15.csv');
V4 = csvread('data\V20.csv');
V5 = csvread('data\V25.csv');
V6 = csvread('data\V30.csv');
V7 = csvread('data\V35.csv');
V8 = csvread('data\V40.csv');
V9 = csvread('data\V45.csv');
V10 = csvread('data\V50.csv');
V11 = csvread('data\V55.csv');
V12 = csvread('data\V60.csv');

scale = 1000; % Scale factor over RPM for better interpolation
for i = 1:numel(condition)
    % create a temporary variable to manipulate part of cell data
    tempMat =  condition{i};
    tempMat(:,3) = tempMat(:,3) ./ scale;
    condition{i} = tempMat;
end

% Current	Input power     RPM     Momentum	Output power	Efficiency
% A         W               /min	Ncm         W	            %
c = [V1(:,1); V2(:,1); V3(:,1); V4(:,1); V5(:,1); V6(:,1); V7(:,1); ...
    V8(:,1); V9(:,1); V10(:,1); V11(:,1); V12(:,1)]; % Current
e = [V1(:,2); V2(:,2); V3(:,2); V4(:,2); V5(:,2); V6(:,2); V7(:,2); ...
    V8(:,2); V9(:,2); V10(:,2); V11(:,2); V12(:,2)]; % Input (electric) power
r = [V1(:,3); V2(:,3); V3(:,3); V4(:,3); V5(:,3); V6(:,3); V7(:,3); ...
    V8(:,3); V9(:,3); V10(:,3); V11(:,3); V12(:,3)] ./ scale; % RPM (scaled)
t = [V1(:,4); V2(:,4); V3(:,4); V4(:,4); V5(:,4); V6(:,4); V7(:,4); ...
    V8(:,4); V9(:,4); V10(:,4); V11(:,4); V12(:,4)]; % Momentum (torque)
s = [V1(:,5); V2(:,5); V3(:,5); V4(:,5); V5(:,5); V6(:,5); V7(:,5); ...
    V8(:,5); V9(:,5); V10(:,5); V11(:,5); V12(:,5)]; % Output (shaft) power
h = [V1(:,6); V2(:,6); V3(:,6); V4(:,6); V5(:,6); V6(:,6); V7(:,6); ...
    V8(:,6); V9(:,6); V10(:,6); V11(:,6); V12(:,6)]; % Efficiency

% Limit curves from data
limCur = [V1(end,1); V2(end,1); V3(end,1); V4(end,1); V5(end,1); V6(end,1); V7(end,1); ...
    V8(end,1); V9(end,1); V10(end,1); V11(end,1); V12(end,1)];
limInp = [V1(end,2); V2(end,2); V3(end,2); V4(end,2); V5(end,2); V6(end,2); V7(end,2); ...
    V8(end,2); V9(end,2); V10(end,2); V11(end,2); V12(end,2)];
limRPM = [V1(end,3); V2(end,3); V3(end,3); V4(end,3); V5(end,3); V6(end,3); V7(end,3); ...
    V8(end,3); V9(end,3); V10(end,3); V11(end,3); V12(end,3)] ./ scale;
limMom = [V1(end,4); V2(end,4); V3(end,4); V4(end,4); V5(end,4); V6(end,4); V7(end,4); ...
    V8(end,4); V9(end,4); V10(end,4); V11(end,4); V12(end,4)];
limPow = [V1(end,5); V2(end,5); V3(end,5); V4(end,5); V5(end,5); V6(end,5); V7(end,5); ...
    V8(end,5); V9(end,5); V10(end,5); V11(end,5); V12(end,5)];
limEta = [V1(end,6); V2(end,6); V3(end,6); V4(end,6); V5(end,6); V6(end,6); V7(end,6); ...
    V8(end,6); V9(end,6); V10(end,6); V11(end,6); V12(end,6)];

%% Calculate CURRENT from expected shaft power and RPM (propeller data)
[xa, ya] = meshgrid((0:100:11000)./scale, 0:0.1:15);  % x: RPM, y: Ampere
za = griddata(r,c,s,xa,ya);

% Interpolate data to caclculate current drawn at propeller operating points
for i = 1:numel(condition)
    % create a temporary variable to access cell data
    tempMat =  condition{i};
    tempMat(:,4) = griddata(s,r,c,tempMat(:,2),tempMat(:,3));
    condition{i} = tempMat;
end

% Plot section
figure
hold on
surf(xa,ya,za,'FaceColor','interp','LineStyle','none')
plot3(V1(:,3)./scale,V1(:,1),V1(:,5),'k--')
plot3(V2(:,3)./scale,V2(:,1),V2(:,5),'k--')
plot3(V3(:,3)./scale,V3(:,1),V3(:,5),'k--')
plot3(V4(:,3)./scale,V4(:,1),V4(:,5),'k--')
plot3(V5(:,3)./scale,V5(:,1),V5(:,5),'k--')
plot3(V6(:,3)./scale,V6(:,1),V6(:,5),'k--')
plot3(V7(:,3)./scale,V7(:,1),V7(:,5),'k--')
plot3(V8(:,3)./scale,V8(:,1),V8(:,5),'k--')
plot3(V9(:,3)./scale,V9(:,1),V9(:,5),'k--')
plot3(V10(:,3)./scale,V10(:,1),V10(:,5),'k--')
plot3(V11(:,3)./scale,V11(:,1),V11(:,5),'k--')
plot3(V12(:,3)./scale,V12(:,1),V12(:,5),'k--')
% plot3(limRPM,limCur,limPow,'k-','LineWidth',2)

for i = 1:numel(condition)
    % create a temporary variable to access part of cell data
    tempMat =  condition{i};
    conditionCurves{i} = plot3(tempMat(:,3),tempMat(:,4),tempMat(:,2)+20,...
        '-o','LineWidth',3.0,'MarkerSize',3,'MarkerEdgeColor','black'); %#ok<SAGROW>
end

hold off, grid on, view(-20,30)
xlabel('RPM'), ylabel('Current, A'), zlabel('Shaft power, W')
colorbar
legend([conditionCurves{:}],conditionLabels,'Location','Best')

% Annotations on surf
text(V1(end,3)./scale,V1(end,1),V1(end,5),'5 V \rightarrow', 'HorizontalAlignment', 'right')
text(V2(end,3)./scale,V2(end,1),V2(end,5),'10 V \rightarrow', 'HorizontalAlignment', 'right')
text(V3(end,3)./scale,V3(end,1),V3(end,5),'15 V \rightarrow', 'HorizontalAlignment', 'right')
text(V4(end,3)./scale,V4(end,1),V4(end,5),'20 V \rightarrow', 'HorizontalAlignment', 'right')
text(V5(end,3)./scale,V5(end,1),V5(end,5),'25 V \rightarrow', 'HorizontalAlignment', 'right')
text(V6(end,3)./scale,V6(end,1),V6(end,5),'30 V \rightarrow', 'HorizontalAlignment', 'right')
text(V7(end,3)./scale,V7(end,1),V7(end,5),'35 V \rightarrow', 'HorizontalAlignment', 'right')
text(V8(end,3)./scale,V8(end,1),V8(end,5),'40 V \rightarrow', 'HorizontalAlignment', 'right')
text(V9(end,3)./scale,V9(end,1),V9(end,5),'45 V \rightarrow', 'HorizontalAlignment', 'right')
text(V10(end,3)./scale,V10(end,1),V10(end,5),'50 V \rightarrow', 'HorizontalAlignment', 'right')
text(V11(end,3)./scale,V11(end,1),V11(end,5),'55 V \rightarrow', 'HorizontalAlignment', 'right')
text(V12(end,3)./scale,V12(end,1),V12(end,5),'60 V \rightarrow', 'HorizontalAlignment', 'right')

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
plot(V1(:,3)./scale,V1(:,1),'k--')
plot(V2(:,3)./scale,V2(:,1),'k--')
plot(V3(:,3)./scale,V3(:,1),'k--')
plot(V4(:,3)./scale,V4(:,1),'k--')
plot(V5(:,3)./scale,V5(:,1),'k--')
plot(V6(:,3)./scale,V6(:,1),'k--')
plot(V7(:,3)./scale,V7(:,1),'k--')
plot(V8(:,3)./scale,V8(:,1),'k--')
plot(V9(:,3)./scale,V9(:,1),'k--')
plot(V10(:,3)./scale,V10(:,1),'k--')
plot(V11(:,3)./scale,V11(:,1),'k--')
plot(V12(:,3)./scale,V12(:,1),'k--')
% plot(limRPM,limCur,'k-','LineWidth',2)

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
text(V1(end,3)./scale,V1(end,1),'5 V \rightarrow', 'HorizontalAlignment', 'right')
text(V2(end,3)./scale,V2(end,1),'10 V \rightarrow', 'HorizontalAlignment', 'right')
text(V3(end,3)./scale,V3(end,1),'15 V \rightarrow', 'HorizontalAlignment', 'right')
text(V4(end,3)./scale,V4(end,1),'20 V \rightarrow', 'HorizontalAlignment', 'right')
text(V5(end,3)./scale,V5(end,1),'25 V \rightarrow', 'HorizontalAlignment', 'right')
text(V6(end,3)./scale,V6(end,1),'30 V \rightarrow', 'HorizontalAlignment', 'right')
text(V7(end,3)./scale,V7(end,1),'35 V \rightarrow', 'HorizontalAlignment', 'right')
text(V8(end,3)./scale,V8(end,1),'40 V \rightarrow', 'HorizontalAlignment', 'right')
text(V9(end,3)./scale,V9(end,1),'45 V \rightarrow', 'HorizontalAlignment', 'right')
text(V10(end,3)./scale,V10(end,1),'50 V \rightarrow', 'HorizontalAlignment', 'right')
text(V11(end,3)./scale,V11(end,1),'55 V \rightarrow', 'HorizontalAlignment', 'right')
text(V12(end,3)./scale,V12(end,1),'60 V \rightarrow', 'HorizontalAlignment', 'right')

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

% Interpolate data to caclculate motor torque and efficiency at propeller operating points
for i = 1:numel(condition)
    % create a temporary variable to access cell data
    tempMat =  condition{i};
    tempMat(:,5) = griddata(s,r,t,tempMat(:,2),tempMat(:,3));
    tempMat(:,6) = griddata(s,r,h,tempMat(:,2),tempMat(:,3));
    condition{i} = tempMat;
end

% Plot section
figure
hold on
surf(xt,yt,zt,'FaceColor','interp','LineStyle','none')
plot3(V1(:,3)./scale,V1(:,4),V1(:,6),'k--')
plot3(V2(:,3)./scale,V2(:,4),V2(:,6),'k--')
plot3(V3(:,3)./scale,V3(:,4),V3(:,6),'k--')
plot3(V4(:,3)./scale,V4(:,4),V4(:,6),'k--')
plot3(V5(:,3)./scale,V5(:,4),V5(:,6),'k--')
plot3(V6(:,3)./scale,V6(:,4),V6(:,6),'k--')
plot3(V7(:,3)./scale,V7(:,4),V7(:,6),'k--')
plot3(V8(:,3)./scale,V8(:,4),V8(:,6),'k--')
plot3(V9(:,3)./scale,V9(:,4),V9(:,6),'k--')
plot3(V10(:,3)./scale,V10(:,4),V10(:,6),'k--')
plot3(V11(:,3)./scale,V11(:,4),V11(:,6),'k--')
plot3(V12(:,3)./scale,V12(:,4),V12(:,6),'k--')
% plot3(limRPM,limMom,limEta,'k-','LineWidth',2)

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
text(V1(end,3)./scale,V1(end,4),V1(end,6),'5 V \rightarrow', 'HorizontalAlignment', 'right')
text(V2(end,3)./scale,V2(end,4),V2(end,6),'10 V \rightarrow', 'HorizontalAlignment', 'right')
text(V3(end,3)./scale,V3(end,4),V3(end,6),'15 V \rightarrow', 'HorizontalAlignment', 'right')
text(V4(end,3)./scale,V4(end,4),V4(end,6),'20 V \rightarrow', 'HorizontalAlignment', 'right')
text(V5(end,3)./scale,V5(end,4),V5(end,6),'25 V \rightarrow', 'HorizontalAlignment', 'right')
text(V6(end,3)./scale,V6(end,4),V6(end,6),'30 V \rightarrow', 'HorizontalAlignment', 'right')
text(V7(end,3)./scale,V7(end,4),V7(end,6),'35 V \rightarrow', 'HorizontalAlignment', 'right')
text(V8(end,3)./scale,V8(end,4),V8(end,6),'40 V \rightarrow', 'HorizontalAlignment', 'right')
text(V9(end,3)./scale,V9(end,4),V9(end,6),'45 V \rightarrow', 'HorizontalAlignment', 'right')
text(V10(end,3)./scale,V10(end,4),V10(end,6),'50 V \rightarrow', 'HorizontalAlignment', 'right')
text(V11(end,3)./scale,V11(end,4),V11(end,6),'55 V \rightarrow', 'HorizontalAlignment', 'right')
text(V12(end,3)./scale,V12(end,4),V12(end,6),'60 V \rightarrow', 'HorizontalAlignment', 'right')

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
plot(V1(:,3)./scale,V1(:,4),'k--')
plot(V2(:,3)./scale,V2(:,4),'k--')
plot(V3(:,3)./scale,V3(:,4),'k--')
plot(V4(:,3)./scale,V4(:,4),'k--')
plot(V5(:,3)./scale,V5(:,4),'k--')
plot(V6(:,3)./scale,V6(:,4),'k--')
plot(V7(:,3)./scale,V7(:,4),'k--')
plot(V8(:,3)./scale,V8(:,4),'k--')
plot(V9(:,3)./scale,V9(:,4),'k--')
plot(V10(:,3)./scale,V10(:,4),'k--')
plot(V11(:,3)./scale,V11(:,4),'k--')
plot(V12(:,3)./scale,V12(:,4),'k--')
% plot(limRPM,limMom,'k-','LineWidth',2)

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
text(V1(end,3)./scale,V1(end,4),'5 V \rightarrow', 'HorizontalAlignment', 'right')
text(V2(end,3)./scale,V2(end,4),'10 V \rightarrow', 'HorizontalAlignment', 'right')
text(V3(end,3)./scale,V3(end,4),'15 V \rightarrow', 'HorizontalAlignment', 'right')
text(V4(end,3)./scale,V4(end,4),'20 V \rightarrow', 'HorizontalAlignment', 'right')
text(V5(end,3)./scale,V5(end,4),'25 V \rightarrow', 'HorizontalAlignment', 'right')
text(V6(end,3)./scale,V6(end,4),'30 V \rightarrow', 'HorizontalAlignment', 'right')
text(V7(end,3)./scale,V7(end,4),'35 V \rightarrow', 'HorizontalAlignment', 'right')
text(V8(end,3)./scale,V8(end,4),'40 V \rightarrow', 'HorizontalAlignment', 'right')
text(V9(end,3)./scale,V9(end,4),'45 V \rightarrow', 'HorizontalAlignment', 'right')
text(V10(end,3)./scale,V10(end,4),'50 V \rightarrow', 'HorizontalAlignment', 'right')
text(V11(end,3)./scale,V11(end,4),'55 V \rightarrow', 'HorizontalAlignment', 'right')
text(V12(end,3)./scale,V12(end,4),'60 V \rightarrow', 'HorizontalAlignment', 'right')

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