function bubbles = Laser_Frame(Laser_theta, RowGap, SaveGap, GrdToollength, GrdToolwidth, bubbles)
%% Lasering to remove unwanted grains
% Laser_theta - the angle between saved line and bottom line
% RowGap - row gap between ajacent centers of lines
% SaveGap - save gap of each line
theta = Laser_theta/180*pi;
if RowGap <= SaveGap
   disp('Wrong gap, cannot lasering!') 
   return
end
%%
% get center lines lattice
temp1 = RowGap*cos(theta);
lengthen = GrdToolwidth*tan(theta);
num_polygon = floor((GrdToollength+lengthen)/(temp1)); % number polygon vertecies
Center_Lylattice = -lengthen:temp1:GrdToollength; % left |
Center_Rylattice = 0:temp1:GrdToollength + lengthen; % right |
% get saved area boundries lattice
temp2 = SaveGap*cos(theta)/2;
L_ylattice1 = Center_Lylattice - temp2;
L_ylattice2 = Center_Lylattice + temp2;
R_ylattice1 = Center_Rylattice - temp2;
R_ylattice2 = Center_Rylattice + temp2;
xlattice1 = 0;
xlattice2 = GrdToolwidth;
%% get laser in point
idx = [];
xq = bubbles.pos(:,1);
yq = bubbles.pos(:,2);
for i = 1:num_polygon
    xv = [xlattice1, xlattice2, xlattice2, xlattice1, xlattice1];  % Polygon X-Coordinates
    yv = [L_ylattice1(i), R_ylattice1(i), R_ylattice2(i), L_ylattice2(i), L_ylattice1(i)]; % Polygon Y-Coordinates
    [in,on] = inpolygon(xq,yq,xv,yv); % get in point index
    temp1 = in | on; % Combine ‘in’ And ‘on’
    temp2 = find(temp1(:));
    idx = [idx;temp2];
end
%% remove elements with outside points
fnames = fieldnames(bubbles);
temp1 = length(fnames);
for j = 1:temp1
    bubbles.(fnames{j}) = bubbles.(fnames{j})(idx,:);
end
end