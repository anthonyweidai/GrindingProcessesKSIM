%% simulation function
function [Ra,Ra_b,C_grit,F_n_steadystage,F_t_steadystage,num_mode,percent_mode]=GrindingProcess(filename,grits,grit_profile_all,cof_cal_mode,...
    workpiece_length,workpiece_width,Rarea)
% cycle=1;
% filename=['N2000_tgw80kd1-' num2str(cycle)];%tgw80kd1 bubbles_list_tgw60kd1-2
export_mode=0;
report_mode=2;
testmode=0;

%%
%material properties
H=7.6e-3; %Pa, 7.6GPa=7.6e-3N/um2^
sigma_s=0.253e-3; %shear strength 0.253GPa
sigma_y=3.5e-3; %yield strength 3.5GPa
E=83e-3;
v=0.203;
f=0.108;
%%
%reading and get grit data
%grit_list=readtable([filename '.csv'],'Range', 'A:F');
%grits=table2struct(grit_list,'ToScalar',true);
numgrits=size(grits.Tradius,1);

k_t=1;

%% grinding parameters
rpm=3000;               %wheel spinning speed, round/min
ds=30e3;                %diameter of a grd wheel, um
vw=600e3;               %feed speed, um/min
% vw=vw/60;
vs=floor(ds*pi*rpm/60);        %grd wheel line speed, um/s
dp=2;                 %input('R_m2dgmax:');
res=.2;                %resolution of all axis
%%
wheel_l=round(max(grits.posy));
%% simulation time
%step time can be adjusted accordingly, longer=better Ra, will reach plateu
% t_step=50e-5*k_t;%workpiece_length/vs;
%considering that the interval should be small enough, we now use fix time
%interval to prevent any type of unexpected problems.
% dt=2e-8*k_t;%t_step/t_interval;
active_dw=((dp)*1.05*(ds)*(1+vw/vs)^2)^0.5;
dy=res;%roundn((vs+vw)*dt,-3);
dt=floor(1e10*dy/(vs+vw))/1e10;
t_step=(workpiece_length+2*active_dw)/vw;
t_count=floor(t_step/dt);
k_t_cof=floor(t_count/100);
k_width=5e3/workpiece_width;
% workpiece_length=t_step*vw;
%%
%getting the outline of grits
grit_pool=[roundn(grits.posx,-1),roundn(grits.posy,-1),grits.Tradius];
% Copy_of_GrdWhl_generation(1,filename);
% grit_outline=table2array(readtable(filename,'Range', 'G:end','ReadVariableNames',false));

%%
%-initializing
% vitual grinding wheel generation

num_cycle=floor(t_step*(vs+vw)/wheel_l)+1;
v_i=0;
for c_i=1:num_cycle
    for g_i=1:numgrits
        if (c_i-1)*wheel_l+grits.posy(g_i)>t_step*(vs+vw)
            continue
        end
        v_i=v_i+1;
        vgrit(v_i,1)=g_i;
        vgrit(v_i,2)=round(grits.posx(g_i)/res)*res;
        vgrit(v_i,3)=(c_i-1)*wheel_l+grits.posy(g_i);
        vgrit(v_i,4)=vgrit(v_i,3)/vs*vw-active_dw;
        
    end
end
num_vgrits=length(vgrit);
% creating the ground surface
h_clearance=workpiece_width*0.1;
c_clr=h_clearance/res/2;
h_surf=zeros(workpiece_length/res,round((workpiece_width+h_clearance)/res));
rs_surf=zeros(workpiece_length/res,round((workpiece_width+h_clearance)/res));
hmax=zeros(num_vgrits,2);
t_tick=0;
% h_m=zeros(t_count,num_vgrits);
% area_chp=zeros(t_count,num_vgrits);
% area_n=0;
% uncut chip thickness
uct=zeros(floor(t_count/k_t_cof)+1,num_vgrits);
ucarea=zeros(floor(t_count/k_t_cof)+1,num_vgrits);
c_mode=zeros(floor(t_count/k_t_cof)+1,num_vgrits);
% friction COF
% u_a=pi/2*sigma_s/sigma_y;
% u_t=zeros(t_count,num_vgrits);
% u_sum=zeros(num_vgrits,1);
% u_aver=zeros(num_vgrits,1);
% u=zeros(floor(t_count/k_t_cof)+1,num_vgrits);
% Force
F_n=zeros(floor(t_count/k_t_cof)+1,num_vgrits);
F_t=zeros(floor(t_count/k_t_cof)+1,num_vgrits);
%%
g_shape=grit_profile_all;
for g_i=1:numgrits
    grit_outline{g_i}=-max(g_shape{g_i});
    grit_proh(g_i)=-min(cell2mat(grit_outline(g_i)));
