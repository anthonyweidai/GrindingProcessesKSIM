function [nodes_x,nodes_y,nodes_z,ConeAngle] = generateEllipsoid(rg,GeoParam)
%% Ellipsoid
a = rg;
b = a;

if GeoParam.Rarea<=1e-7
    Rarea = 0; % the ratio of area of cross section
else
    Rarea = GeoParam.Rarea;
end
mutemp = rg/Rarea;
c = max(mutemp,(mutemp-3*mutemp*GeoParam.Sigmah));
c = min(c,(mutemp+3*mutemp*GeoParam.Sigmah));
ConeAngle = 2*atan(rg/c);
%%
theta=2*pi*rand(1,700);
phi=24*pi/50*rand(1,700)+pi/50;
nodes_x=a*sin(phi).*cos(theta);
nodes_y=b*sin(phi).*sin(theta);
nodes_z=c*cos(phi);
end