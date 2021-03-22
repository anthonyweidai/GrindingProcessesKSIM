function [MaxStress, MeanStress] = stressPlot(FileName, H, E, v, f, res, BField)
%% Plot save stress images
[Lsurf,WSurf] = size(BField);
%% material properties
% sigma_s=0.253e-3; %shear strength 0.253GPa
% sigma_y=3.5e-3; %yield strength 3.5GPa
%% Initializing
h_surf = (  30  )/res;        % total height of field
z_depth = (  5  );            % depth of field
w_clr = 0.1*WSurf;
rs_surf = zeros(7,WSurf+2*w_clr,h_surf);
%% Start generating stress field
for l_i = floor(Lsurf/2)%:Lsurf
    for w_i = 1:WSurf
        b_i = BField(l_i,w_i);
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
        sigma_d = [rs_surf(1,x_i,z_i),rs_surf(4,x_i,z_i),rs_surf(5,x_i,z_i);rs_surf(4,x_i,z_i),rs_surf(2,x_i,z_i),rs_surf(6,x_i,z_i);rs_surf(5,x_i,z_i),rs_surf(6,x_i,z_i),rs_surf(3,x_i,z_i)];
        [sigma_maxps,~,~] = cal_sigma(sigma_d);
        rs_surf(7,x_i,z_i) = sigma_maxps;
    end
end
%%
figure;
rs_s = reshape(rs_surf(7,:,:),size(rs_surf,2),size(rs_surf,3))';
rs_s = rs_s(:,w_clr:w_clr+WSurf-1)/H;
contour(res:res:size(rs_s,2)*res,-res:-res:size(rs_s,1)*-res,rs_s,[ 5 2 1 0.5 0.2 0.1 0]);
c = colorbar;
c.Label.String = '\sigma/GPa';
% xlabel('Width/\mum'),ylabel('Depth/\mum')
xlabel('宽度/\mum'),ylabel('深度/\mum')
savefig([FileName '-StressField.fig']);
print([FileName '-StressField.jpg'], '-djpeg' );
close gcf
%%
rs_mean = mean(rs_s,2);
figure;
plot(-res:-res:size(rs_s,1)*-res,rs_mean','k');
% xlabel('Width/\mum'),ylabel('\sigma/GPa')
xlabel('深度/\mum'),ylabel('\sigma/GPa')
savefig([FileName '-MeanStressField.fig']);
print([FileName '-MeanStressField.jpg'], '-djpeg' );
close gcf
MaxStress = max(rs_mean);
MeanStress = mean(rs_mean);
end
