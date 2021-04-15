function activeEdgesPlotter(SavePath, Cycle, WheelType, FOI, InputField, OutputField)
%% Plotter for 3D vector
PlotFig1 = figure(1);
% [~, zName] = labelsName(FOI, InputField, OutputField);
%%
FileName = [SavePath '-Total' num2str(Cycle) 'Wheel' num2str(WheelType) '.csv'];
T1 = readtable(FileName,'PreserveVariableNames',1);
% FOIHandler = sortrows(T1,InputField);
x = table2array(T1(:,'Omega'));
y = table2array(T1(:,'Rarea'));
z = table2array(T1(:,OutputField));

% cftool( x, y, z )
figure(1);
ft = 'cubicinterp';
f = fit([x,y],z,ft);
plot( f, [x, y], z )

% colorbar
% xlabel('\omega/条'); ylabel('R_{area}'); zlabel(zName);
FileName = [SavePath '/' OutputField '-Wheel' num2str(WheelType)];
savefig([FileName '.fig']);
% saveas(PlotFig1, [FileName '.svg']);
print([FileName '.jpg'], '-djpeg' );
close(PlotFig1);
end