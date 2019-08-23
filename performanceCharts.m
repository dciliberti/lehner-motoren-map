% Calculate the Lehner 2280-40 electric motor map from performance data
% issued by the manufacturer. Plot propeller operating points on the map.
% Version 4. Same as Version 3, but add more charts.
close all; clearvars; clc

%% User-provided data
% Operative points: J, Shaft Power (W), RPM
MXCL = [1.46    403   9801
        1.95    174   7351];

MXCR = [1.84	300   7807
        2.30	159   6246
        2.76	96    5205
        2.99	77    4804
        3.22	63    4461];

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
MXCL(:,4) = griddata(s,r,c,MXCL(:,2),MXCL(:,3));
MXCR(:,4) = griddata(s,r,c,MXCR(:,2),MXCR(:,3));

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
plot3(limRPM,limCur,limPow,'k-','LineWidth',2)
climb = plot3(MXCL(:,3),MXCL(:,4),MXCL(:,2)+20,'or-','LineWidth',1.5);
cruise = plot3(MXCR(:,3),MXCR(:,4),MXCR(:,2)+20,'oy-','LineWidth',1.5);
hold off, grid on, view(-20,30) 
xlabel('RPM'), ylabel('Current, A'), zlabel('Output power, W')
legend([climb,cruise], 'MXCL', 'MXCR','Location','Best','Color','cyan')

% Annotations on surf
text(V1(end,3),V1(end,1),V1(end,5),'5 V \rightarrow', 'HorizontalAlignment', 'right')
text(V2(end,3),V2(end,1),V2(end,5),'10 V \rightarrow', 'HorizontalAlignment', 'right')
text(V3(end,3),V3(end,1),V3(end,5),'15 V \rightarrow', 'HorizontalAlignment', 'right')
text(V4(end,3),V4(end,1),V4(end,5),'20 V \rightarrow', 'HorizontalAlignment', 'right')
text(V5(end,3),V5(end,1),V5(end,5),'25 V \rightarrow', 'HorizontalAlignment', 'right')
text(V6(end,3),V6(end,1),V6(end,5),'30 V \rightarrow', 'HorizontalAlignment', 'right')
text(V7(end,3),V7(end,1),V7(end,5),'35 V \rightarrow', 'HorizontalAlignment', 'right')
text(V8(end,3),V8(end,1),V8(end,5),'40 V \rightarrow', 'HorizontalAlignment', 'right')
text(V9(end,3),V9(end,1),V9(end,5),'45 V \rightarrow', 'HorizontalAlignment', 'right')
text(V10(end,3),V10(end,1),V10(end,5),'50 V \rightarrow', 'HorizontalAlignment', 'right')
text(V11(end,3),V11(end,1),V11(end,5),'55 V \rightarrow', 'HorizontalAlignment', 'right')
text(V12(end,3),V12(end,1),V12(end,5),'60 V \rightarrow', 'HorizontalAlignment', 'right')

