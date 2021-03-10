function [nodes_x,nodes_y,nodes_z,ConeAngle] = generateFrustum(rg, Vertex, ...
    GeoParam, nodes_x, nodes_y, nodes_z, OutlineMode)
%% Generate Frustum
Omega = GeoParam.Omega;
Rarea = GeoParam.Rarea;
FilletMode = GeoParam.FilletMode;
%% Get top flat surface
Rarea(Rarea == 1) = 0.99;
Rfv = sqrt(Rarea);

nodes_zt = zeros(1,Omega);
nodes_xt = zeros(1,Omega);
nodes_yt = zeros(1,Omega);
hv = Vertex(3);
if GeoParam.RAMode == 1
    zc = hv;
    nodes_zt(:) = hv * Rfv;
else
    zc = hv/(1-Rfv);
    nodes_zt(:) = hv;
end
Vertex(3) = zc; %vertex
ConeAngle = 2*atan(rg/zc);

for j = 1:Omega
    nodes_xt(j) = Vertex(1) + Rfv*(nodes_x(j)-Vertex(1));
    nodes_yt(j) = Vertex(2) + Rfv*(nodes_y(j)-Vertex(2));
end
%% Frustum with/without fillet
if FilletMode == 0
    %% Without fillet
    nodes_x = [nodes_x nodes_xt];
    nodes_y = [nodes_y nodes_yt];
    nodes_z = [nodes_z nodes_zt];
elseif FilletMode == 2 || FilletMode == 1
    %% With fillet
    R_fillet = 0.25*rg;
    Pbottom = [nodes_x; nodes_y; nodes_z]';
    Ptop = [nodes_xt; nodes_yt; nodes_zt]';
    PB = zeros(Omega,3); % bottom point intersect
    O = zeros(Omega,3); % circle center of fillet
    A = zeros(Omega,3); % arc point in edge (on verical plane), visual points
    B = zeros(Omega,3); % arc point in top face
    C1 = zeros(Omega,3); % mid surface point (for smaller trapezoid)
    C2 = zeros(Omega,3); % top surface point (for smaller trapezoid)
    DRv = zeros(Omega,3); % orthogonal vector
    NumofP1 = 6;
    NumofP2 = 2;
    if FilletMode == 2
        NumofP = NumofP2;
    else
        NumofP = NumofP1;
    end
    num = NumofP*Omega;
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
        %%
        if FilletMode == 2||Rarea <= 0.3
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
            C1(k, 1) = Vertex(1) + Rfv*(nodes_x(k)*0.9-Vertex(1));
            C1(k, 2) = Vertex(2) + Rfv*(nodes_y(k)*0.9-Vertex(2));
            C2(k, 1) = Vertex(1) + Rfv*(nodes_x(k)*0.8-Vertex(1));
            C2(k, 2) = Vertex(2) + Rfv*(nodes_y(k)*0.8-Vertex(2));
        end
    end
    if FilletMode == 2 || Rarea <= 0.3
        %% Solution 1
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
            temp2 = min(B(:,3)) - temp1;
            %% get arc point 2D
            if FilletMode == 2
                deltaz1 = temp2/(NumofP);
                temp = temp2/NumofP1;
            else
                deltaz1 = temp2/(NumofP - 1);
                temp = 0;
            end
            z1 = temp1 + (0:1:NumofP-1)*deltaz1;
            z1(end) = z1(end) - temp;
            Pc = zeros(2,3); % 2D arc intersect point on the top plane
            for j = 1:NumofP
                ztemp = z1(j);
                Pc(1,:) = getLinesInterploation(Ptop(k1,:),PB(k1,:),[],ztemp);
                Pc(2,:) = getLinesInterploation(B(k,:),O(k,:),[],ztemp);
                dist = sqrt(R_fillet^2-(norm(Pc(2,:)-O(k,:)))^2);
                arct(j + NumofP*(k-1),:) = getLinesInterploation(Pc(2,:),Pc(1,:),dist);
            end
        end
        %% Get 3D interplation
        arc3d = zeros(num,3);
        for i = 1:Omega
            k1 = i;
            if i == Omega
                k2 = 1;
            else
                k2 = i+1;
            end
            for j = 1:NumofP
                PA = [arct(j+NumofP*(k1-1),:);arct(j+NumofP*(k2-1),:)];
                %% rebuild the lineIntersec3D
                arc3d(j+NumofP*(i-1),:) = findLinesIntersection3D(PA(1,:),PA(2,:),...
                    DRv(k1,:),DRv(k2,:));
            end
        end
        nodes_x = [nodes_x arc3d(:,1)'];
        nodes_y = [nodes_y arc3d(:,2)'];
        nodes_z = [nodes_z arc3d(:,3)'];
        %         end
    else
        %% Solution 2
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
end
%%
if OutlineMode == 1
    scatter3(nodes_x,nodes_y,nodes_z)
    hold on
    scatter3(Vertex(:,1),Vertex(:,2),Vertex(:,3))
    if FilletMode == 2
        hold on
        scatter3(B(:,1),B(:,2),B(:,3));
        hold on
        scatter3(arc3d(:,1),arc3d(:,2),arc3d(:,3));
    end
end
end