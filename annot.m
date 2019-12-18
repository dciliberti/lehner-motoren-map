function annot(voltData,x,y,xScale,yScale)
% Write voltage labels of the selected constant voltage lines of x,y data
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

v = 0;
for i = 1:12
    v = v + 5;
    text(voltData{i}(end,x)./xScale, ...
        voltData{i}(end,y)./yScale, ...
        [num2str(v), ' V \rightarrow'], 'HorizontalAlignment', 'right')
end

end