end
g_proh_max=max(grit_proh);
dd=g_proh_max-dp;  

%%
%grinding process, calculating for each time step
for t_i=dt:dt:t_step
    t_tick=t_tick+1;
    wheel_location=vw*t_i-active_dw;
    vgrit(:,3)=round((vgrit(:,3)-dy)/res)*res;
for v_i=1:num_vgrits
    % if the grit.posy is outside of active_area, it is inactive
    if (-vgrit(v_i,3)<=max(0,(wheel_location-active_dw)))||(-vgrit(v_i,3)>=min( workpiece_length,(wheel_location+active_dw)))
        continue
    end
   
    % basic calculation of grit positions
    g_x=vgrit(v_i,2);
    g_y=-vgrit(v_i,3);
    g_y_lowest=vgrit(v_i,4);
    g_base_ori=(g_y-g_y_lowest)^2/(ds)/(1+vw/vs)^2;
    g_base=dd+g_base_ori;
    g_outline=cell2mat(grit_outline(vgrit(v_i,1)));
    h_temp=g_outline+g_base; 
    h_temp(find(h_temp>0))=0;
    
    % obtaining the calbound
    lbound=(g_x)/res+c_clr-fix(0.5*length(g_outline));
    hbound=(g_x)/res+c_clr-fix(0.5*length(g_outline))+length(g_outline)-1;
    
    %when two bound is within boundary of h_surf, start replacing
    h_origin=h_surf(round(g_y/res),lbound:hbound);
    h_grit=h_temp;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    miu_r=0.00; % elastic recover is 0
    h_surf(round(g_y/res),lbound:hbound)=h_origin-(h_origin-h_grit).*(h_grit<h_origin)*(1-miu_r);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     h_new=h_origin-(h_origin-h_grit).*(h_grit<h_origin)*(1-miu_r);
    temp_uct=max((h_origin-h_grit>0).*(h_origin-h_grit));
    temp_chparea=res*sum((h_origin-h_grit>0).*(h_origin-h_grit));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     stats_indented = 0;
    a_temp = sum(h_grit<h_origin)*0.2/2;
    alpha_temp = atan(a_temp^2/temp_chparea)/pi*180;
    b_temp = ( temp_chparea * ( 3*pi*( 1 - 2*v)*sigma_y + 2*3^0.5*E )/( pi*( 5 - 4*v )*sigma_y ) )^0.5;
%         if b_temp > 20
%             b_temp=b_temp;
%         end
%     indents = find(rs_surf(round(g_y/res),:)>0); % find all stress field on the same roll
%     for i = indents
%         b = rs_surf(round( g_y / res ), i);
% 
%         if abs( i - round( g_y / res ) ) < b/3 
%             rs_surf(round( g_y / res ), i) = ( b ^ 2 + b_temp ^ 2 ) ^ 0.5;
%             stats_indented = 1;
%             break
%         end
%     end
    b_prev = rs_surf( round( g_y / res ), round( g_x / res )  +c_clr);
    if b_prev == 0
        rs_surf( round( g_y / res ), round( g_x / res ) +c_clr) = b_temp;
    else
        rs_surf( round( g_y / res ), round( g_x / res ) +c_clr) = ( b_prev ^ 2 + b_temp ^ 2 ) ^ 0.5;
    end
    
    %recording hmax, logging cut mode data
