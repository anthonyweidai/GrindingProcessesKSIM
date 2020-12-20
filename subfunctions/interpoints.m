
function [nodes_x,nodes_y,nodes_z] = interpoints(nodes_x,nodes_y,nodes_z,d,nump)
%% interpolation, d involves several points on the desired curve
nump(~exist('nump','var')) = 5;% parameter does not exist, so default it to something
CS = cat(1,0,cumsum(sqrt(sum(diff(d,[],1).^2,2))));
dd = interp1(CS, d, unique([CS(:)' linspace(0,CS(end),nump)]),'PCHIP');
nodes_x = [nodes_x dd(:,1)'];
nodes_y = [nodes_y dd(:,2)'];
nodes_z = [nodes_z dd(:,3)'];
end

