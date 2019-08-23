% Calculate the Lehner 2280-40 electric motor map from performance data
% issued by the manufacturer. Plot propeller operating points on the map.
% Version 1. Operating points manually chosen as close as possible to the
% available manufacturer data.
close all; clearvars; clc

% Avio engine scaled data
% J	Voltage	Current	Input power	rpm     Momentum	Output power	Efficiency
% - V       A       W           /min	Ncm         W               %

MXCL = [1.46	48.9	11.4	557.5	8623	56.8	513     92
        1.95	36.3	6.6     239.6	6470	32.4	219.4	91.6];
MXCR = [1.84	39.1	9.8     383.2	6869	48.8	351.2	91.7
        2.30	31.15	7.2     224.3	5495	35.6	205.1	91.4
        2.76	25.8	5.2     134.2	4579	25.5	122.2	91.1
        2.99	23.8	4.6     109.5	4232	22.5	99.5	90.9
        3.22	22.1	4.4     97.2	3925	21.5	88.3	90.8];

% Lehner performance charts
% Current	Input power     RPM     Momentum	Output power	Efficiency
% A         W               /min	Ncm         W	            %
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

x = [V1(:,1); V2(:,1); V3(:,1); V4(:,1); V5(:,1); V6(:,1); V7(:,1); ...
    V8(:,1); V9(:,1); V10(:,1); V11(:,1); V12(:,1)];
y = [V1(:,3); V2(:,3); V3(:,3); V4(:,3); V5(:,3); V6(:,3); V7(:,3); ...
    V8(:,3); V9(:,3); V10(:,3); V11(:,3); V12(:,3)];
z = [V1(:,5); V2(:,5); V3(:,5); V4(:,5); V5(:,5); V6(:,5); V7(:,5); ...
    V8(:,5); V9(:,5); V10(:,5); V11(:,5); V12(:,5)];

% Limit curves from data
limCur = [V1(end,1); V2(end,1); V3(end,1); V4(end,1); V5(end,1); V6(end,1); V7(end,1); ...
    V8(end,1); V9(end,1); V10(end,1); V11(end,1); V12(end,1)];
limRPM = [V1(end,3); V2(end,3); V3(end,3); V4(end,3); V5(end,3); V6(end,3); V7(end,3); ...
    V8(end,3); V9(end,3); V10(end,3); V11(end,3); V12(end,3)];
limPow = [V1(end,5); V2(end,5); V3(end,5); V4(end,5); V5(end,5); V6(end,5); V7(end,5); ...
    V8(end,5); V9(end,5); V10(end,5); V11(end,5); V12(end,5)];

[xq, yq] = meshgrid(0:0.1:15, 0:10:11000);
zq = griddata(x,y,z,xq,yq);

% Purge data outside limits TODO?

%% Plot section
figure(1)
hold on
surf(xq,yq,zq,'FaceColor','interp','LineStyle','none')
plot3(V1(:,1),V1(:,3),V1(:,5),'k--')
plot3(V2(:,1),V2(:,3),V2(:,5),'k--')
plot3(V3(:,1),V3(:,3),V3(:,5),'k--')
plot3(V4(:,1),V4(:,3),V4(:,5),'k--')
plot3(V5(:,1),V5(:,3),V5(:,5),'k--')
plot3(V6(:,1),V6(:,3),V6(:,5),'k--')
plot3(V7(:,1),V7(:,3),V7(:,5),'k--')
plot3(V8(:,1),V8(:,3),V8(:,5),'k--')
plot3(V9(:,1),V9(:,3),V9(:,5),'k--')
plot3(V10(:,1),V10(:,3),V10(:,5),'k--')
plot3(V11(:,1),V11(:,3),V11(:,5),'k--')
plot3(V12(:,1),V12(:,3),V12(:,5),'k--')
plot3(limCur,limRPM,limPow,'k-','LineWidth',2)
climb = plot3(MXCL(:,3),MXCL(:,5),MXCL(:,7)+20,'or-','LineWidth',1.5);
cruise = plot3(MXCR(:,3),MXCR(:,5),MXCR(:,7)+20,'oy-','LineWidth',1.5);
hold off, grid on, view(-50,30) 
xlabel('Current, A'), ylabel('RPM'), zlabel('Output power, W')
legend([climb,cruise], 'MXCL', 'MXCR','Location','Best','Color','cyan')

