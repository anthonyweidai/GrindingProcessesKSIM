function post_ana(filename)
%% reading files
% post processing 
filename='trapezoid/N2400_tgw60kd1Sgap0.5Rgap4w3Rhw1Rarea0.99FT0-UCT';
data_list=table2array(readtable([filename '.csv']));
Time_list=data_list(:,1)';
data_all=data_list(:,2:end);
grit_list=1:size(data_all,2);
DATA_dist=max(data_all);
Fn_timedist=sum(data_all,2)';

% figure;
% for g_i=2000:2050
%     plot(Time_list,data_all(:,g_i),'b');
%     hold on;
% end
% for g_i=1000:1050
%     plot(Time_list,data_all(:,g_i),'r');
%     hold on;
% end
% for g_i=1:50
%     plot(Time_list,data_all(:,g_i),'k');
%     hold on;
% end
%dump
figure;
plot(grit_list,DATA_dist,'k');
%%
% inputs should be area_n and area_t
% the two axes for these variables are respectively t_axis and g_i
% t_axis=k_t_cof*dt:k_t_cof*dt:t_step;
% g_i=1:numgrits;
% % other than that. the spatial ana also requires pos and rad of grits
% posx=grits.posx;
% posy=grits.posy;
% radius=grits.radius;
% % radius is actually useless, protrusion height is key
% proh=grits.proh;
% % therefore, the input should be struct[grits] and mat[area_n/t]
% 
% %%
% u_sum(g_i)=u_sum(g_i)+( u_t_temp )+( u_a*~~u_t_temp );
% u(t_ana_i,g_i)=u_t(t_ana_i,g_i)+(~~u_t(t_ana_i+1,g_i))*u_a;
% F_n(t_ana_i,g_i)=area_n*H;
% F_t(t_ana_i,g_i)=u(t_ana_i,g_i)*area_n*H;
% area_n=0;
% %% surf ground surface
% % figure('units','normalized','outerposition',[0 0 1 1],'visible','off');
% % subplot(2,2,1);
% % 
% % surf_x=0.1:0.1:size(h_surf,2)/10;
% % surf_y=0.1:0.1:size(h_surf,1)/10;
% % surf(surf_x,surf_y,h_surf,'Linestyle','none');axis equal;title([filename '| Ra=' num2str(Ra)]);
% %% uct dist along temporal dimension
% %the uct distribution
% subplot(2,2,2);
% dist_uct=hmax(:,1);
% dist_uct=sum(uct,2);
% t_axis=k_t_cof*dt:k_t_cof*dt:t_step;
% %histogram(dist_uct);
% 
% c_mode_cut=sum(c_mode==3,2);
% c_mode_plg=sum(c_mode==2,2);
% c_mode_rub=sum(c_mode==1,2);
% c_mode_ina=sum(c_mode==0,2);
% c_mode_act=c_mode_cut+c_mode_plg+c_mode_rub;
% 
% uct_aver=dist_uct./c_mode_act;
% yyaxis left;
% plot(t_axis,dist_uct,'k-',t_axis,c_mode_cut,'r-',t_axis,c_mode_plg,'g-',t_axis,c_mode_rub,'b-');
% yyaxis right;
% plot(t_axis,uct_aver,'k.-');
% title(['uct|' num2str(numgrits) ' grits|L-k:uct_{ttl};.-k:uct_{aver}|R-r:cut;-g:plg;-b:rub']);
% 
% for i=1:4
%     cut_mode(i)=sum(hmax(:,2)==i-1);
% end
% %% cutting mode dist
% subplot(2,2,3);
% active_grit_condition={'inactive' 'rubbing' 'ploughing' 'cutting'; cut_mode(1) cut_mode(2) cut_mode(3) cut_mode(4)};
% disp(active_grit_condition);
% pie(cut_mode);title(['mode|ina' num2str(cut_mode(1)) '/rub' num2str(cut_mode(2)) '/plg'  num2str(cut_mode(3)) '/cut' num2str(cut_mode(4)) '//ttl' num2str(numgrits)]);
% %friction
% subplot(2,2,4);
% %         u_sum=sum(u,1)';
% %         u_max=max(u,1)';
% %         u_aver=u_sum./roll_count;
% %         friction_sum=sum(u_aver);
% %         histogram(u_aver);title(['aver_friction|' num2str(numgrits) ' grits/ttl fric ' num2str(friction_sum) ]);
% %         print([filename '-report.jpg'], '-djpeg' );
% 
% %% grinding force along temporal dimension
% F_n_total=sum(F_n,2);
% F_t_total=sum(F_t,2);
% %         figure;
% %         if size(u,1)==2501
% %             t_axis=0:dt:t_step;
% %         else
% t_axis=k_t_cof*dt:k_t_cof*dt:t_step;
% 
% plot(t_axis,F_n_total,'k-',t_axis,F_t_total,'r-');title(['GForce|red-tang;black-normal;(N vs s)|' filename '|' num2str(numgrits) ' grits'])
% %         print([filename '-GForce.jpg'], '-djpeg' );
% T=[t_axis' F_n_total F_t_total];
% writematrix(T,[filename '-GForce.csv']);
% T=[t_axis' F_n];
% writematrix(T,[filename '-GForce_n.csv']);
% T=[t_axis' F_t];
% writematrix(T,[filename '-GForce_t.csv']);
% 
% print([filename '-report.jpg'], '-djpeg' );
