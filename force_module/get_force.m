function [F_n,F_t]=get_force(H,E,v,u_a,temp_uct,area_n,area_t,Rarea)
%%%% 
%% by default
% d_i=0.0383;
% A_n=19;
% A_t=1.3;
% Rarea=0.5;
g_radius=10;
a=1;
Rarea(Rarea <= 1e-7) = 0.0001;
alpha=atan((a*(1-sqrt(Rarea))/2/a))/pi*180;
D_grit=g_radius*sqrt(Rarea);
% u_a=pi/2*sigma_s/sigma_y;
% u_a=0.4;
u_p=2/pi*((g_radius/D_grit)^2*asin(D_grit/g_radius)-((g_radius/D_grit)^2-1)^0.5);
%% d_crit_pl
k_pc=0.4;
d_crit_pl=(1-v^2)*D_grit/E*k_pc*H;
% d_crit_pl=0.075;
%% d_crit_cut
rho=2;% grit edge radius, um
[theta_a,beta_a]=get_shearangle(alpha);
theta_a=theta_a/180*pi;
beta_a=beta_a/180*pi;
d_crit_cut=rho*(1-cos(pi/4-(beta_a/2)));
% d_crit_cut=0.6;
%% force cal
mode=1;
if mode==1
    if temp_uct<d_crit_pl %% rubbing
        F_n=D_grit*temp_uct*E/(1-v^2);
        F_t=F_n*u_a;
    elseif temp_uct<d_crit_cut %% plowing
        F_n=H*(D_grit+g_radius)/2*temp_uct+D_grit*(temp_uct)*E/(1-v^2);
        F_t=D_grit*(temp_uct)*E/(1-v^2)*u_a+H*(D_grit+g_radius)/2*temp_uct*u_p;
    else %% cutting
        tao=1.5e-3;%1.5e-3;%n/um2
        F_n=tao*(D_grit+g_radius)/2*temp_uct*sin(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*temp_uct*E/(1-v^2);
        F_t=tao*(D_grit+g_radius)/2*temp_uct*cos(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*temp_uct*E/(1-v^2)*u_a;
    end
    
elseif mode==2
    if temp_uct<d_crit_pl %% rubbing
        F_n=D_grit*temp_uct*E/(1-v^2);
        F_t=F_n*u_a;
    elseif temp_uct<d_crit_cut %% plowing
        F_n=H*area_n*(temp_uct-d_crit_pl)/(d_crit_cut-d_crit_pl)+D_grit*(temp_uct)*E/(1-v^2);
        F_t=D_grit*(temp_uct)*E/(1-v^2)*u_a+H*area_n*u_p*(temp_uct-d_crit_pl)/(d_crit_cut-d_crit_pl);
    else %% cutting
        tao=1.5e-3;%1.5e-3;%n/um2
        F_n=tao*area_t*sin(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*temp_uct*E/(1-v^2);
        F_t=tao*area_t*cos(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*temp_uct*E/(1-v^2)*u_a;
    end
    
end
end