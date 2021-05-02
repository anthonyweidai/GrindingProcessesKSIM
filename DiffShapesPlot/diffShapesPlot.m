function diffShapesPlot(Cycle, WheelType)
%% Compare 3 different shapes
%%
warning off
OutputFields = {'Ra' 'FnSteady' 'FtSteady' 'MaxStress' 'MeanStress' 'CGrits'};
DiskPath1 = 'N:/GrdData/';
DiskPath2 = 'P:/university/GrdData/';

FOI1 = 'FilletMode';
FOI2 = 'EllipsoidRarea';
FOI3 = 'Xi';

SavePath = 'MeanAnalysis/DiffShapes';
if ~exist(SavePath,'dir')
    mkdir(SavePath);
end

for j = WheelType
    SepParam.WheelType = j;
    
    GeoParam1.Shape = 1;
    [SepParam, GeoParam1] = initializeParam(SepParam, GeoParam1);
    
    GeoParam2.Shape = 2;
    [~, GeoParam2] = initializeParam(SepParam, GeoParam2);
    
    GeoParam3.Shape = 3;
    [~, GeoParam3] = initializeParam(SepParam, GeoParam3);
    
    %% read data
    SOI1 = [];
    SOI2 = [];
    SOI3 = [];
    
    x = [];
    g = [];
    
    for k1 = 1:Cycle
        [ColNames1, SOI1, BatchInfo1] = calMeanofBatch(DiskPath2, FOI1, k1, SepParam, GeoParam1, SOI1);
        
        
        [ColNames2, SOI2, BatchInfo2] = calMeanofBatch(DiskPath2, FOI2, k1, SepParam, GeoParam2, SOI2);
        
        
        [ColNames3, SOI3, BatchInfo3] = calMeanofBatch(DiskPath2, FOI3, k1, SepParam, GeoParam3, SOI3);
        
        %% Plot UCT distribution, Select Name directly
        [xtemp, ~] = updateBoxVar(BatchInfo1, DiskPath1, k1, 'Default', 'uct', [], []);
        gtemp = repmat({'棱台'},length(xtemp),1);
        
        [xtemp, ~] = updateBoxVar(BatchInfo2, DiskPath1, k1, FOI2, 'uct', xtemp, []);
        gtemp = [gtemp; repmat({'椭球'},length(xtemp) - length(gtemp),1)];
        
        [xtemp, ~] = updateBoxVar(BatchInfo3, DiskPath1, k1, FOI3, 'uct', xtemp, []);
        gtemp = [gtemp; repmat({'十四面体'},length(xtemp) - length(gtemp),1)];
        
        x = [x; xtemp];
        g = [g; gtemp];
    end
    figure
    if j == 3
        Color = 'r';
    elseif j == 2
        Color = 'b';
    end
    boxplot(x, g, 'Notch', 'on')
    h = findobj(gca,'Tag','Box');
    for k3 = 1:length(h)
        patch(get(h(k3),'XData'),get(h(k3),'YData'),Color,'FaceAlpha',.5);
    end
    [~, yName] = labelsName([], [], 'uct');
    xlabel('形状种类'), ylabel(yName)
    
    FileName = [SavePath '/' 'Wheel' num2str(j) '-UCT'];
    savefig([FileName '.fig']);
    % saveas(PlotFig3, [FileName '.svg']);
    print([FileName '.jpg'], '-djpeg' );
    close gcf
        
    SOI1 = SOI1/Cycle;
    SOI2 = SOI2/Cycle;
    SOI3 = SOI3/Cycle;
    %% save data
    BarValues1.(['SOI' 'W' num2str(j)]) = SOI1;
    BarValues2.(['SOI' 'W' num2str(j)]) = SOI2;
    BarValues3.(['SOI' 'W' num2str(j)]) = SOI3;
    
    BarValues1.(['Name' 'W' num2str(j)]) = ColNames1;
    BarValues2.(['Name' 'W' num2str(j)]) = ColNames2;
    BarValues3.(['Name' 'W' num2str(j)]) = ColNames3;
end

%% Plot data
xName = {'棱台','椭球','十四面体'};
x = categorical(xName);
x = reordercats(x,xName);
for k2 = 1:length(OutputFields)
    OutputField = char(OutputFields(k2));
    BarValue1 = getValuefromStruct(BarValues1, OutputField);
    BarValue2 = getValuefromStruct(BarValues2, OutputField);
    BarValue3 = getValuefromStruct(BarValues3, OutputField);
    vals = [BarValue1; BarValue2; BarValue3];
    % Ratio = vals./vals(2,:);
    
    figure
    hb = bar(x,vals);
    hb(1).FaceColor = 'r';
    hb(2).FaceColor = 'b';
    legend('有序排布', '无序排布')
    [~, yName] = labelsName([], [], OutputField);
    xlabel('形状种类'), ylabel(yName)
    FileName = [SavePath '/' OutputField '-DiffShapes'];
    savefig([FileName '.fig']);
    % saveas(PlotFig1, [FileName '.svg']);
    print([FileName '.jpg'], '-djpeg' );
    close gcf;
end
end