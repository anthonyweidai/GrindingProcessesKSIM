function DistribBoxPlot(Cycle, WheelType, FOIStorage, DistField, CurrentMode)
%% Plot each box chart for wheel type
%%
if CurrentMode == 1
    DiskPath1 = 'M:/GrdData/';
else
    DiskPath1 = 'N:/GrdData/';
end
%%
if strcmp(DistField, 'UCT')
    FileIcon = 'uct';
elseif strcmp(DistField, 'Sigmah')
    FileIcon = 'proh';
elseif strcmp(DistField, 'Sigmarg')
    FileIcon = 'rg';
end
%%
for i = 1:length(FOIStorage)
    FOI = char(FOIStorage(i));
    InputField = initInputField(FOI);
    
    SavePath = ['MeanAnalysis/' FOI];
    if ~exist(SavePath,'dir')
        mkdir(SavePath);
    end
    %%%%%%%%%%%% xAxis
    for j = WheelType
        x = [];
        g = [];
        for k4 = Cycle % 1:Cycle
            %%
            FileName = [DiskPath1 FOI '/CY' num2str(k4) 'wheel' num2str(j) '-info.csv'];
            BatchInfo = readtable(FileName,'PreserveVariableNames',1);
            
            IndexTemp = [];
            if ~(strcmp(FOI, 'EllipsoidRarea')||strcmp(FOI, 'Xi')||strcmp(FOI, 'RHeightSize'))
                DefaultVal = getDefaultParam(1);
                Flag = 0;
                for k1 = 1:height(BatchInfo)
                    if DefaultVal.(InputField) == getTabelValtoArray(BatchInfo(k1,:), InputField)
                        Flag = 1;
                        break
                    end
                end
                if Flag == 0
                    FileName = [DiskPath1 'Default' '/CY' num2str(k4) 'wheel' num2str(j) '-info.csv'];
                    DefaultBatch = readtable(FileName,'PreserveVariableNames',1);
                    [xTemp, ~] = updateBoxVar(DefaultBatch, DiskPath1, k4, 'Default', FileIcon, [], []);
                    gTemp = repmat({num2str(DefaultVal.(InputField))},length(xTemp),1);
                    [~, Index] = sortrows([DefaultBatch; BatchInfo], InputField);
                    IndexTemp = find(Index == 1);
                end
            end
            
            for k2 = 1:height(BatchInfo)
                % sorting
                if k2 == IndexTemp
                    x = [x; xTemp];
                    g = [g; gTemp];
                end
                [x, g] = updateBoxVar(BatchInfo(k2,:), DiskPath1, k4, FOI, FileIcon, x, g);
            end
        end
        %%
        figure
        if strcmp(DistField, 'UCT')
            if j == 3
                Color = 'r';
            elseif j == 2
                Color = 'b';
            end
        elseif strcmp(DistField, 'Sigmah')
            Color = 'm';
        elseif strcmp(DistField, 'Sigmarg')
            Color = 'c';
        end
        boxplot(x, g, 'Notch', 'on')
        h = findobj(gca,'Tag','Box');
        for k3 = 1:length(h)
            patch(get(h(k3),'XData'),get(h(k3),'YData'),Color,'FaceAlpha',.5);
        end
        [xName, yName] = labelsName(FOI, InputField, FileIcon);
        xlabel(xName), ylabel(yName)
        
        FileName = [SavePath '/' InputField 'Wheel' num2str(j) '-' FileIcon];
        savefig([FileName '.fig']);
        % saveas(PlotFig3, [FileName '.svg']);
        print([FileName '.jpg'], '-djpeg' );
        close gcf
    end
end
end