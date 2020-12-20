
function P = inpoint(P1,P2,dis,z,inverse)
%% get the point between two points, according to the distance or ratio
% dis is distance between P and P1,
% if inverse == 1, dis is ratio fraction of dis1 and dis_total
if exist('inverse','var')
    Rp = dis;
    Px = (P2(1)-P1(1))/Rp + P1(1);
    Py = (P2(2)-P1(2))/Rp + P1(2);
    Pz = (P2(3)-P1(3))/Rp + P1(3);
    P = [Px,Py,Pz];
else
    if ~exist('z','var')
        PP = norm(P1 - P2);
        Rp = dis/PP;
    else
        Rp = 1- (z-P2(3))/(P1(3)-P2(3));
    end
    Px = P1(1) + Rp*(P2(1)-P1(1));
    Py = P1(2) + Rp*(P2(2)-P1(2));
    Pz = P1(3) + Rp*(P2(3)-P1(3));
    P = [Px,Py,Pz];
end
end
