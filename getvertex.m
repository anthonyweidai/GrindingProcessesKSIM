
function [xc, yc]=getvertex(nx, ny, theta, Ratio)
% get the vertex
len = length(nx);

x = [];
y = [];
for i = 1:len
    px1 = i;
    if i==len
        px2 = 1;
    else
        px2 = i+1;
    end
    k = (ny(px2) - ny(px1))/(nx(px2) - nx(px1));
    b = ny(i) - nx(i)*k;
    
    if b>=0&&theta<pi&&theta>=0
        [xtemp,ytemp]=findintersection([0,0;1,tan(theta)],[nx(px1),ny(px1);...
            nx(px2),ny(px2)]);
        x = [x xtemp];
        y = [y ytemp];
    elseif b<0&&theta<=2*pi&&theta>=pi
        [xtemp,ytemp]=findintersection([0,0;1,tan(theta)],[nx(px1),ny(px1);...
            nx(px2),ny(px2)]);
        x = [x xtemp];
        y = [y ytemp];
        
    end
end

%% find the intersection which with minimal distance between (0,0) and itself
lens = length(x);
val = zeros(lens,1);
for k = 1:length(x)
    val(k) = norm([0,0]-[x(k),y(k)]);
end
indi = find(val==min(val));
xc = x(indi)*Ratio;
yc = y(indi)*Ratio;
end
