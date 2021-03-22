function [P, ConeAngle]=getShapeParam(rg, GeoParam, OutlineMode)
%% generate the Shape of grains
if GeoParam.Shape == 1
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateFrustumPyramid(rg, GeoParam, OutlineMode);
elseif GeoParam.Shape == 2
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateEllipsoid(rg, GeoParam);
elseif GeoParam.Shape == 3
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateTetradecahedron(rg, GeoParam);
end
%%
P = [nodes_x;nodes_y;nodes_z]';
end