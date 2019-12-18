function voltagePlot(voltData,x,y,xScale,yScale)
% Plot 3D lines of the selected constant voltage lines of x,y,z data
% Works correctly if HOLD ON command is issued before calling this function

% VOLTDATA is a cell array of voltage data
% X is the VOLTDATA index of the x-axis
% Y is the VOLTDATA index of the y-axis
% XSCALE is the scale factor of the X data (default = 1)
% YSCALE is the scale factor of the Y data (default = 1)

if nargin == 3
   xScale = 1;
   yScale = 1;
end

for i = 1:12
    plot(voltData{i}(:,x)./xScale, ...
        voltData{i}(:,y)./yScale, 'k--')
end

end