function [grits, GritsProfile,GeoParam] = ...
    montecarloGenerator(FileName, wheel_length, wheel_width, SepParam, GeoParam, res)
%% use Monte Carlo algorithm to generate the distribution of abrasive grains
%% parameters
%%%%%%%%%%
mu = 10;
%%%%%%%%%%
MuRadius=mu;       % minimum MuRadius
SigRadius=GeoParam.Sigmarg;      % maximum MuRadius
%% Self adaptive for different dimensions of wheel
num_grits = wheel_length*wheel_width / (4*MuRadius^2);
blocknum = floor(sqrt(num_grits));
divisors = factor(blocknum);
while 1
    len = length(divisors);
    if len == 1
        blocknum = blocknum - 1;
        divisors = factor(blocknum);
    elseif len == 2 
        break
    else
        temp1 = prod(divisors(1:ceil(len/2)));
        temp2 = prod(divisors(ceil(len/2)+1:end));
        divisors = [temp1, temp2];
        break
    end
end
x_blocknum = min(divisors);
y_blocknum = max(divisors);
temp1 = floor(wheel_width/x_blocknum*10)*0.1;
temp2 = floor(wheel_length/y_blocknum*10)*0.1;
%% Self adaptive bubbles number
numBubbles = round(num_grits*0.4);
%% generate bubbles and initialise
blockbound = zeros(blocknum,4);
blockbound(:,1) = reshape(repmat(sort(0:temp1:wheel_width-temp1)',1,y_blocknum),1,blocknum);
blockbound(:,2) = reshape(repmat(sort(temp1:temp1:wheel_width)',1,y_blocknum),1,blocknum);
blockbound(:,3) = reshape(repmat(sort(0:temp2:wheel_length-temp2),x_blocknum,1),1,blocknum);
blockbound(:,4) = reshape(repmat(sort(temp2:temp2:wheel_length),x_blocknum,1),1,blocknum);
bubbles.pos = zeros(numBubbles,2);
bubbles.Tradius = normrnd(MuRadius,SigRadius,[numBubbles,1]);
bubbles.radius = bubbles.Tradius + 0.15*MuRadius; % 10 seconds per generation
bubbles.blockflag1 = zeros(numBubbles,1);
bubbles.blockflag2 = zeros(numBubbles,1);
blockflag1_map = reshape(1:blocknum,[x_blocknum,y_blocknum]); % block = 35; block = floor(sqrt(num));
%% monte carlo generation
bubbles = montecarloUpdate(bubbles, blockbound, blockflag1_map, x_blocknum, y_blocknum);
%% laser frame
if SepParam.LSMode == 1 % to prevent from field theta is not exsited
bubbles = laserFrame(SepParam.theta, SepParam.RowGap, ...
    SepParam.SaveGap, wheel_length, wheel_width, bubbles);
end
% figure;
% axis equal;drawnow;
% circles(bubbles.pos(:,1),bubbles.pos(:,2),bubbles.Tradius);
% cr=numBubbles*1e6/(max(bubbles.pos(:,1))*max(bubbles.pos(:,2)));
% title(cr);axis equal;drawnow;
% print([num2str(numBubbles) '-cr.jpg'], '-djpeg' );
% savefig(num2str(numBubbles))
bubbles.pos=roundn(bubbles.pos,-1);
grits.posx=bubbles.pos(:,1);
grits.posy=bubbles.pos(:,2);
grits.Tradius=roundn(bubbles.Tradius,-3);
grits.Tradius=max(bubbles.Tradius,MuRadius-3*SigRadius);
grits.Tradius=min(bubbles.Tradius,MuRadius+3*SigRadius);

index=find((grits.posy<wheel_length).*(grits.posx<wheel_width).*(grits.posx>1e-7).*(grits.posy>1e-7));
grits.posx=grits.posx(index);
grits.posy=grits.posy(index);
grits.Tradius=grits.Tradius(index);
T= struct2table(grits); % convert the struct array to a table
sortedT =sortrows(T, 'posy'); % sort the table by 'DOB'
% %%
% cr=length(grits.posx)/(max(grits.posx)*max(grits.posy));
% disp(cr);
writetable(sortedT,[FileName '.csv']);
[GritsProfile, GeoParam] = wheelGeneration(1,grits,FileName,GeoParam,res);
end