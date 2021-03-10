function [nodes_x,nodes_y,nodes_z,ConeAngle] = generateTetradecahedron(rg,GeoParam)
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