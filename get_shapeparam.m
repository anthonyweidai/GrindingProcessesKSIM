function [P]=get_shapeparam(R_culet,geoparam)
%% generate the shape of grains
outline_mode = 0;
if geoparam.shape == 1
    omega = geoparam.omega;
    Rarea = geoparam.Rarea;
    fillet_mode = geoparam.fillet_mode;
    
     h2w_ratio = 1;
%     mutemp = 2*R_culet*geoparam.h2w_ratio;
    mutemp = 2*R_culet*h2w_ratio;
    hmax = normrnd(mutemp,mutemp*geoparam.sigmah);
    hmax = max(hmax,(mutemp-3*mutemp*geoparam.sigmah));
    hmax = min(hmax,(mutemp+3*mutemp*geoparam.sigmah));
    
    vertex_theta = rand*3.1415926*2; % orientation of the vertex, vertex_theta = 0~2*pi
    mutemp = 0.4;
    Rvertex = normrnd(mutemp,mutemp*geoparam.sigmasw); % ratio of the vertex's location, Rvertex = 0~0.8
    Rvertex = max(Rvertex,0);
    Rvertex = min(0.8,Rvertex);
    %% polygon vertices on bottom plane
    nodes_x = zeros(1,omega);
    nodes_y = zeros(1,omega);
    nodes_z = zeros(1,omega);
    
    for i = 0:omega-1
        theta_culet = i*2*pi/omega;
        nodes_x(i+1) = R_culet*cos(theta_culet);
        nodes_y(i+1) = R_culet*sin(theta_culet);
    end
    [xc, yc] = getvertex(nodes_x(1:omega),nodes_y(1:omega),vertex_theta,Rvertex);
    %%
    if Rarea<=1e-7
        %% pyramid with fillet
        if fillet_mode == 1
            setback = 0.5*R_culet/2;
            xtemp = xc;
            ytemp = yc;
            ztemp = hmax;
            vtex = [xtemp,ytemp,ztemp];
            A = zeros(omega,3); % points in edge
            B = zeros(omega,3); % points between highest points on edge fillet (C)
            C = zeros(omega,3); % edge fillet highest points
            midp = zeros(omega,3); % middle points in bottom face
            %% generate points
            for i = 1:omega
                if i == omega
                    x1 = [nodes_x(i),nodes_y(i),nodes_z(i)];
                    x2 = [nodes_x(1),nodes_y(1),nodes_z(1)];
                else
                    x1 = [nodes_x(i),nodes_y(i),nodes_z(i)];
                    x2 = [nodes_x(i+1),nodes_y(i+1),nodes_z(i+1)];
                end
                %% get arc point pont in edge
                A(i,:) = inpoint(vtex,x1,setback);
                %% get arc top point
                disVC = 5/8*setback;
                midp(i,:) = (x1+x2)/2;
                C(i,:) = inpoint(vtex,midp(i,:),disVC);
            end
            %% equivalent C
            Ce = mean(C(:,3));
            for t1 = 1:omega
                C(t1,:) = inpoint(vtex,midp(t1,:),[],Ce);
            end
            %% Interpolation
            % edge arc
            for j = 1:omega
                k1 = j;
                if j == omega
                    k2 = 1;
                else
                    k2 = j+1;
                end
                d=[A(k1,:); C(j,:); A(k2,:)];
                [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d,10);
                % top face point
                
                B(j,:) = (C(k1,:)+C(k2,:))/2;
            end
            %% get point to fill up top place
            % top
            Zmax = max(nodes_z);
            Sz = Zmax + 1/15*setback*(omega^(6/11)/7+0.55); % compensate
            Rs = Sz/vtex(3);
            Sx = Rs*vtex(1);
            Sy = Rs*vtex(2);
            nsph = [Sx,Sy,Sz];
            nodes_x = [nodes_x nsph(1)];
            nodes_y = [nodes_y nsph(2)];
            nodes_z = [nodes_z nsph(3)];
            
            B(:,3) = B(:,3) + setback*2/(15*omega); % compensate
            D = (nsph + B)/2;
            delta1 = nsph(3)-mean(D(:,3));
            D(:,3) = D(:,3) + delta1/2; % compensate
            % top face arc
            for j = 1:omega
                k1 = j;
                if j == omega
                    k2 = 1;
                else
                    k2 = j+1;
                end
                d=[C(k1,:); B(j,:); C(k2,:)];
                [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d);
                d=[nsph; D(j,:); B(j,:)];
                [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d);
            end
        else
            nodes_x = [nodes_x xc];
            nodes_y = [nodes_y yc];
            nodes_z = [nodes_z hmax];
        end
    else
        %% trapezoid, get top flat surface
        Rarea(Rarea == 1) = 0.99;
        Rfv = sqrt(Rarea);
        
        nodes_zt = zeros(1,omega);
        nodes_xt = zeros(1,omega);
        nodes_yt = zeros(1,omega);
        if geoparam.RA_mode == 1
            zc = hmax;
            nodes_zt(:) = hmax * Rfv;
        else
            zc = hmax/(1-Rfv);
            nodes_zt(:) = hmax;
        end
        vtex = [xc,yc,zc]; %vertex
        
        for j = 1:omega
            nodes_xt(j) = vtex(1) + Rfv*(nodes_x(j)-vtex(1));
            nodes_yt(j) = vtex(2) + Rfv*(nodes_y(j)-vtex(2));
        end
        %% trapezoid with/without fillet
        if fillet_mode == 1
            %% with fillet
            R_fillet = 0.5*R_culet/2;
            Pbottom = [nodes_x; nodes_y; nodes_z]';
            Ptop = [nodes_xt; nodes_yt; nodes_zt]';
            PB = zeros(omega,3);
            O = zeros(omega,3); % circle of fillet
            A = zeros(omega,3); % arc point in edge (on verical plane), visual points
            B = zeros(omega,3); % arc point in top face
            C1 = zeros(omega,3); % mid surface point (for smaller trapezoid)
            C2 = zeros(omega,3); % top surface point (for smaller trapezoid)
            DRv = zeros(omega,3); % orthogonal vector
            numofp = 6;
            num = numofp*omega;
            arct = zeros(num,3); % 2D arc point
            %% get A, B, O, C1, C2
            for k = 1:omega
                k1 = k;
                if k == omega
                    k2 = 1;
                else
                    k2 = k+1;
                end
                P1 = Pbottom(k1,:);
                P2 = Pbottom(k2,:);
                P3 = Ptop(k1,:);
                u1 = P2 - P1;
                u2 = P3 - P1;
                ang12 = atan2(norm(cross(u1,u2)),dot(u1,u2));
                dist1 = norm(P1-P3)*cos(ang12);
                PB(k1,:) = inpoint(Pbottom(k1,:),Pbottom(k2,:),dist1);
                v = PB(k1,:) - P3;
                nor = [u1(2),-u1(1),0];
                ang34 = atan2(norm(cross(v,nor)),dot(v,nor));
                if ang34>pi/2
                    ang34 =  ang34 - pi/2;
                end
                % GET A
                disAP1 = R_fillet*tan(ang34/2);
                A(k,:) = inpoint(P3,PB(k1,:),disAP1);
                if geoparam.Rarea <= 0.3
                    % get B, O
                    dist2 = norm(PB(k1,:)-Ptop(k1,:))*cos(ang34);
                    dist3 = disAP1 + dist2;
                    ratio = dist2/dist3;
                    Pc1 = [P3(1:2),0];
                    Pc2 = inpoint(PB(k1,:),Pc1,ratio,[],1);
                    B(k,:) = [Pc2(1:2),P3(3)];
                    O(k,:) = inpoint(B(k,:),Pc2,R_fillet);
                    DRv(k1, :) = u1;% GET orthogonal vector, parallel to adjacent surface
                else
                    % get C1, C2
                    C1(k, 1) = vtex(1) + Rfv*(nodes_x(k)*0.9-vtex(1));
                    C1(k, 2) = vtex(2) + Rfv*(nodes_y(k)*0.9-vtex(2));
                    C2(k, 1) = vtex(1) + Rfv*(nodes_x(k)*0.8-vtex(1));
                    C2(k, 2) = vtex(2) + Rfv*(nodes_y(k)*0.8-vtex(2));
                end
            end
            if geoparam.Rarea <= 0.3
                %% solution 1
                for k = 1:omega
                    k1 = k;
                    if k == omega
                        k2 = 1;
                    else
                        k2 = k+1;
                    end
                    if k == 1
                        k3 = omega;
                    else
                        k3 = k-1;
                    end
                    temp1 = max(max(A(k1,3),A(k2,3)),A(k3,3));
                    deltaz1 = (min(B(:,3)) - temp1)/(numofp);
                    z1 = temp1 + (0:1:numofp-1)*deltaz1;
                    Pc = zeros(2,3);
                    %% get arc point 2D
                    for j = 1:numofp
                        ztemp = z1(j);
                        Pc(1,:) = inpoint(Ptop(k1,:),PB(k1,:),[],ztemp);
                        Pc(2,:) = inpoint(B(k,:),O(k,:),[],ztemp);
                        dist = sqrt(R_fillet^2-(norm(Pc(2,:)-O(k,:)))^2);
                        arct(j + numofp*(k-1),:) = inpoint(Pc(2,:),Pc(1,:),dist);
                    end
                end
                %% get 3D interplation
                arc3d = zeros(num,3);
                for i = 1:omega
                    k1 = i;
                    if i == omega
                        k2 = 1;
                    else
                        k2 = i+1;
                    end
                    for j = 1:numofp
                        PA = [arct(j+numofp*(k1-1),:);arct(j+numofp*(k2-1),:)];
                        %% rebuild the lineIntersec3D
                        arc3d(j+numofp*(i-1),:) = lineIntersect3D(PA(1,:),PA(2,:),...
                            DRv(k1,:),DRv(k2,:));
                    end
                end
                nodes_x = [nodes_x arc3d(:,1)'];
                nodes_y = [nodes_y arc3d(:,2)'];
                nodes_z = [nodes_z arc3d(:,3)'];
            else
                %% solution 2
                C1(:, 3) = 0.6*nodes_zt + 0.4*mean(A(:,3));
                C2(:, 3) = nodes_zt;
                for i = 1:omega
                    k1 = i;
                    if i == omega
                        k2 = 1;
                    else
                        k2 = i+1;
                    end
                    d = [A(k1,:);A(k2,:)];
                    [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d,10);
                    d = [C1(k1,:);C1(k2,:)];
                    [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d,10);
                    d = [C2(k1,:);C2(k2,:)];
                    [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d,10);
                end
            end
        else
            %% without fillet
            nodes_x = [nodes_x nodes_xt];
            nodes_y = [nodes_y nodes_yt];
            nodes_z = [nodes_z nodes_zt];
        end
    end
elseif geoparam.shape == 2
    if geoparam.Rarea == 1
        %% shpere
        theta=2*pi*rand(1,700);
        phi=24*pi/50*rand(1,700)+pi/50;
        rho=R_culet;
        nodes_x=rho*sin(phi).*cos(theta);
        nodes_y=rho*sin(phi).*sin(theta);
        nodes_z=rho*cos(phi);
    else
        %% ellipsoid
        a = geoparam.Rarea * R_culet;
        b = a;
        c = R_culet;
        theta=2*pi*rand(1,700);
        phi=24*pi/50*rand(1,700)+pi/50;
        nodes_x=a*sin(phi).*cos(theta);
        nodes_y=b*sin(phi).*sin(theta);
        nodes_z=c*cos(phi);
    end
elseif geoparam.shape == 3
    %% Cuboctahedron
    hw=normrnd(0.2886,0.0962);%default value for intact octahedron
    hw=max(hw,0.02);
    hw=min(0.2886,hw);
    
    a=1.68;
    b=(3^0.5/2*a-hw)*4/(10^0.5);
    c=b*(hw)/((10^0.5)/4*b);
    h=a/2;
    l=a/2-c;
    
    nodes_x=[h h l, -h -h -l, h h l, -h -h -l,    h h l, -h -h -l,    h h l, -h -h -l,];
    nodes_y=[h l h, h l h,    -h -l -h, -h -l -h, h l h, h l h,       -h -l -h, -h -l -h,];
    nodes_z=[l h h, l h h,    l h h, l h h,       -l -h -h, -l -h -h, -l -h -h, -l -h -h,];
end
%%
P = [nodes_x;nodes_y;nodes_z]';
%% Plot every node before image processing
if outline_mode == 1
    scatter3(nodes_x,nodes_y,nodes_z)
    if geoparam.shape == 1
        hold on
        if geoparam.Rarea <= 1e-7
            vtex = [xc,yc,hmax];
        end
        scatter3(vtex(1),vtex(2),vtex(3))
    end
end
end