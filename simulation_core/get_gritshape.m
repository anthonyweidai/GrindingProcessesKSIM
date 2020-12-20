function [vq] = get_gritshape(R,geoparam)
%% parameters notion, use structure for input variables
% R-DEFAULT grit size, shape: 1-pyramid&trapezoid 2-shpere&ellipsoid
% omega, number of edges for pyramid and trapezoid
% orien, orientation for ellipsoid
% h2w_ratio = height/(2*R)
% Rarea-ratio of trapezoid area of top face to bottom face, 0(pyramid)and 0.05~1,
% and if 1, set fillet_mode = 0
% sigmah is the deviation of height of grain
% sigmasw is the deviation of skew of the vertex
% fillet_mode: 1-with fillet, 0 without fillet
% RA_mode: 1 - Rake angle is constant, 0 - Rake angle is not constant
% Example1 [vq] = get_gritshape(2,1,1,5,0.5,0,.1,.1);
% Example2 [vq] = get_gritshape(2,1,0,7,0.6,0.2,.1,.1);
% Example3 [vq] = get_gritshape(2,2);
% Example4 [vq] = get_gritshape(2,3,1,sqrt(1.5),sqrt(2),sqrt(1.5));

%%
rotate_angle = rand*3.1415926;
P = get_shapeparam(R,geoparam);
res=.2;
%% rotate grit
if geoparam.shape == 3
    % SCALING the size of the grit
    rr = max(sum(P.^2,2).^0.5);
    scale_m = [2*R/rr 0 0;0 2*R/rr 0;0 0 2*R/rr];
    for i = 1:size(P,1)
        P(i,:) = scale_m*P(i,:)';
    end
    rotate_z1 = [cos(pi/4) -sin(pi/4) 0; sin(pi/4) cos(pi/4) 0; 0 0 1];
    rotate_y1 = [cos(pi/2-asin((3^0.5)/3)) 0 sin(pi/2-asin((3^0.5)/3)); 0 1 0; -sin(pi/2-asin((3^0.5)/3)) 0 cos(pi/2-asin((3^0.5)/3))];
    
    for i = 1:size(P,1)
        P(i,:) = rotate_z1*P(i,:)';
        if orimode == 2
            P(i,:) = rotate_y1*P(i,:)';
        end
    end
end

rotate_z_ori = [cos(rotate_angle) -sin(rotate_angle) 0; sin(rotate_angle) cos(rotate_angle) 0; 0 0 1];
for i = 1:size(P,1)
    P(i,:) = rotate_z_ori*P(i,:)';
end
%%
vq = [];
while isempty(vq)
    positive_p = find(P(:,3)>-0.1);
    new_P = P(positive_p,:);
    lowerb_p = min(P(:,3));
    [xq,yq] = meshgrid(-R:res:R, -R:res:R);
    vq = griddata(new_P(:,1),new_P(:,2),new_P(:,3),xq,yq);
    P(:,3) = P(:,3) + max(P(:,3)-min(P(:,3)))/2;
end
vq = vq - lowerb_p;
vq(isnan(vq)) = 0;
%% trimming
if geoparam.trim_h == 0
else
    trim_h = normrnd(geoparam.trim_h,0.1);
    vq = min(vq,trim_h);
end
end
%% list of functions
%   get_gritshape
%   - get_shapeparam
%   -- inpoint
%   -- interpoints
%   -- lineIntersect3D
%   -- interpoints
%   -- getvertex
%   === finintersection