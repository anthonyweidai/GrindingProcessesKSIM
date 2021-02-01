function [vq, active_Rarea] = get_gritshape(R, geoparam, res)
%% generate geometries of grains
%% parameters notion, use structure for input variables
% R: default grit size
% shape: 1 - pyramid&frustum 2 - shpere&ellipsoid
% omega: number of edges for pyramid and trapezoid
% h2w_ratio: height/R
% Rarea: ratio of trapezoid area of top face to bottom face, 0(pyramid)and 0.05~1, and if 1, set fillet_mode = 0
% sigmah: the deviation of height of grain
% sigmasw: the deviation of skew of the vertex
% fillet_mode: 1-with fillet, 0 without fillet
% RA_mode: 1 - Rake angle is const, 0 - Rake angle is not const
% xi: intercept parameter of tetradecahedron
%%
P = get_shapeparam(R,geoparam);
%% rotate grit
rotate_angle = rand*3.1415926;
rotate_z_ori = [cos(rotate_angle) -sin(rotate_angle) 0; sin(rotate_angle) cos(rotate_angle) 0; 0 0 1];
for i = 1:size(P,1)
    P(i,:) = rotate_z_ori*P(i,:)';
end
%%
vq = [];
while isempty(vq)
    lowerb_p = min(P(:,3));
    [xq,yq] = meshgrid(-R:res:R, -R:res:R);
    vq = griddata(P(:,1),P(:,2),P(:,3),xq,yq);
    P(:,3) = P(:,3) + max(P(:,3)-min(P(:,3)))/2;
end
vq = vq - lowerb_p;
vq(isnan(vq)) = 0;
h_vq = max(vq,[],'all');
%% trimming
if geoparam.trim_h == 0
else
    trim_h = normrnd(geoparam.trim_h,0.1);
    vq = min(vq,trim_h);
end
newh_vq = max(vq,[],'all');
if geoparam.shape == 1
    active_Rarea = 1-(1-(h_vq-newh_vq)/h_vq)*(1-geoparam.Rarea);
else
    active_Rarea = 0;
end
end
%% list of functions
%   get_gritshape
%   - get_shapeparam
%   -- inpoint
%   -- interpoints
%   -- lineIntersection3D
%   -- interpolation3D
%   -- getvertex
%   === finintersection