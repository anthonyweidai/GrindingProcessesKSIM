function [grits,GritsProfile,GeoParam] = ...
    TGWGenerator(FileName, wheel_length, wheel_width, SepParam, GeoParam, res)
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
g_Gap = (SepGap+1)*mu*2;
r_Gap = (RowGap+1)*mu*2;
%% Generate lattice with angle
xlattice = [];
ylattice = [];
if theta == pi/2
    theta = 0;
end

ycoord = 0:g_Gap*sin(theta):wheel_length; % cut point in y-coordinate
xtemp = -wheel_length/tan(theta):r_Gap/sin(theta):wheel_width;
start_rnd = g_Gap*rand([1,length(xtemp)]);
xtemp = xtemp + start_rnd.*cos(theta);
for i = 1:length(ycoord)
    
    ytemp = repmat(ycoord(i),1,length(xtemp))+start_rnd.*sin(theta);
    xtemp = xtemp + g_Gap*cos(theta);
    
    x_dev = normrnd(0,KDev*mu,[1,length(xtemp)]);
    x_dev = max(x_dev,-3*KDev*mu);
    x_dev = min(x_dev,3*KDev*mu);
    y_dev = normrnd(0,SigRadius,[1,length(ytemp)]);
    y_dev = max(y_dev,-3*KDev*mu);
    y_dev = min(y_dev,3*KDev*mu);
    
    xlattice = [xlattice xtemp+x_dev];
    ylattice = [ylattice ytemp+y_dev];
end
index=find((ylattice<2*wheel_length).*(xlattice<wheel_width).*(ylattice>1e-7).*(xlattice>1e-7));
bubbles.pos(:,1) = xlattice(index);
bubbles.pos(:,2) = ylattice(index);

%% get the interested grains with proper position
grits.posx=round(bubbles.pos(:,1),3);
grits.posy=round(bubbles.pos(:,2),3);
bubbles.Tradius=normrnd(MuRadius,SigRadius,[length(grits.posx),1]);
grits.Tradius=round(bubbles.Tradius,3);
grits.Tradius=max(bubbles.Tradius,MuRadius-3*SigRadius);
grits.Tradius=min(bubbles.Tradius,MuRadius+3*SigRadius);

% figure;
% clf;
% circles(grits.posx,grits.posy,grits.Tradius);
% axis equal;drawnow;
% close gcf;
%%
T= struct2table(grits); % convert the struct array to a table
sortedT = sortrows(T, 'posy'); % sort the table by 'DOB'
sort(bubbles.pos,2);
writetable(sortedT,[FileName '.csv']);
[GritsProfile, GeoParam] = wheelGeneration(1,grits,FileName,GeoParam,res);
end