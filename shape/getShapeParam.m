function [P, ConeAngle]=getShapeParam(rg, GeoParam, OutlineMode)
%% generate the Shape of grains
if GeoParam.Shape == 1
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateFrustumPyramid(rg,GeoParam,OutlineMode);
elseif GeoParam.Shape == 2
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateEllipsoid(rg,GeoParam);
elseif GeoParam.Shape == 3
    [nodes_x,nodes_y,nodes_z,ConeAngle] = generateTetradecahedron(rg,GeoParam);
end
%%
P = [nodes_x;nodes_y;nodes_z]';
%% Plot every node before image processing
% if OutlineMode == 1
%     scatter3(nodes_x,nodes_y,nodes_z)
%     if GeoParam.Shape == 1
%         hold on
%         if GeoParam.Rarea <= 1e-7
%             vtex = [xc,yc,hv];
%         end
%         scatter3(vtex(1),vtex(2),vtex(3))
%     end
% end
end