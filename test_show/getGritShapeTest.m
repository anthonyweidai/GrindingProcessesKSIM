set(0,'defaultfigurecolor',[1 1 1])
%use the octahedron as the object to cut by surfaces of a cube
clear,close all
rg = 10;        %DEFAULT grit size
testmode = 2;
orimode = 0;
res = .01;

GeoParam.Shape = 3;
GeoParam.Trimmingh = 0;
GeoParam.Omega = 7;

GeoParam.Xi = 1/2/1.732;
GeoParam.RHeightSize = 1;
GeoParam.Rarea = 0.1;
GeoParam.RAMode = 1;
GeoParam.Sigmah = 0;
GeoParam.SigmaSkew = 0; 
GeoParam.FilletMode = 2;
%%
OutlineMode = 1;
[P, ConeAngle] = getShapeParam(rg,GeoParam,OutlineMode);
%% draw initial grit
if testmode==2
    figure;
    %         hFig = figure('Visible', 'off');
    plot3(P(:,1),P(:,2),P(:,3),'.','MarkerSize',10);
    grid on;
    k = boundary(P,0);
    hold on;
    trisurf(k,P(:,1),P(:,2),P(:,3),'Facecolor','red','FaceAlpha',1);
    axis equal;
    xlabel('x')
    ylabel('y')
end
%% rotate grit
rotate_angle = rand*3.1415926;
rotate_z_ori = [cos(rotate_angle) -sin(rotate_angle) 0; sin(rotate_angle) cos(rotate_angle) 0; 0 0 1];
for i = 1:size(P,1)
    P(i,:) = rotate_z_ori*P(i,:)';
end
%%
vq = [];
while isempty(vq)
    lowerb_p = min(P(:,3));
    [xq,yq] = meshgrid(-rg:res:rg, -rg:res:rg);
    vq = griddata(P(:,1),P(:,2),P(:,3),xq,yq);
    P(:,3) = P(:,3) + max(P(:,3)-min(P(:,3)))/2;
end
vq = vq - lowerb_p;
vq(isnan(vq)) = 0;
h_vq = max(vq,[],'all');
%% trimming
if GeoParam.Trimmingh >= 1e-7
    MuTrim = GeoParam.Trimmingh;
    SigmaTrim = 0.1;
    Trimmingh = normrnd(GeoParam.Trimmingh, MuTrim*SigmaTrim);
    Trimmingh = max(Trimmingh, MuTrim - 3*MuTrim*SigmaTrim);
    vq = min(vq,Trimmingh);
end
newh_vq = max(vq,[],'all');
if GeoParam.Shape == 1
    ActiveRarea = 1-(1-(h_vq-newh_vq)/h_vq)*(1-GeoParam.Rarea);
else
    ActiveRarea = 0;
end
if testmode ==2
    % ------------test figure for the griddata
    figure;
    %         hFig = figure('Visible', 'off');
    mesh(xq,yq,vq)
    % title('griddata')
    hold on
    xlim([-rg rg])
    ylim([-rg rg])
    xlabel('x')
    % xlabel('x','FontSize',24)
    ylabel('y')
    zlabel('z')
    axis equal;drawnow;
end