function [ColumnsNum, RowsNum, maxRowsNum] = TGWColunmsNum(theta,NumGrits)
%% Get number of rows and columns of grains, you should change wheel and grains' parameters here
%%
theta = theta*pi/180;
WheelLength = 15*1000;
WheelWidth = 500;

mu = 10;
SepGap = (0.5+1)*mu*2;
RowGap = (3+1)*mu*2;

maxRowsNum = zeros(1,length(theta));
ColumnsNum = zeros(1,length(theta));
for i = 1:length(theta)
    if theta(i) == 0
        maxRowsNum(i) = floor(WheelLength/SepGap + 1);
        ColumnsNum(i) = floor(WheelWidth/RowGap + 1);
    elseif theta(i) == pi/2
        maxRowsNum(i) = floor(WheelLength/RowGap + 1);
        ColumnsNum(i) = floor(WheelWidth/SepGap + 1);
    elseif WheelWidth*tan(theta(i)) <= WheelLength
        maxRowsNum(i) = floor(WheelWidth/cos(theta(i))/SepGap+ 1);
        ColumnsNum(i) = floor((WheelLength+WheelWidth*tan(theta(i)))/RowGap + 1);
    else
        maxRowsNum(i) = floor(WheelLength/sin(theta(i))/SepGap+ 1);
        ColumnsNum(i) = floor((WheelLength+WheelWidth*tan(theta(i)))/RowGap + 1);
    end
end
RowsNum = NumGrits'./ColumnsNum;
% disp(num2str(ColunmsNum))
end