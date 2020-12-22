function [grits,grit_profile_all]=TGW_generator(filename, sepparam, workpiece_length,...
    workpiece_width, geoparam)
%%
mu=10;sigma=geoparam.Rsigma;         %smaller grit configuration
% numBubbles=num_grits;        % number of bubbles; 1000 for 5um grits /170/330/620, 80d560,80d8gap=392
MuRadius=mu;            % average radius
SigRadius=sigma;        % 3 sigma /deviation
theta = ( sepparam.theta )/180*pi;    %degree in bracket
RowGap = sepparam.RowGap;
SepGap = sepparam.SepGap;
k_dev = sepparam.k_dev;

%% gap with grains' sizes
g_Gap = (SepGap+1)*mu*2;
r_Gap = (RowGap+1)*mu*2;
GrdToolwidth=workpiece_width;
GrdToollength=2*workpiece_length;
%% generate lattice with angle
xlattice = [];
ylattice = [];
if theta == pi/2
    theta = 0;
end

ycoord = 0:g_Gap*sin(theta):GrdToollength; % cut point in y-coordinate
xtemp = -GrdToollength/tan(theta):r_Gap/sin(theta):GrdToolwidth;
start_rnd = g_Gap*rand([1,length(xtemp)]);
xtemp = xtemp + start_rnd.*cos(theta);
for i = 1:length(ycoord)
    
    ytemp = repmat(ycoord(i),1,length(xtemp))+start_rnd.*sin(theta);
    xtemp = xtemp + g_Gap*cos(theta);
    
    x_dev = normrnd(0,k_dev*mu,[1,length(xtemp)]);
    x_dev = max(x_dev,-3*k_dev*mu);
    x_dev = min(x_dev,3*k_dev*mu);
    y_dev = normrnd(0,SigRadius,[1,length(ytemp)]);
    y_dev = max(y_dev,-3*k_dev*mu);
    y_dev = min(y_dev,3*k_dev*mu);
    
    xlattice = [xlattice xtemp+x_dev];
    ylattice = [ylattice ytemp+y_dev];
end
index=find((ylattice<2*GrdToollength).*(xlattice<GrdToolwidth).*(ylattice>1e-7).*(xlattice>1e-7));
bubbles.pos(:,1) = xlattice(index);
bubbles.pos(:,2) = ylattice(index);

%% get the interested grains with proper position
grits.posx=round(bubbles.pos(:,1),3);
grits.posy=round(bubbles.pos(:,2),3);
bubbles.Tradius=normrnd(MuRadius,SigRadius,[length(grits.posx),1]);
grits.Tradius=round(bubbles.Tradius,3);
grits.Tradius=max(bubbles.Tradius,MuRadius-3*SigRadius);
grits.Tradius=max(bubbles.Tradius,MuRadius+3*SigRadius);

%figure('visible','off');%;
clf;
circles(grits.posx,grits.posy,grits.Tradius);
axis equal;drawnow;
close gcf;
%%
T= struct2table(grits); % convert the struct array to a table
sortedT = sortrows(T, 'posy'); % sort the table by 'DOB'
sort(bubbles.pos,2);
writetable(sortedT,[filename '.csv']);
[grit_profile_all]=whl_generation(1,grits,[filename],geoparam);
end