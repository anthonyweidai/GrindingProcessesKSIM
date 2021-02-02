function [P_intersect] = findLinesIntersection3D(P1,P2,u,v)
%% Find intersection point of lines in 3D space, in the least squares sense.
% the intersect should exsist
a = abs(u(1))<=1e-7;
b = abs(u(2))<=1e-7;
c = abs(u(3))<=1e-7;
d = abs(v(1))<=1e-7;
e = abs(v(2))<=1e-7;
f = abs(v(3))<=1e-7;
if (a&&b&&c)||(abs(sum(P1-P2))<=1e-7)||(d&&e&&f)
    P_intersect = P1;
    return
end
tmp1 = 1;
tmp2 = 1;
tmp3 = 1;
if a
    x = P1(1);
elseif d
    x = P2(1);
else
    tmp1 = 0;
end
if b
    y = P1(2);
elseif e
    y = P2(2);
else
    tmp2 = 0;
end
if c
    z = P1(3);
elseif f
    z = P2(3);
else
    tmp3 = 0;
end
if tmp1 == 1
    if tmp2 == 1
        if ~a
            z = (x-P1(1))/u(1)*u(3) + P1(3);
        elseif ~b
            z = (y-P1(2))/u(2)*u(3) + P1(3);
        elseif ~d
            z = (x-P2(1))/v(1)*v(3) + P2(3);
        elseif ~e
            z = (y-P2(2))/v(2)*v(3) + P2(3);
        else
            disp("error")
            return %error
        end
    elseif tmp3 == 1
        if ~a
            y = (x-P1(1))/u(1)*u(2) + P1(2);
        elseif ~c
            y = (z-P1(3))/u(3)*u(2) + P1(2);
        elseif ~d
            y = (x-P2(1))/v(1)*v(2) + P2(2);
        elseif ~f
            y = (z-P2(3))/v(3)*v(2) + P2(2);
        else
            disp("error")
            return %error
        end
    else
        z = ((P2(2)-P1(2))*u(3)*v(3)+u(2)*v(3)*P1(3)-u(3)*v(2)*P2(3))/...
            (u(2)*v(3)-u(3)*v(2));
        y = (z-P1(3))/u(3)*u(2) + P1(2);
    end
elseif tmp2 == 1
    if tmp3 == 1
        if ~b
            x = (y-P1(2))/u(2)*u(1) + P1(1);
        elseif ~c
            x = (z-P1(3))/u(3)*u(1) + P1(1);
        elseif ~e
            x = (y-P2(2))/v(2)*v(1) + P2(1);
        elseif ~f
            x = (z-P2(3))/v(3)*v(1) + P2(1);
        else
            disp("error")
            return %error
        end
    else
        z = ((P2(1)-P1(1))*u(3)*v(3)+u(1)*v(3)*P1(3)-u(3)*v(1)*P2(3))/...
            (u(1)*v(3)-u(3)*v(1));
        x = (z-P1(3))/u(3)*u(1) + P1(1);
    end
elseif tmp3 == 1
    y = ((P2(1)-P1(1))*u(2)*v(2)+u(1)*v(2)*P1(2)-u(2)*v(1)*P2(2))/...
        (u(1)*v(2)-u(2)*v(1));
    x = (y-P1(2))/u(2)*u(1) + P1(1);
else
    z = ((P2(1)-P1(1))*u(3)*v(3)+u(1)*v(3)*P1(3)-u(3)*v(1)*P2(3))/...
        (u(1)*v(3)-u(3)*v(1));
    x = (z-P1(3))/u(3)*u(1) + P1(1);
    y = (z-P1(3))/u(3)*u(2) + P1(2);
end

P_intersect = [x y z];
end