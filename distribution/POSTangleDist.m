function POSTangleDist()
filename='UT_data/EFrake/Bat1tgw60kd0Sgap0.5Rgap100w3Hsg0Ssg0Rsg0FT0RA0.1RAM0';
% filename='N2000_tgw80kd1Sgap0.5Rgap4-2';
% grit_list=readtable([filename '.csv']);
grits=table2array(readtable([filename '.csv']));
% grits=table2struct(grit_list,'ToScalar',true);
numgrits=size(grits,1);
posx=grits(:,1);
posy=grits(:,2);
radius=grits(:,3);
num_cutgrits=length(posx);

relPosx=repmat(posx',num_cutgrits,1)-repmat(posx,1,num_cutgrits);
relPosy=repmat(posy',num_cutgrits,1)-repmat(posy,1,num_cutgrits);
relDist=sqrt(relPosx.^2+relPosy.^2);
relDist(find(relDist==0))=10000;
%%%%%%%%%%%%%%%%%%%%%%%%
[minDist,i_minD]=min(relDist,[],1,'linear');
angleDist=atan(abs(relPosy(i_minD))./abs(relPosx(i_minD)))/pi*180;
%%%%%%%%%%%%%%%%%%%%%%%%
% [i_hori_sp]=find(abs(relPosy)<1);
% 
% x_hori_sp=abs(relPosx(i_hori_sp));
% [i_vert_sp]=find(abs(relPosx)<1);
% y_hori_sp=abs(relPosy(i_vert_sp));
%%
%plot the frequency spectrum using the MATLAB fft command
% figure;
% YfreqDomain = fft(filtered_posx); %take the fft of our sin wave, y(t)
% plot((1:50),abs(YfreqDomain(1:50))); %use abs command to get the magnitude
% %similary, we would use angle command to get the phase plot!
%we'll discuss phase in another post though!
%%%%%%%%%%%%%%%%%%%%%%%%
figure;
set(gcf,'position',[824 74 531 727]);
subplot(2,1,1);
histogram(angleDist);
title('angle distribution')
subplot(2,1,2);
histogram(minDist);

% title('min Distance distribution')
% histogram(minDist);
% title('min Distance distribution')