%     h_m(t_tick,v_i)=temp_uct;
%     area_chp(t_tick,v_i)=temp_chparea;
    
    %% calculation of microinteration every k_t ticks
    if ~mod(round(t_i/dt),k_t_cof)
        t_ana_i=round(t_i/dt/k_t_cof);
        uct(t_ana_i,v_i)=temp_uct;
        ucarea(t_ana_i,v_i)=temp_chparea;
        if cof_cal_mode==0
            area_n=0; area_t=0;
        else
        g_shape_temp=cell2mat(g_shape(vgrit(v_i,1)));
        [area_t,area_n]=COF_CAL(g_shape_temp,g_base,h_origin);
        end

        [F_n_temp,F_t_temp]=get_force(temp_uct,area_n,area_t,Rarea);
%         F_n_temp=area_n*H
%         F_t_temp=u(t_ana_i,v_i)*area_n*H
        F_n(t_ana_i,v_i)=F_n_temp;
        F_t(t_ana_i,v_i)=F_t_temp;
        
        % hmax temporally
        hmax(v_i,1)=max(hmax(v_i,1),temp_uct);
        if hmax(v_i,1)==0
            %%%%%%%%%
            c_mode(t_ana_i,v_i)=0;
            continue
            %%%%%%%%%
        else
            if hmax(v_i,1)<0.1/5
                hmax(v_i,2)=1;
                c_mode(t_ana_i,v_i)=1;
            else
                if hmax(v_i,1)<0.6/5
                    hmax(v_i,2)=2;
                    c_mode(t_ana_i,v_i)=2;
                else
                    hmax(v_i,2)=3;
                    c_mode(t_ana_i,v_i)=3;
                end
            end
        end       
    end
end
end

%%
h_surf=h_surf(:,c_clr:c_clr+workpiece_width/res);
rs_surf=rs_surf(:,c_clr:c_clr+workpiece_width/res);
Ra=SurfRoughANA(h_surf);
Ra_b=SurfRoughANA(rs_surf);
C_grit=floor(numgrits/(max(grits.posx)/1000*max(grits.posy)/1000));

%%
%draw the final ground surface
if report_mode==0
else

if report_mode==1
    f=figure;
    fig=gcf;
    fig.Units='normalized';
    fig.OuterPosition=[0 0 1 1];

    surf_x=res:res:size(h_surf,2)*res;
    surf_y=res:res:size(h_surf,1)*res;
    surf(surf_x,surf_y,h_surf,'Linestyle','none');axis equal;title([filename '| Ra=' num2str(Ra)]);
    print([filename '-report.jpg'], '-djpeg' );

else
    %%
    figure('units','normalized','outerposition',[0 0 1 1]); %,'visible','off'
    subplot(2,2,1);

    surf_x=res:res:size(h_surf,2)*res;
    surf_y=res:res:size(h_surf,1)*res;
    surf(surf_x,surf_y,h_surf,'Linestyle','none');axis equal;title([filename '| Ra=' num2str(Ra)]);
    %%
    %the uct distribution
    subplot(2,2,2);
%     dist_uct=hmax(:,1);
    dist_uct=sum(uct,2);
    t_axis=0*dt:k_t_cof*dt:t_step;
    %histogram(dist_uct);

    c_mode_cut=sum(c_mode==3,2);
    c_mode_plg=sum(c_mode==2,2);
    c_mode_rub=sum(c_mode==1,2);
    c_mode_ina=sum(c_mode==0,2);
    c_mode_act=c_mode_cut+c_mode_plg+c_mode_rub;
    
    c_mode_sum=max(c_mode);
    num_mode=[sum(c_mode_sum==3) sum(c_mode_sum==2) sum(c_mode_sum==1) sum(c_mode_sum==0)];
    percent_mode=num_mode/num_vgrits;
    
    uct_aver=dist_uct./c_mode_act;
    yyaxis left;
    plot(t_axis,dist_uct,'k-',t_axis,c_mode_cut,'r-',t_axis,c_mode_plg,'g-',t_axis,c_mode_rub,'b-');
    yyaxis right;
    plot(t_axis,uct_aver,'k.-');
    title(['uct|' num2str(numgrits) ' grits|L-k:uct_{ttl};.-k:uct_{aver}|R-r:cut;-g:plg;-b:rub']);

    %%
    %cutting mode
    subplot(2,2,3);
    %active_grit_condition={'inactive' 'rubbing' 'ploughing' 'cutting'; cut_mode(1) cut_mode(2) cut_mode(3) cut_mode(4)};
