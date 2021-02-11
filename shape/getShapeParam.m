function [P, ConeAngle]=getShapeParam(rg, GeoParam)
%% generate the Shape of grains
outline_mode = 0;
if GeoParam.Shape == 1
    Omega = GeoParam.Omega;
    Rarea = GeoParam.Rarea;
    FilletMode = GeoParam.FilletMode;
    
    mutemp = rg*GeoParam.RHeightSize;
    hv = normrnd(mutemp,mutemp*GeoParam.Sigmah); % the height of top plane
    hv = max(hv,(mutemp-3*mutemp*GeoParam.Sigmah));
    hv = min(hv,(mutemp+3*mutemp*GeoParam.Sigmah));

    theta_v = rand*3.1415926*2; % orientation of the vertex, theta_v = 0~2*pi
    mutemp = 0.4;
    Rv = normrnd(mutemp,mutemp*GeoParam.SigmaSkew); % ratio of the vertex's location, Rvertex = 0~0.8
    Rv = max(Rv,0);
    Rv = min(0.8,Rv);
    %% polygon vertices on bottom plane
    nodes_x = zeros(1,Omega);
    nodes_y = zeros(1,Omega);
    nodes_z = zeros(1,Omega);
    
    for i = 0:Omega-1
        theta_culet = i*2*pi/Omega;
        nodes_x(i+1) = rg*cos(theta_culet);
        nodes_y(i+1) = rg*sin(theta_culet);
    end
    [xc, yc] = getVertex(nodes_x(1:Omega),nodes_y(1:Omega),theta_v,Rv);
    %%
    if Rarea<=1e-7
        ConeAngle = 2*atan(rg/hv);
        %% pyramid with fillet
        if FilletMode == 1
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
        else
            nodes_x = [nodes_x xc];
            nodes_y = [nodes_y yc];
            nodes_z = [nodes_z hv];
        end
    else
        %% frustum, get top flat surface
        Rarea(Rarea == 1) = 0.99;
        Rfv = sqrt(Rarea);
        
        nodes_zt = zeros(1,Omega);
        nodes_xt = zeros(1,Omega);
        nodes_yt = zeros(1,Omega);
        if GeoParam.RAMode == 1
            zc = hv;
            nodes_zt(:) = hv * Rfv;
        else
            zc = hv/(1-Rfv);
            nodes_zt(:) = hv;
        end
        vtex = [xc,yc,zc]; %vertex
        ConeAngle = 2*atan(rg/zc);
        
        for j = 1:Omega
            nodes_xt(j) = vtex(1) + Rfv*(nodes_x(j)-vtex(1));
            nodes_yt(j) = vtex(2) + Rfv*(nodes_y(j)-vtex(2));
        end
        %% frustum with/without fillet
        if FilletMode == 1
            %% with fillet
            R_fillet = 0.5*rg/2;
            Pbottom = [nodes_x; nodes_y; nodes_z]';
            Ptop = [nodes_xt; nodes_yt; nodes_zt]';
            PB = zeros(Omega,3);
            O = zeros(Omega,3); % circle of fillet
            A = zeros(Omega,3); % arc point in edge (on verical plane), visual points
            B = zeros(Omega,3); % arc point in top face
            C1 = zeros(Omega,3); % mid surface point (for smaller trapezoid)
            C2 = zeros(Omega,3); % top surface point (for smaller trapezoid)
            DRv = zeros(Omega,3); % orthogonal vector
            numofp = 6;
            num = numofp*Omega;
            arct = zeros(num,3); % 2D arc point
            %% get A, B, O, C1, C2
            for k = 1:Omega
                k1 = k;
                if k == Omega
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
                PB(k1,:) = getLinesInterploation(Pbottom(k1,:),Pbottom(k2,:),dist1);
                v = PB(k1,:) - P3;
                nor = [u1(2),-u1(1),0];
                ang34 = atan2(norm(cross(v,nor)),dot(v,nor));
                if ang34>pi/2
                    ang34 =  ang34 - pi/2;
                end
                % GET A
                disAP1 = R_fillet*tan(ang34/2);
                A(k,:) = getLinesInterploation(P3,PB(k1,:),disAP1);
                if GeoParam.Rarea <= 0.3
                    % get B, O
                    dist2 = norm(PB(k1,:)-Ptop(k1,:))*cos(ang34);
                    dist3 = disAP1 + dist2;
                    ratio = dist2/dist3;
                    Pc1 = [P3(1:2),0];
                    Pc2 = getLinesInterploation(PB(k1,:),Pc1,ratio,[],1);
                    B(k,:) = [Pc2(1:2),P3(3)];
                    O(k,:) = getLinesInterploation(B(k,:),Pc2,R_fillet);
                    DRv(k1, :) = u1;% GET orthogonal vector, parallel to adjacent surface
                else
                    % get C1, C2
                    C1(k, 1) = vtex(1) + Rfv*(nodes_x(k)*0.9-vtex(1));
                    C1(k, 2) = vtex(2) + Rfv*(nodes_y(k)*0.9-vtex(2));
                    C2(k, 1) = vtex(1) + Rfv*(nodes_x(k)*0.8-vtex(1));
                    C2(k, 2) = vtex(2) + Rfv*(nodes_y(k)*0.8-vtex(2));
                end
            end
            if GeoParam.Rarea <= 0.3
                %% solution 1
                for k = 1:Omega
                    k1 = k;
                    if k == Omega
                        k2 = 1;
                    else
                        k2 = k+1;
                    end
                    if k == 1
                        k3 = Omega;
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
                        Pc(1,:) = getLinesInterploation(Ptop(k1,:),PB(k1,:),[],ztemp);
                        Pc(2,:) = getLinesInterploation(B(k,:),O(k,:),[],ztemp);
                        dist = sqrt(R_fillet^2-(norm(Pc(2,:)-O(k,:)))^2);
                        arct(j + numofp*(k-1),:) = getLinesInterploation(Pc(2,:),Pc(1,:),dist);
                    end
                end
                %% get 3D interplation
                arc3d = zeros(num,3);
                for i = 1:Omega
                    k1 = i;
                    if i == Omega
                        k2 = 1;
                    else
                        k2 = i+1;
                    end
                    for j = 1:numofp
                        PA = [arct(j+numofp*(k1-1),:);arct(j+numofp*(k2-1),:)];
                        %% rebuild the lineIntersec3D
                        arc3d(j+numofp*(i-1),:) = findLinesIntersection3D(PA(1,:),PA(2,:),...
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
                for i = 1:Omega
                    k1 = i;
                    if i == Omega
                        k2 = 1;
                    else
                        k2 = i+1;
                    end
                    d = [A(k1,:);A(k2,:)];
                    [nodes_x,nodes_y,nodes_z] = getCurveInterpolation(nodes_x,nodes_y,nodes_z,d,10);
                    d = [C1(k1,:);C1(k2,:)];
                    [nodes_x,nodes_y,nodes_z] = getCurveInterpolation(nodes_x,nodes_y,nodes_z,d,10);
                    d = [C2(k1,:);C2(k2,:)];
                    [nodes_x,nodes_y,nodes_z] = getCurveInterpolation(nodes_x,nodes_y,nodes_z,d,10);
                end
            end
        else
            %% without fillet
            nodes_x = [nodes_x nodes_xt];
            nodes_y = [nodes_y nodes_yt];
            nodes_z = [nodes_z nodes_zt];
        end
    end
elseif GeoParam.Shape == 2
    %% ellipsoid
    a = rg;
    b = a;
    
    if GeoParam.Rarea<=1e-7
        Rarea = 0; % the ratio of area of cross section 
    else
        Rarea = GeoParam.Rarea;
    end
    mutemp = rg/Rarea;
    c = max(mutemp,(mutemp-3*mutemp*GeoParam.Sigmah));
    c = min(c,(mutemp+3*mutemp*GeoParam.Sigmah));
    ConeAngle = 2*atan(rg/c);
    %%
    theta=2*pi*rand(1,700);
    phi=24*pi/50*rand(1,700)+pi/50;
    nodes_x=a*sin(phi).*cos(theta);
    nodes_y=b*sin(phi).*sin(theta);
    nodes_z=c*cos(phi);
elseif GeoParam.Shape == 3
    %% tetradecahedron = cube by cuting its 6 vertecies
    a = 1.414*rg; % the length of cube
    temp = a/2;
    rectangle = [temp, -temp, 0; %
        temp, temp, 0;
        -temp, temp, 0;
        -temp, -temp, 0;
        temp, -temp, temp;
        temp, temp, temp;
        -temp, temp, temp;
        -temp, -temp, temp];
    
    Xi = GeoParam.Xi;
    b = 0.707*a + 1.414*a*Xi;
    octahedron = [0, -0.707*b, 0; % b = sqrt(2)*(a/2+a*Xi)
        0.707*b, 0, 0;
        0, 0.707*b, 0;
        -0.707*b, 0, 0;
        0, 0, a/2+a*Xi];
    
    num_face = 6;
    num_vertex = size(rectangle,1);
    num_edges = num_face + num_vertex - 2;
    %% for rectangle edges
    edges_coordinate = zeros(num_edges-4,3);
    edges_coordinate(1:4,:) = repmat([0 0 1],4,1);
    num_temp = 4;
    for i = 1:num_edges/3
        k1 = i;
        if i == num_edges/3
            k2 = 1;
        else
            k2 = k1 + 1;
        end
        num_temp = num_temp + 1;
        edges_coordinate(num_temp,:) = rectangle(k1+num_edges/3,:) - rectangle(k2+num_edges/3,:);
    end
    %% for octahedron faces
    realnum_vertex = num_vertex/2;
    normal_vector = zeros(realnum_vertex,3);
    for j = 1:realnum_vertex
        k1 = j;
        if j == realnum_vertex
            k2 = 1;
        else
            k2 = k1 + 1;
        end
        normal_vector(j,:) = cross((octahedron(end,:)-octahedron(k1,:)),...
            (octahedron(end,:)-octahedron(k2,:))); % normalize will change the relationship
    end
    %% for tetradecahedron vertecies
    tetra_num_vertex = realnum_vertex*3;
    tetradecahedron = zeros(tetra_num_vertex,3); % half of vertecies
    num_temp = 0;
    for k = 1:realnum_vertex
        rayPoint = rectangle(k + realnum_vertex,:);
        planeNormal = normal_vector(k,:);
        planePoint = octahedron(end,:);
        I1 = findLinePlaneIntersection3D(edges_coordinate(k,:),rayPoint,planeNormal,planePoint);
        I1(3) = - I1(3);
        I2 = findLinePlaneIntersection3D(edges_coordinate(k+realnum_vertex,:),rayPoint,planeNormal,planePoint);
        if k == 1
            k2 = realnum_vertex;
        else
            k2 = k - 1;
        end
        I3 = findLinePlaneIntersection3D(edges_coordinate(k2+realnum_vertex,:),rayPoint,planeNormal,planePoint); % k label edge 3
        num_temp = num_temp + 1;
        tetradecahedron(num_temp:num_temp+2,:) = [I1; I2; I3];
        num_temp = num_temp + 2;
    end
    %%
    mu_r = 2.828; % 2x1.414 times
    Sigmah = GeoParam.Sigmah;
    Hr = normrnd(mu_r,mu_r*Sigmah);
    Hr = max(Hr,(mu_r-3*mu_r*Sigmah));
    Hr = min(Hr,(mu_r+3*mu_r*Sigmah));
    tetradecahedron(:,3) = tetradecahedron(:,3)*Hr;
    tetradecahedron = [tetradecahedron; rectangle(1:realnum_vertex,:)];
    
    nodes_x = tetradecahedron(:,1)';
    nodes_y = tetradecahedron(:,2)';
    nodes_z = tetradecahedron(:,3)';
    ConeAngle = 0;
end
%%
P = [nodes_x;nodes_y;nodes_z]';
%% Plot every node before image processing
if outline_mode == 1
    scatter3(nodes_x,nodes_y,nodes_z)
    if GeoParam.Shape == 1
        hold on
        if GeoParam.Rarea <= 1e-7
            vtex = [xc,yc,hv];
        end
        scatter3(vtex(1),vtex(2),vtex(3))
    end
end
end