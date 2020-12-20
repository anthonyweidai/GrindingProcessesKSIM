function Ra=SurfRoughANA(surf)
[w,h]=size(surf);
lb_w=floor(0.1*w);
% hb_w=1000;%floor(0.33*w);
hb_w=floor(0.9*w);
lb_h=floor(0.1*h);
hb_h=floor(0.9*h);

sample_surf=surf(lb_w:hb_w,lb_h:hb_h);
R_m=mean(mean(sample_surf));
[y_upper,x_upper]=size(sample_surf);
Ra=mean(mean(abs(sample_surf-ones(y_upper,x_upper).*R_m)));
Rd=max(max(sample_surf))-min(min(sample_surf));
SR={'R_m' 'Ra' 'Rd';R_m,Ra,Rd};
disp(SR);
end