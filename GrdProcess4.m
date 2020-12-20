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

%% Main
function GrdProcess4(batnum,FOI,sepparam,geoparam)
warning off;
tic;
cycle = 1;
cof_cal_mode=2; % 0-none; 1 -simplified mode; 2-accurate mode
workpiece_length=1000;   %the length of a workpiece
workpiece_width=500;     %max(grits.posx);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
geoparam.Rarea(~isfield(geoparam,'Rarea')) = 0.5;
geoparam.Rsigma(~isfield(geoparam,'Rsigma')) = 0;
geoparam.RA_mode(~isfield(geoparam,'RA_mode')) = 0;
geoparam.sigmah(~isfield(geoparam,'sigmah')) = 0;
geoparam.sigmasw(~isfield(geoparam,'sigmasw')) = 0;
geoparam.fillet_mode(~isfield(geoparam,'fillet_mode')) = 0;
% geoparam.xi(geoparam.shape == 3 && ~isfield(geoparam,'xi')) = 0;
premise = cell2mat(struct2cell(geoparam))';
%%
if sepparam.wheel_type==1
    num_grits=1200;
    premise = [num_grits, premise];
    filename = get_filename(num_grits, batnum, sepparam, geoparam, FOI);
    [grits,grit_profile_all]=bubbleSimulator(filename, workpiece_length,...
    workpiece_width, num_grits,geoparam);
else
    num_grits=2400; %only recommend 2k and 2.4k
    temp = rmfield(sepparam,'wheel_type');
    premise = [num_grits,cell2mat(struct2cell(temp))',premise];
    filename = get_filename(num_grits, batnum, sepparam, geoparam, FOI);
    [grits,grit_profile_all]=TGW_generator(filename,sepparam,workpiece_length,workpiece_width,geoparam);
end
[Ra,C_grit,F_n_steadystage,F_t_steadystage,num_mode,percent_mode]=GrindingProcess(filename,grits,grit_profile_all,cof_cal_mode,workpiece_length,workpiece_width,geoparam.Rarea);
writematrix([convertCharsToStrings(char(datetime)) cycle premise Ra C_grit F_n_steadystage F_t_steadystage num_mode percent_mode],['UT_data\\' FOI '\\' 'w' num2str(sepparam.wheel_type) 'batch_' num2str(batnum) '_premise.csv'],'WriteMode','append');
toc;
end

function filename = get_filename(num_grits, batnum, sepparam, geoparam, FOI)
wheel_type = sepparam.wheel_type;
if wheel_type == 1
    if geoparam.shape == 2
        if geoparam.Rarea ~= 1
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N'  num2str(num_grits) 'RA' num2str(geoparam.Rarea)] ;
        else
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N'  num2str(num_grits)] ;
        end
    else
        filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N'  num2str(num_grits) ...
            'SH' num2str(geoparam.shape) 'w' num2str(geoparam.omega) 'hsg' num2str(geoparam.sigmah) ...
            'swsg' num2str(geoparam.sigmasw) 'FT' num2str(geoparam.fillet_mode) 'RA' num2str(geoparam.Rarea) ...
            'RAM' num2str(geoparam.RA_mode)] ;
    end
elseif wheel_type == 2
    if geoparam.shape == 2
        if geoparam.Rarea ~= 1
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N' num2str(num_grits) ...
                'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
                'Rgap' num2str(sepparam.RowGap) 'RA' num2str(geoparam.Rarea)] ;
        else
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N' num2str(num_grits) ...
                'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
                'Rgap' num2str(sepparam.RowGap)] ;
        end
    else
        filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N' num2str(num_grits) ...
            'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
            'Rgap' num2str(sepparam.RowGap) 'SH' num2str(geoparam.shape) 'w' num2str(geoparam.omega)  ...
            'hsg' num2str(geoparam.sigmah) 'swsg' num2str(geoparam.sigmasw) 'FT' num2str(geoparam.fillet_mode) ...
            'RA' num2str(geoparam.Rarea) 'RAM' num2str(geoparam.RA_mode)] ;
    end
end
end