for i = 1:size(MXCL,1)
    text(MXCL(i,3),MXCL(i,4),MXCL(i,2)+20,...
        ['J = ',num2str(MXCL(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end

for i = 1:size(MXCR,1)
    text(MXCR(i,3),MXCR(i,4),MXCR(i,2)+20,...
        ['J = ',num2str(MXCR(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
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
plot(limRPM,limCur,'k-','LineWidth',2)
climb = plot(MXCL(:,3),MXCL(:,4),'or-','LineWidth',1.5);
cruise = plot(MXCR(:,3),MXCR(:,4),'oy-','LineWidth',1.5);
hold off
clabel(C,H,'FontSize',15,'Color','white')
xlabel('RPM'), ylabel('Current, A'), title('Output power contour, W')
legend([climb,cruise], 'MXCL', 'MXCR','Location','Best','Color','cyan')

% Annotations on contour
text(V1(end,3),V1(end,1),'5 V \rightarrow', 'HorizontalAlignment', 'right')
text(V2(end,3),V2(end,1),'10 V \rightarrow', 'HorizontalAlignment', 'right')
text(V3(end,3),V3(end,1),'15 V \rightarrow', 'HorizontalAlignment', 'right')
text(V4(end,3),V4(end,1),'20 V \rightarrow', 'HorizontalAlignment', 'right')
text(V5(end,3),V5(end,1),'25 V \rightarrow', 'HorizontalAlignment', 'right')
text(V6(end,3),V6(end,1),'30 V \rightarrow', 'HorizontalAlignment', 'right')
text(V7(end,3),V7(end,1),'35 V \rightarrow', 'HorizontalAlignment', 'right')
text(V8(end,3),V8(end,1),'40 V \rightarrow', 'HorizontalAlignment', 'right')
text(V9(end,3),V9(end,1),'45 V \rightarrow', 'HorizontalAlignment', 'right')
text(V10(end,3),V10(end,1),'50 V \rightarrow', 'HorizontalAlignment', 'right')
text(V11(end,3),V11(end,1),'55 V \rightarrow', 'HorizontalAlignment', 'right')
text(V12(end,3),V12(end,1),'60 V \rightarrow', 'HorizontalAlignment', 'right')

for i = 1:size(MXCL,1)
    text(MXCL(i,3),MXCL(i,4),...
        ['J = ',num2str(MXCL(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end

for i = 1:size(MXCR,1)
    text(MXCR(i,3),MXCR(i,4),...
        ['J = ',num2str(MXCR(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end

% Scaling the RPM thick labels
rpmLabel = xticklabels;
for i = 1:numel(rpmLabel)
    rpmLabel{i} = str2double(rpmLabel{i}) * scale;
    rpmLabel{i} = num2str(rpmLabel{i});
end
xticklabels(rpmLabel)

%% Calculate TORQUE and motor EFFICIENCY from expected shaft power and RPM (propeller data)
MXCL(:,5) = griddata(s,r,t,MXCL(:,2),MXCL(:,3));
MXCR(:,5) = griddata(s,r,t,MXCR(:,2),MXCR(:,3));
MXCL(:,6) = griddata(s,r,h,MXCL(:,2),MXCL(:,3));
MXCR(:,6) = griddata(s,r,h,MXCR(:,2),MXCR(:,3));
[xt, yt] = meshgrid(0:100:11000, 0:1:60);  % x: RPM, y: Ncm
zt = griddata(r,t,h,xt,yt,'natural');

% Plot section
figure
hold on
surf(xt,yt,zt,'FaceColor','interp','LineStyle','none')
plot3(V1(:,3),V1(:,4),V1(:,6),'k--')
plot3(V2(:,3),V2(:,4),V2(:,6),'k--')
plot3(V3(:,3),V3(:,4),V3(:,6),'k--')
plot3(V4(:,3),V4(:,4),V4(:,6),'k--')
plot3(V5(:,3),V5(:,4),V5(:,6),'k--')
plot3(V6(:,3),V6(:,4),V6(:,6),'k--')
plot3(V7(:,3),V7(:,4),V7(:,6),'k--')   
plot3(V8(:,3),V8(:,4),V8(:,6),'k--')
plot3(V9(:,3),V9(:,4),V9(:,6),'k--')
plot3(V10(:,3),V10(:,4),V10(:,6),'k--')
plot3(V11(:,3),V11(:,4),V11(:,6),'k--')
plot3(V12(:,3),V12(:,4),V12(:,6),'k--')
plot3(limRPM,limMom,limEta,'k-','LineWidth',2)
climb = plot3(MXCL(:,3),MXCL(:,5),MXCL(:,6)+2,'or-','LineWidth',1.5);
cruise = plot3(MXCR(:,3),MXCR(:,5),MXCR(:,6)+2,'ob-','LineWidth',1.5);
hold off, grid on, view(-20,30) 
xlabel('RPM'), ylabel('Torque, Ncm'), zlabel('Efficiency')
legend([climb,cruise], 'MXCL', 'MXCR','Location','Best','Color','cyan')

% Annotations on surf
% text(V1(end,3),V1(end,1),V1(end,5),'5 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V2(end,3),V2(end,1),V2(end,5),'10 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V3(end,3),V3(end,1),V3(end,5),'15 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V4(end,3),V4(end,1),V4(end,5),'20 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V5(end,3),V5(end,1),V5(end,5),'25 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V6(end,3),V6(end,1),V6(end,5),'30 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V7(end,3),V7(end,1),V7(end,5),'35 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V8(end,3),V8(end,1),V8(end,5),'40 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V9(end,3),V9(end,1),V9(end,5),'45 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V10(end,3),V10(end,1),V10(end,5),'50 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V11(end,3),V11(end,1),V11(end,5),'55 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V12(end,3),V12(end,1),V12(end,5),'60 V \rightarrow', 'HorizontalAlignment', 'right')

% for i = 1:size(MXCL,1)
%     text(MXCL(i,3),MXCL(i,4),MXCL(i,2)+20,...
%         ['J = ',num2str(MXCL(i,1)), ' \rightarrow'], ...
%         'HorizontalAlignment','right')
% end
% 
% for i = 1:size(MXCR,1)
%     text(MXCR(i,3),MXCR(i,4),MXCR(i,2)+20,...
%         ['J = ',num2str(MXCR(i,1)), ' \rightarrow'], ...
%         'HorizontalAlignment','right')
% end

% Contour plot
figure
hold on
[C,H] = contourf(xt,yt,zt,0:10:100);
% plot(V1(:,3),V1(:,1),'k--')
% plot(V2(:,3),V2(:,1),'k--')
% plot(V3(:,3),V3(:,1),'k--')
% plot(V4(:,3),V4(:,1),'k--')
% plot(V5(:,3),V5(:,1),'k--')
% plot(V6(:,3),V6(:,1),'k--')
% plot(V7(:,3),V7(:,1),'k--')
% plot(V8(:,3),V8(:,1),'k--')
% plot(V9(:,3),V9(:,1),'k--')
% plot(V10(:,3),V10(:,1),'k--')
% plot(V11(:,3),V11(:,1),'k--')
% plot(V12(:,3),V12(:,1),'k--')
% plot(limRPM,limCur,'k-','LineWidth',2)
% climb = plot(MXCL(:,3),MXCL(:,4),'or-','LineWidth',1.5);
% cruise = plot(MXCR(:,3),MXCR(:,4),'oy-','LineWidth',1.5);
hold off
clabel(C,H,'FontSize',15,'Color','white')
xlabel('RPM'), ylabel('Torque, Ncm'), title('Efficiency')
legend([climb,cruise], 'MXCL', 'MXCR','Location','Best','Color','cyan')

% Annotations on contour
% text(V1(end,3),V1(end,1),'5 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V2(end,3),V2(end,1),'10 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V3(end,3),V3(end,1),'15 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V4(end,3),V4(end,1),'20 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V5(end,3),V5(end,1),'25 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V6(end,3),V6(end,1),'30 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V7(end,3),V7(end,1),'35 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V8(end,3),V8(end,1),'40 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V9(end,3),V9(end,1),'45 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V10(end,3),V10(end,1),'50 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V11(end,3),V11(end,1),'55 V \rightarrow', 'HorizontalAlignment', 'right')
% text(V12(end,3),V12(end,1),'60 V \rightarrow', 'HorizontalAlignment', 'right')

% for i = 1:size(MXCL,1)
%     text(MXCL(i,3),MXCL(i,4),...
%         ['J = ',num2str(MXCL(i,1)), ' \rightarrow'], ...
%         'HorizontalAlignment','right')
% end
% 
% for i = 1:size(MXCR,1)
%     text(MXCR(i,3),MXCR(i,4),...
%         ['J = ',num2str(MXCR(i,1)), ' \rightarrow'], ...
%         'HorizontalAlignment','right')
% end