% Annotations on surf
text(V1(end,1),V1(end,3),V1(end,5),'\leftarrow 5 V')
text(V2(end,1),V2(end,3),V2(end,5),'\leftarrow 10 V')
text(V3(end,1),V3(end,3),V3(end,5),'\leftarrow 15 V')
text(V4(end,1),V4(end,3),V4(end,5),'\leftarrow 20 V')
text(V5(end,1),V5(end,3),V5(end,5),'\leftarrow 25 V')
text(V6(end,1),V6(end,3),V6(end,5),'\leftarrow 30 V')
text(V7(end,1),V7(end,3),V7(end,5),'\leftarrow 35 V')
text(V8(end,1),V8(end,3),V8(end,5),'\leftarrow 40 V')
text(V9(end,1),V9(end,3),V9(end,5),'\leftarrow 45 V')
text(V10(end,1),V10(end,3),V10(end,5),'\leftarrow 50 V')
text(V11(end,1),V11(end,3),V11(end,5),'\leftarrow 55 V')
text(V12(end,1),V12(end,3),V12(end,5),'\leftarrow 60 V')

for i = 1:size(MXCL,1)
    text(MXCL(i,3),MXCL(i,5),MXCL(i,7)+20,...
        ['J = ',num2str(MXCL(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end

for i = 1:size(MXCR,1)
    text(MXCR(i,3),MXCR(i,5),MXCR(i,7)+20,...
        ['J = ',num2str(MXCR(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end

% Contour plot
figure(2)
hold on
[C,H] = contourf(xq,yq,zq,0:50:700);
plot(V1(:,1),V1(:,3),'k--')
plot(V2(:,1),V2(:,3),'k--')
plot(V3(:,1),V3(:,3),'k--')
plot(V4(:,1),V4(:,3),'k--')
plot(V5(:,1),V5(:,3),'k--')
plot(V6(:,1),V6(:,3),'k--')
plot(V7(:,1),V7(:,3),'k--')
plot(V8(:,1),V8(:,3),'k--')
plot(V9(:,1),V9(:,3),'k--')
plot(V10(:,1),V10(:,3),'k--')
plot(V11(:,1),V11(:,3),'k--')
plot(V12(:,1),V12(:,3),'k--')
plot(limCur,limRPM,'k-','LineWidth',2)
climb = plot(MXCL(:,3),MXCL(:,5),'or-','LineWidth',1.5);
cruise = plot(MXCR(:,3),MXCR(:,5),'oy-','LineWidth',1.5);
hold off
clabel(C,H,'FontSize',15,'Color','white')
xlabel('Current, A'), ylabel('RPM'), title('Output power contour, W')
legend([climb,cruise], 'MXCL', 'MXCR','Location','Best','Color','cyan')

% Annotations on contour
text(V1(end,1),V1(end,3),'\leftarrow 5 V')
text(V2(end,1),V2(end,3),'\leftarrow 10 V')
text(V3(end,1),V3(end,3),'\leftarrow 15 V')
text(V4(end,1),V4(end,3),'\leftarrow 20 V')
text(V5(end,1),V5(end,3),'\leftarrow 25 V')
text(V6(end,1),V6(end,3),'\leftarrow 30 V')
text(V7(end,1),V7(end,3),'\leftarrow 35 V')
text(V8(end,1),V8(end,3),'\leftarrow 40 V')
text(V9(end,1),V9(end,3),'\leftarrow 45 V')
text(V10(end,1),V10(end,3),'\leftarrow 50 V')
text(V11(end,1),V11(end,3),'\leftarrow 55 V')
text(V12(end,1),V12(end,3),'\leftarrow 60 V')

for i = 1:size(MXCL,1)
    text(MXCL(i,3),MXCL(i,5),...
        ['J = ',num2str(MXCL(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end

for i = 1:size(MXCR,1)
    text(MXCR(i,3),MXCR(i,5),...
        ['J = ',num2str(MXCR(i,1)), ' \rightarrow'], ...
        'HorizontalAlignment','right')
end