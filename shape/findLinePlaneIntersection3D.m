function point = findLinePlaneIntersection3D(rayVector, rayPoint, planeNormal, planePoint)
%% Find 3d line and plane intersection
% they should not perpendicular
pdiff = rayPoint - planePoint;
prod1 = dot(pdiff, planeNormal);
prod2 = dot(rayVector, planeNormal);
prod3 = prod1 / prod2;% the rayVector cannot be perpendicular to plane

point = rayPoint - rayVector * prod3;
end