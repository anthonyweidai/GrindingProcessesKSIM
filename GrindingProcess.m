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
WorkpieceLength = 1000;
WorkpieceWidth = WorkpieceLength/2;     % max(grits.posx);
WheelLength = 15*WorkpieceLength;       % 40 times Wheel Diameter to Width
WheelWidth = WorkpieceWidth;
vw = 200e3; % feed speed, um/s
res = .2;  % surf resolution of all axis
%% Input parameters initialization
[SepParam, GeoParam] = initializeParam(SepParam, GeoParam);
%% Simplified mode won't calculate force, but the other will
cof_cal_mode(GeoParam.Shape==2 || GeoParam.Shape==3) = 0; % 0-simplified mode 1-accurate mode
%% Generate grinding wheel
FileName = getFilename(Cycle, SepParam, GeoParam, FOI, vw);
if SepParam.WheelType == 1
    [grits,GritsProfile,GeoParam] = bubbleSimulator(FileName,WheelLength,WheelWidth,GeoParam,res);
elseif SepParam.WheelType == 2
    [grits,GritsProfile,GeoParam] = montecarloGenerator(FileName,WheelLength,WheelWidth,SepParam,GeoParam,res);
elseif SepParam.WheelType == 3
    [grits,GritsProfile,GeoParam] = TGWGenerator(FileName,WheelLength,WheelWidth,SepParam,GeoParam,res);
end
%% Kinematic simulation
GrdOutput = kinematicSimulation(FileName,grits,GritsProfile,cof_cal_mode,...
    WorkpieceLength,WorkpieceWidth,WheelLength,...
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