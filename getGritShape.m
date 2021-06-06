function [vq, ActiveRarea, ConeAngle, Rarea] = getGritShape(rg, GeoParam, res)
%% generate geometries of grains
%% parameters notion, use structure for input variables
% R: default grit size
% Shape: 1 - pyramid&frustum 2 - shpere&ellipsoid
% Omega: number of edges for pyramid and trapezoid
% RHeightSize: height/R
% Rarea: ratio of trapezoid area of top face to bottom face, 0(pyramid)and 0.05~1, and if 1, set FilletMode = 0
% sigmah: the deviation of height of grain
% sigmasw: the deviation of skew of the vertex
% FilletMode: 1-with fillet, 0 without fillet
% RA_mode: 1 - Rake angle is const, 0 - Rake angle is not const
% xi: intercept parameter of tetradecahedron
%%
OutlineMode = 0;
[P, ConeAngle] = getShapeParam(rg, GeoParam, OutlineMode);
%% Get Rarea of tetradecahedron
if GeoParam.Shape == 3
    TopZIndex = find(P(:,3) == max(P(:,3)));
    DownZIndex = find(P(:,3) == min(P(:,3)));
    TopDist = 0;
    DownDist = 0;
    for k1 = 1:length(TopZIndex)
        TopDist = max(TopDist,norm(P(TopZIndex(k1),1:2)));
    end
    for k2 = 1:length(DownZIndex)
        DownDist = max(DownDist,norm(P(DownZIndex(k2),1:2)));
    end
    Rarea = (TopDist/DownDist)^2;
else
    Rarea = [];
end
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
    [xq,yq] = meshgrid(-rg:res:rg, -rg:res:rg);
    vq = griddata(P(:,1),P(:,2),P(:,3),xq,yq);
    P(:,3) = P(:,3) + max(P(:,3)-min(P(:,3)))/2;
end
vq = vq - lowerb_p;
vq(isnan(vq)) = 0;
h_vq = max(vq,[],'all');
%% trimming
if GeoParam.Trimmingh >= 1e-7
    MuTrim = rg;
    SigmaTrim = GeoParam.Trimmingh;
    Trimmingh = normrnd(MuTrim, SigmaTrim);
    Trimmingh = max(Trimmingh, MuTrim - 3*SigmaTrim);
    vq = min(vq, Trimmingh);
end
newh_vq = max(vq,[],'all');
if GeoParam.Shape == 1
    ActiveRarea = 1 - (1 - (h_vq-newh_vq) / h_vq) * (1-GeoParam.Rarea);
else
    ActiveRarea = 0;
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