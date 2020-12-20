% function [grit_profille_all]=montecarlo(filename,numBubbles,geoparam)
%% use Monte Carlo algorithm to generate the distribution of abrasive grains
%% parameters
%%%%%%%%%%
mu=10;sigma=0.1;
%%%%%%%%%%
numBubbles = 1000;     % number of bubbles
MuRadius=mu;       % minimum radius
SigRadius=sigma;      % maximum radius
MaxSep=mu*0.8;         % maximum Separation distance
MinSep=mu*0.1;           % minimum Separation distance
GrdToollength = 2000;
GrdToolwidth = 500;

numcolomn = floor(GrdToolwidth/(2*mu));
Nsincol = floor(numBubbles/numcolomn);
Ntotal = Nsincol*numcolomn;
%% generate bubbles and initialise
blockbound = zeros(50,2);
blockbound(:,1) = reshape(repmat(sort(0:100:400)',1,10),1,50);
blockbound(:,2) = reshape(repmat(sort(100:100:500)',1,10),1,50);
blockbound(:,3) = reshape(repmat(sort(0:200:1800),5,1),1,50);
blockbound(:,4) = reshape(repmat(sort(200:200:2000),5,1),1,50);
bubbles.pos = zeros(Ntotal,2);
bubbles.Tradius=normrnd(MuRadius,SigRadius,[Ntotal,1]);
bubbles.radius=bubbles.Tradius+rand(numBubbles,1)*MaxSep+MinSep;
bubbles.blockflag1 = zeros(Ntotal,1);
bubbles.blockflag2 = zeros(Ntotal,1);
bubbles.numcount = 0;
%% monte carlo generation
figure;
axis equal;drawnow;
bubbles = montecar_update(bubbles,blockbound);

circles(bubbles.pos(:,1),bubbles.pos(:,2),bubbles.Tradius);
cr=numBubbles*1e6/(max(bubbles.pos(:,1))*max(bubbles.pos(:,2)));
title(cr);axis equal;drawnow;
print([num2str(numBubbles) '-cr.jpg'], '-djpeg' );
savefig(num2str(numBubbles))
% bubbles.pos=roundn(bubbles.pos,-1);
% grits.posx=bubbles.pos(:,1);
% grits.posy=bubbles.pos(:,2);
% grits.Tradius=roundn(bubbles.Tradius,-3);
% if numBubbles>=2000
%     index=find((grits.posy<500).*(grits.posx<80).*(grits.posx>1e-7).*(grits.posy>1e-7));
%     grits.posx=grits.posx(index);
%     grits.posy=grits.posy(index);
%     grits.Tradius=grits.Tradius(index);
% end
% T= struct2table(grits); % convert the struct array to a table
% sortedT =sortrows(T, 'posy'); % sort the table by 'DOB'
% % %%
% cr=length(grits.posx)/(max(grits.posx)*max(grits.posy));
% disp(cr);
% writetable(sortedT,[num2str(numBubbles) '.csv']);