function meanParallel()
set(0,'defaultfigurecolor',[1 1 1])
%% Chageable parameters
%%
Cycle = 1;
%% Parallel experiment
CurrentMode = 0;
BackupMode = 0;
RemoveInfo = removeFieldParam(BackupMode, 0);
WheelType = 2:3;
%%%%%% FOIStorage = {'Edges' 'FrustumRarea' 'EllipsoidRarea' 'Xi' 'FilletMode'}; % Cycle = 1
FOIStorage = {'FilletMode'};
meanAnalysis(Cycle, WheelType, FOIStorage, CurrentMode, BackupMode, RemoveInfo);
% % % % % % FOIStorage = {'RowGap' 'SepGap' 'theta' 'KDev'};
% % % % % FOIStorage = {'theta'};
% % % % % WheelType = 3;
% % % % % meanAnalysis(Cycle, WheelType, FOIStorage, CurrentMode, BackupMode, RemoveInfo);

%% Different Shapes
% WheelType = 2:3;
% diffShapesPlot(Cycle, WheelType);

%% Box plotter
% DistField = 'UCT';
% CurrentMode = 1;
% WheelType = 2:3;
% %%%%%% FOIStorage = {'Edges' 'FrustumRarea'};
% FOIStorage = {'Sigmah' 'Sigmarg' 'FilletMode' 'EllipsoidRarea' 'Xi'};
% DistribBoxPlot(Cycle, WheelType, FOIStorage, DistField, CurrentMode);
% % FOIStorage = {'RowGap' 'SepGap' 'theta' 'KDev'};
% % WheelType = 3;
% % DistribBoxPlot(Cycle, WheelType, FOIStorage, DistField, CurrentMode);

% CurrentMode = 1;
% WheelType = 2:3;
% FOIStorage = {'Sigmah' 'Sigmarg'};
% for FOI = FOIStorage
%     DistribBoxPlot(Cycle, WheelType, FOI, FOI, CurrentMode);
% end

%% Comprehensive evaluation
% WheelType = 2:3;
% % FOIStorage = {'Edges' 'Sigmah' 'Sigmarg' 'FilletMode'};
% FOIStorage = {'FilletMode'};
% comprehensiveEvaluation(Cycle, WheelType, FOIStorage)
% % FOIStorage = {'RowGap' 'SepGap' 'theta' 'KDev'};
% % WheelType = 3;
% % comprehensiveEvaluation(Cycle, WheelType, FOIStorage);
end