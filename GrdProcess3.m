function GrdProcess3(batnum,FOI,sepparam,geoparam)
warning off;
%% defualt parameters
cof_cal_mode=2; % 0-none; 1 -simplified mode; 2-accurate mode
workpiece_length=500;   %the length of a workpiece
workpiece_width=80;     %max(grits.posx);
%%%%%% seperation parameters
sepparam.wheel_type(~isfield(sepparam,'wheel_type'))=2;   % 1-random; 2-tgw
if sepparam.wheel_type == 2
    sepparam.theta(~isfield(sepparam,'theta')) = 80;   % line tilt angle:30 40 50 60 70 80
    sepparam.SepGap(~isfield(sepparam,'SepGap')) = 0.5; % column gap: 0.5,1,3,5
    sepparam.RowGap(~isfield(sepparam,'RowGap')) = 3;   % row gap: 1,3,5,7
    sepparam.k_dev(~isfield(sepparam,'k_dev')) = 0;    % position deviation para: 1,3,5,7
end
%%%%%% geometrical parameters
geoparam.shape(~isfield(geoparam,'shape')) = 1;
geoparam.trim_h(~isfield(geoparam,'trim_h')) = 0;
geoparam.omega(~isfield(geoparam,'omega')) = 3;
geoparam.h2w_ratio(~isfield(geoparam,'h2w_ratio')) = 1;
geoparam.Rarea(~isfield(geoparam,'Rarea')) = 0.1;
geoparam.RA_mode(~isfield(geoparam,'RA_mode')) = 0;
geoparam.sigmah(~isfield(geoparam,'sigmah')) = 0.1;
geoparam.sigmasw(~isfield(geoparam,'sigmasw')) = 0.1;
geoparam.fillet_mode(~isfield(geoparam,'fillet_mode')) = 0;

premise = cell2mat(struct2cell(geoparam))';
%%
if sepparam.wheel_type==1
    num_grits=1500;
    premise = [num_grits, premise];
    filename = get_filename(num_grits, batnum, sepparam, geoparam, FOI);
    [grit_profile_all]=montecarlo(filename,num_grits,geoparam);
else
    num_grits=2400; %only recommend 2k and 2.4k
    temp = rmfield(sepparam,'wheel_type');
    premise = [num_grits,cell2mat(struct2cell(temp))',premise];
    filename = get_filename(num_grits, batnum, sepparam, geoparam, FOI);
    [grit_profile_all]=TGW_generator(filename,num_grits,sepparam,workpiece_length,workpiece_width,geoparam);
end
[Ra, C_grits]=GrindingProcess(filename,grit_profile_all,cof_cal_mode,workpiece_length,workpiece_width);
writematrix([premise C_grits Ra],['UT_data\\' FOI '\\' 'w' num2str(sepparam.wheel_type) 'batch_' num2str(batnum) '_premise.csv'],'WriteMode','append');
end
%% list of functions
%   GrdProcess2
%-------------------------------step
%1  - TGW_generator
%   -- wheel_generator
%   === get_octacube.m
%1  - bubbleSimulator_cluster
%   -- updatePosition
%   -- wheel_generator
%   === get_octacube.m
%-------------------------------step
%2  - GrindingProcess   % simulation process
%   -- COF_CAL