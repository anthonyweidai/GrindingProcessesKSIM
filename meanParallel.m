set(0,'defaultfigurecolor',[1 1 1])
%% Chageable parameters
%%
Cycle = 1;
%% Parallel experiment
CurrentMode = 0;
BackupMode = 0;
RemoveInfo = removeFieldParam(BackupMode, 0);
WheelType = 2:3;
% FOIStorage = {'Edges' 'FilletMode' 'Sigmah' 'Sigmarg' 'EllipsoidRarea' 'Xi'}; % Cycle = 1 % 'EllipsoidRarea' 'Xi' 
FOIStorage = {'Edges'};
meanAnalysis(Cycle, WheelType, FOIStorage, CurrentMode, BackupMode, RemoveInfo);
% FOIStorage = {'RowGap' 'SepGap' 'theta' 'KDev'};
% % FOIStorage = {'theta'};
% WheelType = 3;
% meanAnalysis(Cycle, WheelType, FOIStorage, CurrentMode, BackupMode, RemoveInfo);

%% Different Shapes
% WheelType = 2:3;
% diffShapesPlot(Cycle, WheelType);

%% Box plotter
% DistField = 'UCT';
% CurrentMode = 1;
% % WheelType = 2:3;
% % %FOIStorage = {'Sigmah' 'Sigmarg' 'FilletMode' 'EllipsoidRarea' 'Xi'};
% % FOIStorage = {'Sigmah' 'Sigmarg' 'FilletMode' };
% % DistribBoxPlot(Cycle, WheelType, FOIStorage, DistField, CurrentMode);
% FOIStorage = {'RowGap' 'SepGap' 'theta' 'KDev'};
% WheelType = 3;
% DistribBoxPlot(Cycle, WheelType, FOIStorage, DistField, CurrentMode);

% CurrentMode = 1;
% WheelType = 2:3;
% FOIStorage = {'Sigmah' 'Sigmarg'};
% for FOI = FOIStorage
%     DistribBoxPlot(Cycle, WheelType, FOI, FOI, CurrentMode);
% end

%% Comprehensive evaluation, aleady with mean values
% WheelType = 2:3;
% % FOIStorage = {'Edges' 'Sigmah' 'Sigmarg' 'FilletMode'};
% FOIStorage = {'Sigmah' 'Sigmarg' 'FilletMode'};
% comprehensiveEvaluation(Cycle, WheelType, FOIStorage)
% FOIStorage = {'RowGap' 'SepGap' 'theta' 'KDev'};
% WheelType = 3;
% comprehensiveEvaluation(Cycle, WheelType, FOIStorage);