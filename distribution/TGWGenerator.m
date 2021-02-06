function [grits,GritsProfile,GeoParam] = ...
    TGWGenerator(FileName, WheelLength, WheelWidth, SepParam, GeoParam, res)
%%
mu=10;         %smaller grit configuration
% numBubbles=num_grits;        % number of bubbles; 1000 for 5um grits /170/330/620, 80d560,80d8gap=392
MuRadius=mu;            % average radius
SigRadius=GeoParam.Sigmarg;        % 3 sigma /deviation
theta = ( SepParam.theta )/180*pi;    %degree in bracket
RowGap = SepParam.RowGap;
SepGap = SepParam.SepGap;
KDev = SepParam.KDev;
%% Gap between two adjacent centers of circles or rows
SepGap = (SepGap+1)*mu*2;
RowGap = (RowGap+1)*mu*2;
%% Generate lattice with angle
%%
if theta == pi/2
    theta = 0;
end
if theta == 0
    YRowStart = 0:RowGap:WheelLength;
    XColumnStart = 0:SepGap:WheelWidth;
else
    YRowStart = 0:SepGap*sin(theta):WheelLength; % cut point in y-coordinate
    XColumnStart = -WheelLength/tan(theta):RowGap/sin(theta):WheelWidth;
    StartRandom = SepGap*rand([1,length(XColumnStart)]);
    XColumnStart = XColumnStart + StartRandom.*cos(theta);
end
%%
xlattice = [];
ylattice = [];
for i = 1:length(YRowStart)
    if theta == 0
        ytemp = repmat(YRowStart(i),1,length(XColumnStart));
    else
        ytemp = repmat(YRowStart(i),1,length(XColumnStart)) + StartRandom.*sin(theta);
        XColumnStart = XColumnStart + SepGap*cos(theta);
    end
    x_dev = normrnd(0,KDev*mu,[1,length(XColumnStart)]);
    x_dev = max(x_dev,-3*KDev*mu);
    x_dev = min(x_dev,3*KDev*mu);
    y_dev = normrnd(0,SigRadius,[1,length(ytemp)]);
    y_dev = max(y_dev,-3*KDev*mu);
    y_dev = min(y_dev,3*KDev*mu);
    
    xlattice = [xlattice XColumnStart + x_dev];
    ylattice = [ylattice ytemp + y_dev];
end
%% get the interested grains with proper position
index=find((ylattice<2*WheelLength).*(xlattice<WheelWidth).*(ylattice>1e-7).*(xlattice>1e-7));
grits.posx=round(xlattice(index),3)';
grits.posy=round(ylattice(index),3)';
BubblesTradius = normrnd(MuRadius,SigRadius,[length(grits.posx),1]);
grits.Tradius = round(BubblesTradius,3);
grits.Tradius = max(BubblesTradius,MuRadius-3*SigRadius);
grits.Tradius = min(BubblesTradius,MuRadius+3*SigRadius);
%%
% figure;
% clf;
% circles(grits.posx,grits.posy,grits.Tradius);
% axis equal;drawnow;
% close gcf;
%%
T= struct2table(grits); % convert the struct array to a table
sortedT = sortrows(T, 'posy'); % sort the table by 'DOB'
writetable(sortedT,[FileName '.csv']);
[GritsProfile, GeoParam] = wheelGeneration(1,grits,FileName,GeoParam,res);
end