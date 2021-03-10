function [nodes_x,nodes_y,nodes_z,ConeAngle] = generateFrustumPyramid(rg,GeoParam,OutlineMode)
%% Generate pyramid and Frustum of grains
Omega = GeoParam.Omega;
Rarea = GeoParam.Rarea;
%%
mutemp = rg*GeoParam.RHeightSize;
hv = normrnd(mutemp,mutemp*GeoParam.Sigmah); % the height of top plane
hv = max(hv,(mutemp-3*mutemp*GeoParam.Sigmah));
hv = min(hv,(mutemp+3*mutemp*GeoParam.Sigmah));

theta_v = rand*3.1415926*2; % orientation of the vertex, theta_v = 0~2*pi
mutemp = 0.4;
Rv = normrnd(mutemp,mutemp*GeoParam.SigmaSkew); % ratio of the vertex's location, Rvertex = 0~0.8
Rv = max(Rv,0);
Rv = min(0.8,Rv);
%% polygon vertices on bottom plane
nodes_x = zeros(1,Omega);
nodes_y = zeros(1,Omega);
nodes_z = zeros(1,Omega);

for i = 0:Omega-1
    theta_culet = i*2*pi/Omega;
    nodes_x(i+1) = rg*cos(theta_culet);
    nodes_y(i+1) = rg*sin(theta_culet);
end
[xc, yc] = getVertex(nodes_x(1:Omega),nodes_y(1:Omega),theta_v,Rv);
%%
Vertex = [xc, yc, hv];
if Rarea<=1e-7
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generatePyramid(rg, Vertex, ...
        GeoParam, nodes_x, nodes_y, nodes_z, OutlineMode);
else
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateFrustum(rg, Vertex, ...
        GeoParam, nodes_x, nodes_y, nodes_z, OutlineMode);
end
end