function annot3(voltData,x,y,z,xScale,yScale,zScale)
% Write voltage labels of the selected constant voltage lines of x,y,z data
% Works correctly if HOLD ON command is issued before calling this function

% VOLTDATA is a cell array of voltage data
% X is the VOLTDATA index of the x-axis
% Y is the VOLTDATA index of the y-axis
% Z is the VOLTDATA index of the z-axis
% XSCALE is the scale factor of the X data (default = 1)
% YSCALE is the scale factor of the Y data (default = 1)
% ZSCALE is the scale factor of the Z data (default = 1)

if nargin == 4
   xScale = 1;
   yScale = 1;
   zScale = 1;
end

v = 0;
for i = 1:12
    v = v + 5;
    text(voltData{i}(end,x)./xScale, ...
        voltData{i}(end,y)./yScale, ...
        voltData{i}(end,z)./zScale, ...
        [num2str(v), ' V \rightarrow'], 'HorizontalAlignment', 'right')
end

end