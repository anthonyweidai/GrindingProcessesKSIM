function [nodes_x,nodes_y,nodes_z,ConeAngle] = generatePyramid(rg, Vertex, ...
    GeoParam, nodes_x, nodes_y, nodes_z, OutlineMode)
%% Generate Pyramid
Omega = GeoParam.Omega;
FilletMode = GeoParam.FilletMode;
xc = Vertex(1);
yc = Vertex(2);
hv = Vertex(3);
%%
ConeAngle = 2*atan(rg/hv);
%% pyramid with fillet
if FilletMode == 0
    nodes_x = [nodes_x xc];
    nodes_y = [nodes_y yc];
    nodes_z = [nodes_z hv];
elseif FilleMode == 1
    setback = 0.5*rg/2;
    xtemp = xc;
    ytemp = yc;
    ztemp = hv;
    vtex = [xtemp,ytemp,ztemp];
    
    A = zeros(Omega,3); % points in edge
    B = zeros(Omega,3); % points between highest points on edge fillet (C)
    C = zeros(Omega,3); % edge fillet highest points
    midp = zeros(Omega,3); % middle points in bottom face
    %% generate points
    for i = 1:Omega
        if i == Omega
            x1 = [nodes_x(i),nodes_y(i),nodes_z(i)];
            x2 = [nodes_x(1),nodes_y(1),nodes_z(1)];
        else
            x1 = [nodes_x(i),nodes_y(i),nodes_z(i)];
            x2 = [nodes_x(i+1),nodes_y(i+1),nodes_z(i+1)];
        end
        %% get arc point pont in edge
        A(i,:) = getLinesInterploation(vtex,x1,setback);
        %% get arc top point
        disVC = 5/8*setback;
        midp(i,:) = (x1+x2)/2;
        C(i,:) = getLinesInterploation(vtex,midp(i,:),disVC);
    end
    %% equivalent C
    Ce = mean(C(:,3));
    for t1 = 1:Omega
        C(t1,:) = getLinesInterploation(vtex,midp(t1,:),[],Ce);
    end
    %% Interpolation
    % edge arc
    for j = 1:Omega
        k1 = j;
        if j == Omega
            k2 = 1;
        else
            k2 = j+1;
        end
        d=[A(k1,:); C(j,:); A(k2,:)];
        [nodes_x,nodes_y,nodes_z] = getCurveInterpolation(nodes_x,nodes_y,nodes_z,d,10);
        % top face point
        
        B(j,:) = (C(k1,:)+C(k2,:))/2;
    end
    %% get point to fill up top place
    % top
    Zmax = max(nodes_z);
    Sz = Zmax + 1/15*setback*(Omega^(6/11)/7+0.6); % compensate
    Rs = Sz/vtex(3);
    Sx = Rs*vtex(1);
    Sy = Rs*vtex(2);
    nsph = [Sx,Sy,Sz];
    nodes_x = [nodes_x nsph(1)];
    nodes_y = [nodes_y nsph(2)];
    nodes_z = [nodes_z nsph(3)];
    
    B(:,3) = B(:,3) + setback*2/(15*Omega); % compensate
    D = (nsph + B)/2;
    delta1 = nsph(3)-mean(D(:,3));
    D(:,3) = D(:,3) + delta1/2; % compensate
    % top face arc
    for j = 1:Omega
        k1 = j;
        if j == Omega
            k2 = 1;
        else
            k2 = j+1;
        end
        d=[C(k1,:); B(j,:); C(k2,:)];
        [nodes_x,nodes_y,nodes_z] = getCurveInterpolation(nodes_x,nodes_y,nodes_z,d);
        d=[nsph; D(j,:); B(j,:)];
        [nodes_x,nodes_y,nodes_z] = getCurveInterpolation(nodes_x,nodes_y,nodes_z,d);
    end
end
if OutlineMode == 1
    figure
    scatter3(nodes_x,nodes_y,nodes_z)
    hold on
    scatter3(Vertex(1),Vertex(2),Vertex(3))
end
end