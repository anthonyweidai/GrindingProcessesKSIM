function [grit_profile_all]=whl_generation(mode,grits,filename,geoparam)
%% geometrical parameters
% R = 10;
%%
% grit_list=readtable([filename '.csv']);
% grits=table2struct(grit_list,'ToScalar',true);
% grits=bubbleSimulator()
numgrits=size(grits.Tradius,1);

Surf_l=fix(max(grits.posy));
Surf_w=fix(max(grits.posx));
mode=0;
grit_profile_all={};

if mode==1
    
else
    mode=0;
end
%----------------------------------------
Surf_res=.2;
%----------------------------------------
if mode==0
    x_upper=Surf_l/Surf_res;
    y_upper=Surf_w/Surf_res;
    wheel_x=0:Surf_res:Surf_l;
    wheel_y=0:Surf_res:Surf_w;
    wheel_h=zeros(y_upper+1,x_upper+1);
    
    grits.lowbounds=max(0,round(grits.posx*10)/10-round(grits.Tradius*10)/10);
    grits.highbounds=min(Surf_w,round(grits.posx*10)/10+round(grits.Tradius*10)/10);
    grits.leftbounds=max(0,(round(grits.posy*10)/10-round(grits.Tradius*10)/10));
    grits.rightbounds=min(Surf_l,round(grits.posy*10)/10+round(grits.Tradius*10)/10);
    
end

proh_all=[];
outline_all=[];
if isfile(['gprofile_temp\' filename '_temp.csv'])
    delete(['gprofile_temp\' filename '_temp.csv']);
end

for grit_n = 1:numgrits
    rad=round(grits.Tradius(grit_n)*10)/10;
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
    grit_P=get_gritshape(rad,geoparam,Surf_res); 
    grit_profile_all=[grit_profile_all; {grit_P}];
    
    %%
    outline=max(grit_P);
    proh_temp=max(outline);
    proh_all=[proh_all; proh_temp];
    outline=[outline , NaN(1,200-length(outline))];
    outline_all=[outline_all;outline];
    if mode==0
        for x_i=LB:HB
            for y_i=LFB:RB
                relx=wheel_x(x_i)-round(grits.posy(grit_n)/Surf_res)*Surf_res;
                rel_xi=round(relx/Surf_res+rad/Surf_res)-1;
                rel_xi=max(rel_xi,1);
                rely=wheel_y(y_i)-round(grits.posx(grit_n)/Surf_res)*Surf_res;
                    rel_yi=round(rely/Surf_res+rad/Surf_res)-1;
                    rel_yi=max(rel_yi,1);
                    wheel_h(y_i,x_i)=max(wheel_h(y_i,x_i),grit_P(rel_yi,rel_xi));
            end
        end
    end
end
if mode==0
    figure;%
    draw_x=0:1:Surf_l;
    draw_y=0:1:Surf_w;
    draw_h=wheel_h(1:1/Surf_res:1/Surf_res*length(draw_y),1:1/Surf_res:1/Surf_res*length(draw_x));
    surf(draw_x,draw_y,draw_h,'Linestyle','none');axis equal;%tight;
    % R_m=mean(mean(wheel_h));
    % Ra=mean(mean(abs(wheel_h-ones(y_upper+1,x_upper+1).*R_m)));
    % Rd=max(max(wheel_h))-min(min(wheel_h));
    % T={'R_m' 'Ra' 'Rd';R_m,Ra,Rd};
    disp('Wheel specs:');
    Surf_area=Surf_l*Surf_w;
    C_real=numgrits/Surf_area*10e6;
    C_0=1.29*10e5*2^-1.6;
    CPD={'Creal',C_real,'C0',C_0};
    disp(CPD);
    print([filename '-wheel.jpg'], '-djpeg' );
    close gcf;
    %SurfRoughANA(wheel_h);
%     figure;
%     histogram(hw_all);
    figure;
    histogram(proh_all);
    print([filename '-phdist.jpg'], '-djpeg' );
    close gcf;
end
% T= array2table(outline_all);
% writetable(T,[filename '_gritols.csv']);
% grits.hw_all=hw_all;
% grits.orim_all=orim_all;
% grits.r_angle_all=r_angle_all;
grits.outlines=outline_all;
T= struct2table(grits);
writetable(T,[filename '.csv']);
writecell(grit_profile_all,[filename 'gprofile_temp.csv'])
end
