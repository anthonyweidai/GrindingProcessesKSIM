function [GritsProfile, GeoParam]=wheelGeneration(mode, grits, FileName, GeoParam, res)
%% Generate wheel topography
%% geometrical parameters
numgrits = size(grits.Tradius,1);

Surf_l = fix(max(grits.posy));
Surf_w = fix(max(grits.posx));
mode = 0;
GritsProfile = {};
%%
if mode==0
    x_upper=Surf_l/res;
    y_upper=Surf_w/res;
    wheel_x=0:res:Surf_l;
    wheel_y=0:res:Surf_w;
    wheel_h=zeros(y_upper+1,x_upper+1);
    
    grits.lowbounds=max(0,round(grits.posx*10)/10-round(grits.Tradius*10)/10);
    grits.highbounds=min(Surf_w,round(grits.posx*10)/10+round(grits.Tradius*10)/10);
    grits.leftbounds=max(0,(round(grits.posy*10)/10-round(grits.Tradius*10)/10));
    grits.rightbounds=min(Surf_l,round(grits.posy*10)/10+round(grits.Tradius*10)/10);
end
%%
Rarea_all = [];
proh_all=[];
outline_all=[];
% ac_Rarea_all=[];
rg_all = zeros(numgrits,1);
% temp = 0;
%%
if isfile(['gprofile_temp\' FileName '_temp.csv'])
    delete(['gprofile_temp\' FileName '_temp.csv']);
end
%%
for grit_n = 1:numgrits
    rg = grits.Tradius(grit_n); % round(grits.Tradius(grit_n)*10)/10;
    rg_all(grit_n) = rg;
    if mode==0
        LFB=find(wheel_y<=grits.lowbounds(grit_n),1,'last');
        RB=find(wheel_y>=grits.highbounds(grit_n),1,'first');
        LB=find(wheel_x<=grits.leftbounds(grit_n),1,'last');
        HB=find(wheel_x>=grits.rightbounds(grit_n),1,'first');
        
        if isempty(LB)
            LB=1;
        end
    end
    %%
    [grit_P, ~, ~, Rarea] = getGritShape(rg,GeoParam,res);
    GritsProfile=[GritsProfile; {grit_P}];
    %%
    % temp = temp + ConeAngle;
    Rarea_all = [Rarea_all Rarea];
    %%
    outline=max(grit_P);
    proh_temp=max(outline);
    % ac_Rarea_all=[ac_Rarea_all,ActiveRarea];
    proh_all=[proh_all; proh_temp];
    outline=[outline , NaN(1,200-length(outline))];
    outline_all=[outline_all;outline];
    if mode==0
        for x_i=LB:HB
            for y_i=LFB:RB
                relx=wheel_x(x_i)-round(grits.posy(grit_n)/res)*res;
                rel_xi=round(relx/res+rg/res)-1;
                rel_xi=max(rel_xi,1);
                rely=wheel_y(y_i)-round(grits.posx(grit_n)/res)*res;
                rel_yi=round(rely/res+rg/res)-1;
                rel_yi=max(rel_yi,1);
                wheel_h(y_i,x_i)=max(wheel_h(y_i,x_i),grit_P(rel_yi,rel_xi));
            end
        end
    end
end
%%
% ConeAngle = temp*180/(numgrits*pi);
% GeoParam.ConeAngle = ConeAngle;
if GeoParam.Shape == 3
    GeoParam.Rarea = mean(Rarea_all);
end
%%
if mode==0
    %%
    figure;
    draw_x=0:1:Surf_l;
    draw_y=0:1:Surf_w;
    draw_h=wheel_h(1:1/res:1/res*length(draw_y),1:1/res:1/res*length(draw_x));
    surf(draw_x,draw_y,draw_h,'Linestyle','none');axis equal;
    title('wheel topography')
    % R_m=mean(mean(wheel_h));
    % Ra=mean(mean(abs(wheel_h-ones(y_upper+1,x_upper+1).*R_m)));
    % Rd=max(max(wheel_h))-min(min(wheel_h));
    % T={'R_m' 'Ra' 'Rd';R_m,Ra,Rd};
    disp('Wheel specs:');
    Surf_area=Surf_l*Surf_w;
    C_real=numgrits/Surf_area*10e6;
    C_0=1.29*10e5*20^-1.6;
    CPD={'Creal',C_real,'C0',C_0};
    disp(CPD);
    print([FileName '-wheel.jpg'], '-djpeg' );
    close gcf;
    %SurfRoughANA(wheel_h);
    GeoParam.MeanProh = mean(proh_all,'all');
    % GeoParam.MeanActiveRarea = mean(ac_Rarea_all,'all');
    %%
    figure;
    histogram(proh_all);
    title(['Proh all: ' num2str(GeoParam.MeanProh)]);
    writematrix(proh_all,[FileName '-proh.csv']);
    print([FileName '-phdist.jpg'], '-djpeg' );
    close gcf;
    %%
    figure;
    histogram(rg_all);
    title('rg all');
    writematrix(rg_all,[FileName '-rg.csv']);
    print([FileName '-rgdist.jpg'], '-djpeg' );
    close gcf;
    %     %%
    %     figure;
    %     histogram(ac_Rarea_all);
    %     writematrix(ac_Rarea_all,[FileName '-ac_Rarea.csv']);
    %     title(['Active Rarea all: ' num2str(GeoParam.MeanActiveRarea)]);
    %     print([FileName '-ac_Rarea.jpg'], '-djpeg' );
    %     close gcf;
end
%%
% T= array2table(outline_all);
% writetable(T,[filename '_gritols.csv']);
% grits.hw_all=hw_all;
% grits.orim_all=orim_all;
% grits.r_angle_all=r_angle_all;
grits.outlines = outline_all;
T = struct2table(grits);
writetable(T,[FileName '.csv']);
writecell(GritsProfile,[FileName '-gprofile_temp.csv'])
end