%     disp(active_grit_condition);
%     pie(cut_mode);title(['mode|ina' num2str(cut_mode(1)) '/rub' num2str(cut_mode(2)) '/plg'  num2str(cut_mode(3)) '/cut' num2str(cut_mode(4)) '//ttl' num2str(numgrits)]);
%     
%     plot(1:num_vgrits,hmax(:,1),'k');title('uct vs grit #');
    plot(1:num_vgrits,hmax(:,1),'k');title('uct vs grit#-k| ucarea vs grit#-r ');%,1:num_vgrits,max(ucarea,[],1),'r'
    T=[t_axis' uct];
    writematrix(T,[filename '-uct.csv']);
    T=[t_axis' ucarea];
    writematrix(T,[filename '-ucarea.csv']);
    %friction
    subplot(2,2,4);
    %         u_sum=sum(u,1)';
    %         u_max=max(u,1)';
    %         u_aver=u_sum./roll_count;
    %         friction_sum=sum(u_aver);
    %         histogram(u_aver);title(['aver_friction|' num2str(numgrits) ' grits/ttl fric ' num2str(friction_sum) ]);
    %         print([filename '-report.jpg'], '-djpeg' );

    %%
    %force output
    F_n_total=sum(F_n,2);
    F_t_total=sum(F_t,2);
    lb_F=floor(0.35*t_count/k_t_cof);hb_F=floor(0.55*t_count/k_t_cof);
    F_n_steadystage=mean(F_n_total(lb_F:hb_F));
    F_t_steadystage=mean(F_t_total(lb_F:hb_F));
    %         figure;
    %         if size(u,1)==2501
    %             t_axis=0:dt:t_step;
    %         else
    t_axis=0*dt:k_t_cof*dt:t_step;

    plot(t_axis,F_n_total,'k-',t_axis,F_t_total,'r-');title(['GForce|red-tang;black-normal;(N vs s)|' filename '|' num2str(numgrits) ' grits'])
    %         print([filename '-GForce.jpg'], '-djpeg' );
    T=[t_axis' F_n_total F_t_total];
    writematrix(T,[filename '-GForce.csv']);
    T=[t_axis' F_n];
    writematrix(T,[filename '-GForce_n.csv']);
    T=[t_axis' F_t];
    writematrix(T,[filename '-GForce_t.csv']);

%     savefig([filename '-report.fig']);
    print([filename '-report.jpg'], '-djpeg' );
    close gcf;
    
    writematrix(h_surf,[filename '-gsurf.csv']);
    
    % 2
    figure('units','normalized','outerposition',[0 0 1 1]);
    dist_uct=hmax(:,1);
    histogram(dist_uct);
    print([filename '-ucthisto.jpg'], '-djpeg' );
    close gcf;
    
    % 3
    figure('units','normalized','outerposition',[0 0 1 1]);
    writematrix([vgrit hmax],[filename '-hmax.csv']);
    index_cut=find(hmax(:,2)==3);
    index_plow=find(hmax(:,2)==2);
    index_rub=find(hmax(:,2)==1);
%     index_ina=find(c_mode==0,0);
    stem3(grits.posx(vgrit(index_cut,1)),vgrit(index_cut,3),hmax(index_cut,1));
    hold on;
    stem3(grits.posx(vgrit(index_plow,1)),vgrit(index_plow,3),hmax(index_plow,1),'r');
    stem3(grits.posx(vgrit(index_rub,1)),vgrit(index_rub,3),hmax(index_rub,1),'g');
    savefig([filename '-uctdist.fig']);
    close gcf;

    % 4
    figure('units','normalized','outerposition',[0 0 1 1]);
    surf_x=res:res:size(h_surf,2)*res;
    surf_y=res:res:size(h_surf,1)*res;
    surf(surf_x,surf_y,rs_surf,'Linestyle','none');axis equal;title([filename '| Ra=' num2str(Ra_b)]);
    print([filename 'rsdist.jpg'], '-djpeg' );
    close gcf;
end
end
end
