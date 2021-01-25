function GrdProcess4(cof_cal_mode, cycle, FOI, sepparam, geoparam)
warning off;
tic;
%%
% cof_cal_mode % 0-none 1-simplified mode 2-accurate mode
workpiece_length = 1000;
workpiece_width = 500;     % max(grits.posx);
wheel_length = 5*workpiece_length;
wheel_width = workpiece_width;
vw = 200e3;               %feed speed, um/min
res=.2;              % surf resolution of all axis
%% Input parameters initialization
[sepparam, geoparam] = param_initialize(sepparam, geoparam);
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
    geoparam.shape,geoparam.Rarea,res,vw);
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