function [grits,grit_profille_all]=bubbleSimulator(filename, sepparam, workpiece_length,...
    workpiece_width, num_grits, geoparam)
% [mu,sigma]=mesh2diameter(2500);
% filename='N2000_r1';
% cycle=1;
%%
% parameters
%%%%%%%%%%
mu=10;sigma=geoparam.Rsigma;
%%%%%%%%%%
numBubbles=num_grits;     % number of bubbles
MuRadius=mu;       % minimum radius
SigRadius=sigma;      % maximum radius
MaxSep=mu*0.8;         % maximum Separation distance
MinSep=mu*0.1;           % minimum Separation distance
% changes pack density significantly
k1=4;              % wall bounce constant
k2=20;              % spring constant
c=1;                % damping constant
cg=0.1;             % damping w.r.t. ground
g=0.2;                % gravity
Ts=0.005;           % simulation sampling time
damparea=0;
w_boundary=4;
w_gt=mu*50;
GrdToollength = workpiece_length*2;
GrdToolwidth = mu*50+w_boundary*2;
% generate bubbles and initialise
%bubbles.radius=rand(numBubbles,1)*(maxRadius-minRadius)+minRadius;
bubbles.Tradius=normrnd(MuRadius,SigRadius,[numBubbles,1]);
bubbles.radius=bubbles.Tradius+rand(numBubbles,1)*MaxSep+MinSep;
bubbles.mass=0.1*ones(numBubbles,1);
bubbles.pos=rand(numBubbles,2).*GrdToolwidth;
bubbles.pos(:,2)=bubbles.pos(:,2)*4; %4for 800,8for2k
bubbles.vel=zeros(numBubbles,2);

