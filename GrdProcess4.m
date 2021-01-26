%%%% list of functions
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
%%
function GrdProcess4(cof_cal_mode, cycle, FOI, sepparam, geoparam)
warning off;
tic;
%%
workpiece_length = 1000;
workpiece_width = 500;     % max(grits.posx);
wheel_length = 10*workpiece_length;
wheel_width = workpiece_width;
vw = 200e3;               %feed speed, um/min
res=.2;              % surf resolution of all axis
%% Input parameters initialization
[sepparam, geoparam] = param_initialize(sepparam, geoparam);
%% Simplified mode won't calculate force, but the other will 
cof_cal_mode(geoparam.shape==2 || geoparam.shape==3) = 0; % 0-simplified mode 1-accurate mode
%% Generate grinding wheel
filename = get_filename(cycle, sepparam, geoparam, FOI, vw);
if sepparam.wheel_type == 1
    [grits,grit_profile_all]=bubbleSimulator(filename, wheel_length, wheel_width, geoparam, res);
elseif sepparam.wheel_type == 2
    [grits,grit_profile_all]=montecarlo(filename, wheel_length, wheel_width, sepparam, geoparam, res);
elseif sepparam.wheel_type == 3
    [grits,grit_profile_all]=TGW_generator(filename, wheel_length, wheel_width, sepparam, geoparam, res);
end
%% Kinematic simulation
Grd_output = GrindingProcess(filename,grits,grit_profile_all,cof_cal_mode,...
    workpiece_length,workpiece_width,wheel_length,...
    geoparam.Rarea,res,vw);
%% Record input and output variables
batch_info = array2table(convertCharsToStrings(char(datetime)),'VariableNames',{'datetime'});
batch_info = [batch_info table(cycle) table(vw)];
batch_info = [batch_info struct2table(sepparam) struct2table(geoparam)];
batch_info = [batch_info Grd_output];
writetable(batch_info,...
    ['GrdData\\' FOI '\\' 'CY' num2str(cycle) 'wheel' num2str(sepparam.wheel_type) '-info.csv'],...
    'WriteMode','append');
toc;
end