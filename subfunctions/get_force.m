function [F_n,F_t]=get_force(d_i,A_n,A_t,Rarea)%
%% by default
% d_i=0.0383;
% A_n=19;
% A_t=1.3;
% Rarea=0.5;
g_radius=10;
a=1;
alpha=atan((a*(1-Rarea^0.5)/2/a))/pi*180;
H=7.6e-3;%N/um2
E=84.5e-3;%N/um2
v=0.203;
sigma_s=0.253e-3; %shear strength 0.253GPa
sigma_y=3.5e-3; %yield strength 3.5GPa
D_grit=g_radius*Rarea^0.5;
u_a=pi/2*sigma_s/sigma_y;
u_a=0.4;
u_p=2/pi*((g_radius/D_grit)^2*asin(D_grit/g_radius)-((g_radius/D_grit)^2-1)^0.5);
%% d_crit_pl

k_pc=0.4;
d_crit_pl=(1-v^2)*D_grit/E*k_pc*H;
d_crit_pl=0.075;
%% d_crit_cut
rho=2;% grit edge radius, um
[theta_a,beta_a]=get_shearangle(alpha);
theta_a=theta_a/180*pi;
beta_a=beta_a/180*pi;
d_crit_cut=rho*(1-cos(pi/4-(beta_a/2)));
d_crit_cut=0.4;
%% force cal
mode=1;
if mode==1
if d_i<d_crit_pl %% rubbing
    F_n=D_grit*d_i*E/(1-v^2);
    F_t=F_n*u_a;
elseif d_i<d_crit_cut %% plowing
    F_n=H*(D_grit+g_radius)/2*d_i+D_grit*(d_i)*E/(1-v^2);
    F_t=D_grit*(d_i)*E/(1-v^2)*u_a+H*(D_grit+g_radius)/2*d_i*u_p;
else %% cutting
    tao=1.5e-3;%1.5e-3;%n/um2
    F_n=tao*(D_grit+g_radius)/2*d_i*sin(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*d_i*E/(1-v^2);
    F_t=tao*(D_grit+g_radius)/2*d_i*cos(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*d_i*E/(1-v^2)*u_a;
end

elseif mode==2
if d_i<d_crit_pl %% rubbing
    F_n=D_grit*d_i*E/(1-v^2);
    F_t=F_n*u_a;
elseif d_i<d_crit_cut %% plowing
    F_n=H*A_n*(d_i-d_crit_pl)/(d_crit_cut-d_crit_pl)+D_grit*(d_i)*E/(1-v^2);
    F_t=D_grit*(d_i)*E/(1-v^2)*u_a+H*A_n*u_p*(d_i-d_crit_pl)/(d_crit_cut-d_crit_pl);
else %% cutting
    tao=1.5e-3;%1.5e-3;%n/um2
    F_n=tao*A_t*sin(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*d_i*E/(1-v^2);
    F_t=tao*A_t*cos(beta_a-alpha)/(sin(theta_a)*cos(beta_a-alpha+theta_a))+D_grit*d_i*E/(1-v^2)*u_a;
end

end