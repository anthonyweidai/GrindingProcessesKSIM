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
function grindingProcess(cof_cal_mode, Cycle, FOI, SepParam, GeoParam)
warning off;
tic;
%%
workpiece_length = 1000;
workpiece_width = 500;     % max(grits.posx);
wheel_length = 10*workpiece_length;
wheel_width = workpiece_width;
vw = 200e3;               % feed speed, um/s
res = .2;              % surf resolution of all axis
%% Input parameters initialization
[SepParam, GeoParam] = initializeParam(SepParam, GeoParam);
%% Simplified mode won't calculate force, but the other will
cof_cal_mode(GeoParam.Shape==2 || GeoParam.Shape==3) = 0; % 0-simplified mode 1-accurate mode
%% Generate grinding wheel
FileName = getFilename(Cycle, SepParam, GeoParam, FOI, vw);
if SepParam.WheelType == 1
    [grits,GritsProfile,GeoParam] = ...
        bubbleSimulator(FileName, wheel_length, wheel_width, GeoParam, res);
elseif SepParam.WheelType == 2
    [grits,GritsProfile,GeoParam] = ...
        montecarloGenerator(FileName, wheel_length, wheel_width, SepParam, GeoParam, res);
elseif SepParam.WheelType == 3
    [grits,GritsProfile,GeoParam] = ...
        TGWGenerator(FileName, wheel_length, wheel_width, SepParam, GeoParam, res);
end
%% Kinematic simulation
GrdOutput = kinematicSimulation(FileName,grits,GritsProfile,cof_cal_mode,...
    workpiece_length,workpiece_width,wheel_length,...
    GeoParam,res,vw);
%% Record input and output variables
BatchInfo = array2table(convertCharsToStrings(char(datetime)),'VariableNames',{'datetime'});
BatchInfo = [BatchInfo table(Cycle) table(vw)];
BatchInfo = [BatchInfo struct2table(SepParam) struct2table(GeoParam)];
BatchInfo = [BatchInfo GrdOutput];
writetable(BatchInfo,...
    ['M:\\GrdData\\' FOI '\\' 'CY' num2str(Cycle) 'wheel' num2str(SepParam.WheelType) '-info.csv'],...
    'WriteMode','append');
toc;
end