% offline computation
rr=repmat(bubbles.radius,1,numBubbles);
sumRadius=(rr+rr');

t=0;
% figure;
% circles(bubbles.pos(:,1),bubbles.pos(:,2),bubbles.Tradius);
% axis equal;drawnow;
% simulation starts
while t<5
    t=t+Ts;
    if t<5
        g=0.2/mu;
    else
        g=0.2/mu;
    end
    bubbles=updatePosition(bubbles,numBubbles,Ts,k1,k2,c,cg,g,GrdToolwidth,sumRadius,damparea);
    %     if ~mod(round(t/Ts),10)
    %         %disp(['dropping....',int2str(round(t/15*100)),'%' ])
    %     end
end
close gcf;
% print([filename '-cr.jpg'], '-djpeg' );
%% laser frame
if sepparam.LS_mode == 1 % to prevent from field theta is not exsited
bubbles = Laser_Frame(sepparam.theta, sepparam.RowGap, ...
    sepparam.SaveGap, GrdToollength, GrdToolwidth, bubbles);
end
%%
clf;
circles(bubbles.pos(:,1),bubbles.pos(:,2),bubbles.Tradius);

cr=numBubbles*1e6/(max(bubbles.pos(:,1))*max(bubbles.pos(:,2)));
title(cr);axis equal;drawnow;
%%
bubbles.pos=roundn(bubbles.pos,-1);
grits.posx=bubbles.pos(:,1);
grits.posy=bubbles.pos(:,2);
grits.Tradius=roundn(bubbles.Tradius,-3);
grits.Tradius=max(bubbles.Tradius,MuRadius-3*SigRadius);
grits.Tradius=min(bubbles.Tradius,MuRadius+3*SigRadius);

index=find((grits.posy<workpiece_length).*(grits.posx<w_gt+w_boundary).*(grits.posx>w_boundary));
grits.posx=grits.posx(index)-w_boundary;
grits.posy=grits.posy(index);
grits.Tradius=grits.Tradius(index);

T= struct2table(grits); % convert the struct array to a table
sortedT =sortrows(T, 'posy'); % sort the table by 'DOB'
%
cr=length(grits.posx)/(max(grits.posx)*max(grits.posy));
disp(cr);
% writetable(sortedT,[filename '-' num2str(cycle) '.csv']);
writetable(sortedT,[filename '.csv']);
grit_profille_all=whl_generation(1,grits,[filename],geoparam);

end

function bubbles=updatePosition(bubbles,numBubbles,Ts,k1,k2,c,cg,g,GrdToolwidth,sumRadius,damparea)
% consider elasticity, damping relative to ground and attraction to the centre
posx=bubbles.pos(:,1);
posy=bubbles.pos(:,2);
relPosx=repmat(posx',numBubbles,1)-repmat(posx,1,numBubbles);
relPosy=repmat(posy',numBubbles,1)-repmat(posy,1,numBubbles);
relDist=sqrt(relPosx.^2+relPosy.^2);
overlapDist=sumRadius-relDist;
overlapDist(1:numBubbles+1:numBubbles*numBubbles)=-inf;
velx=bubbles.vel(:,1);
vely=bubbles.vel(:,2);
relVelx=repmat(velx',numBubbles,1)-repmat(velx,1,numBubbles);
relVely=repmat(vely',numBubbles,1)-repmat(vely,1,numBubbles);

leftwallTouch=posx-bubbles.Tradius<0-damparea;
rightwallTouch=posx+bubbles.Tradius>GrdToolwidth+damparea;
bottomwallTouch=posy-bubbles.Tradius<0-damparea;
idsLW=find(leftwallTouch);
idsRW=find(rightwallTouch);
idsBW=find(bottomwallTouch);
overlapDistLW=bubbles.radius-posx;
overlapDistRW=bubbles.radius+posx-GrdToolwidth;
overlapDistBW=bubbles.radius-posy;
B=zeros(numBubbles,2);
B(idsLW,1)=leftwallTouch(idsLW).*overlapDistLW(idsLW)*k1;
B(idsRW,1)=rightwallTouch(idsRW).*-overlapDistRW(idsRW)*k1*0.1;
B(idsBW,2)=bottomwallTouch(idsBW).*overlapDistBW(idsBW)*k1;

% calculate forces and acceleration
N=overlapDist>0;
F=zeros(numBubbles,2);
C=zeros(numBubbles,2);
ids=find(sum(N,2)); % find balls that have at least one neighbour
% relative spring force
normedF=N(ids,:).*overlapDist(ids,:)./relDist(ids,:);
F(ids,1)=sum(normedF.*-relPosx(ids,:),2,'omitnan')*k2;
F(ids,2)=sum(normedF.*-relPosy(ids,:),2,'omitnan')*k2;
% wall obsorb the energy
F(idsLW,1)=F(idsLW,1)*0.1;
F(idsRW,1)=F(idsRW,1)*0;
F(idsBW,2)=F(idsBW,2)*0.1;
% relative damping force
C(ids,1)=sum(N(ids,:).*relVelx(ids,:),2,'omitnan')*c;
C(ids,2)=sum(N(ids,:).*relVely(ids,:),2,'omitnan')*c;
% ground damping and gravity force
Cg=-cg*bubbles.vel;
maxposy=max(posy);
G=-g*bubbles.pos;
G(:,1)=0;
for gi=1:size(G,1)
    if posy(gi)<maxposy*0.5
        G(gi,2)=0;
    else
        
        if posy(gi)>0.8*maxposy
            G(gi,2)=G(gi,2)*1;
            if numBubbles==2000
                G(gi,2)=G(gi,2)*0.2;
            end
        else
            if posy(gi)>0.9*maxposy
                G(gi,2)=G(gi,2)*4;
                if numBubbles==2000
                    G(gi,2)=G(gi,2)*0.2;
                end
            else
                G(gi,2)=0;%G(gi,2).*(posy(gi)/(0.8*maxposy));
            end
        end
    end
    
    
    
end

%[bubbles.pos(:,1),-g*bubbles.pos(:,2)*0.05];
accel=(F+C+Cg+B)./repmat(bubbles.mass,1,2)+G;

% update states
bubbles.pos=Ts*bubbles.vel+bubbles.pos;
bubbles.vel=Ts*accel+bubbles.vel;
end
