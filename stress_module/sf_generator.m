function sf_generator()
rs_mean_all=[];
% for vw=100000:100000:600000
filename=['M:/GrdData_old/RSigma/CY1tgw30kd0Sgap0.5Rgap3w7FT0RAM1Rarea0.7Ssg0Hsg0Rsg0.1vw200000-rs_b_dist'];
b_field=readtable([filename '.csv']);
b_field=table2array(b_field,'ToScalar',true);
[l_surf,w_surf]=size(b_field);
%%
%material properties
H=7.6e-3; %Pa, 7.6GPa=7.6e-3N/um2^
sigma_s=0.253e-3; %shear strength 0.253GPa
sigma_y=3.5e-3; %yield strength 3.5GPa
E=83e-3;
v=0.203;
f=0.108;
%%
%initializing
res=0.2;
h_surf=(  30  )/res;        %total height of field
z_depth=(  5  );            %depth of field
w_clr=0.1*w_surf;
rs_surf=zeros(7,w_surf+2*w_clr,h_surf);
%%
%start generating stress field
for l_i = 1%:l_surf
    for w_i = 1:w_surf
        b_i = b_field(l_i,w_i);
        if b_i == 0
            continue 
        else
            B_fieldstrength = f*3*E*b_i^2/8/(1-2*v)/(1+v);
            for x_i = w_i+w_clr-round(2*b_i)/res:w_i+w_clr+round(2*b_i)/res
                for z_i = 1:size(rs_surf,3)
                    sigma_d=getblister(abs(x_i-w_clr-w_i)*res,0,(z_i+z_depth)*-res,B_fieldstrength);
                    rs_surf(1,x_i,z_i)=rs_surf(1,x_i,z_i)+sigma_d(1,1);
                    rs_surf(2,x_i,z_i)=rs_surf(2,x_i,z_i)+sigma_d(2,2);
                    rs_surf(3,x_i,z_i)=rs_surf(3,x_i,z_i)+sigma_d(3,3);
                    rs_surf(4,x_i,z_i)=rs_surf(4,x_i,z_i)+sigma_d(1,2);
                    rs_surf(5,x_i,z_i)=rs_surf(5,x_i,z_i)+sigma_d(1,3);
                    rs_surf(6,x_i,z_i)=rs_surf(6,x_i,z_i)+sigma_d(2,3);
                end
            end
        end
    end
end
for x_i = 1:size(rs_surf,2)
    for z_i = 1:size(rs_surf,3)
        sigma_d=[rs_surf(1,x_i,z_i),rs_surf(4,x_i,z_i),rs_surf(5,x_i,z_i);rs_surf(4,x_i,z_i),rs_surf(2,x_i,z_i),rs_surf(6,x_i,z_i);rs_surf(5,x_i,z_i),rs_surf(6,x_i,z_i),rs_surf(3,x_i,z_i)];
        [sigma_maxps,~,~]=cal_sigma(sigma_d);
        rs_surf(7,x_i,z_i)=sigma_maxps;
    end
end

figure;
rs_s=reshape(rs_surf(7,:,:),size(rs_surf,2),size(rs_surf,3))';
rs_s=rs_s(:,w_clr:w_clr+w_surf-1)/H;
contour(res:res:size(rs_s,2)*res,-res:-res:size(rs_s,1)*-res,rs_s,[ 5 2 1 0.5 0.2 0.1 0]);
rs_mean=mean(rs_s,2);
rs_mean_all=[rs_mean_all, rs_mean];
% figure;
% plot(-res:-res:size(rs_s,1)*-res,rs_mean);
% title(['mean:' num2str(rs_mean) ' |dev:' num2str(rs_dev)]);
% Fn=0.001;
% x=0;
% yi=0;zi=0;
% sigma_11=[];sigma_12=[];sigma_13=[];sigma_22=[];sigma_23=[];sigma_33=[];
% for y = -3:0.1:3
%     yi=yi+1;
%     for z = 0:-0.1:-5
%         zi=zi+1;
%         sigma_d=get_sigma(x,y,z,1,Fn);
%         sigma_11(yi,zi)=sigma_d(1,1);
%         sigma_22(yi,zi)=sigma_d(2,2);
%         sigma_33(yi,zi)=sigma_d(3,3);
%         sigma_21(yi,zi)=sigma_d(2,1);
%         sigma_31(yi,zi)=sigma_d(3,1);
%         sigma_32(yi,zi)=sigma_d(3,2);
%     end
% end
% writematrix([sigma_11;sigma_12;sigma_13;sigma_22;sigma_23;sigma_33],'blisterstress.csv');
% end
% rs_mean_all=rs_mean_all';
figure;
% plot(-res:-res:size(rs_s,1)*-res,rs_mean_all(1,:),'k',-res:-res:size(rs_s,1)*-res,rs_mean_all(2,:),'b',-res:-res:size(rs_s,1)*-res,rs_mean_all(3,:),'r',-res:-res:size(rs_s,1)*-res,rs_mean_all(4,:),'g',-res:-res:size(rs_s,1)*-res,rs_mean_all(5,:),'y',-res:-res:size(rs_s,1)*-res,rs_mean_all(6,:),'k-.');
plot(-res:-res:size(rs_s,1)*-res,rs_mean_all(1,:),'k');
end
