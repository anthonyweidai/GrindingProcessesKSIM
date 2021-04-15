function meanAnalysis(Cycle, WheelType, FOIStorage, CurrentMode, BackupMode, RemoveInfo)
%%
if CurrentMode == 1
    DiskPath1 = 'M:/GrdData/';
elseif BackupMode == 1
    DiskPath1 = 'N:/GrdData/';
else
    DiskPath1 = 'P:/university/GrdData/'; % use backup
end
DiskPath2 = 'P:/university/GrdData/';
OutputField = {'Ra' 'FnSteady' 'FtSteady' 'MaxStress' 'MeanStress' 'CGrits'};
%%
for i = 1:length(FOIStorage)
    FOI = char(FOIStorage(i));
    %%
    FileBackupPath = [DiskPath2 FOI];
    if ~exist(FileBackupPath,'dir')
        mkdir(FileBackupPath);
    end
    SavePath = ['MeanAnalysis/' FOI];
    if ~exist(SavePath,'dir')
        mkdir(SavePath);
    end
    %%
    InputField = initInputField(FOI);
    for j = WheelType
        if BackupMode == 1
            for k1 = 1:Cycle
                %% Read csv files
                FileName = [DiskPath1 FOI '/CY' num2str(k1) 'wheel' num2str(j) '-info.csv'];
                BatchInfo = readtable(FileName,'PreserveVariableNames',1);
                %% Add default parameters set
                if ~(strcmp(FOI, 'EllipsoidRarea')||strcmp(FOI, 'Xi')||...
                        strcmp(FOI, 'RHeightSize')||strcmp(FOI, 'Edges'))
                    DefaultVal = getDefaultParam(1);
                    Flag = 0;
                    for k2 = 1:height(BatchInfo)
                        if DefaultVal.(InputField) == getTabelValtoArray(BatchInfo(k2,:), InputField)
                            Flag = 1;
                            break
                        end
                    end
                    if Flag == 0
                        FileName = [DiskPath1 'Default' '/CY' num2str(k1) 'wheel' num2str(j) '-info.csv'];
                        DefaultBatch = readtable(FileName,'PreserveVariableNames',1);
                        BatchInfo = [BatchInfo; DefaultBatch];
                    end
                end
                %%
                BatchInfo = sortrows(BatchInfo, InputField);
                %% Remove rows
                BatchInfo = removeTableRows(FOI, BatchInfo, RemoveInfo);
                %% Backup
                writetable(BatchInfo, [FileBackupPath '/CY' num2str(k1) 'wheel' num2str(j) '-info.csv']);
            end
        else
            for k1 = 1:Cycle
                %% Read csv files
                FileName = [DiskPath1 FOI '/CY' num2str(k1) 'wheel' num2str(j) '-info.csv'];
                BatchInfo = readtable(FileName,'PreserveVariableNames',1);
                BatchInfo = removevars(BatchInfo,{'datetime'});
                BatchInfo = sortrows(BatchInfo, InputField);
                %% Remove rows
                BatchInfo = removeTableRows(FOI, BatchInfo, RemoveInfo);
                BatchArray = table2array(BatchInfo);
                %% Get the sum values of table
                if k1 == 1
                    temp = BatchArray;
                else
                    temp = temp + BatchArray;
                end
            end
            %% Get the average values of table
            Batchmean = temp / Cycle;
            ColNames = BatchInfo.Properties.VariableNames;
            T = array2table(Batchmean,'VariableNames',ColNames);
            %% Variance analysis
            for k3 = 1:length(Batchmean)
                if abs(var(Batchmean(:,k3))) <= 1e-7
                    RemovedField = ColNames(k3);
                    if ~(strcmp(char(RemovedField),'Ra')||strcmp(char(RemovedField),'CGrits'))
                        T = removevars(T,RemovedField);
                    end
                end
            end
            %% Scalling gap data
            T = dataScaling(T, FOI);
            %% Write table with columns' name
            writetable(T, [SavePath '-Total' num2str(Cycle) 'Wheel' num2str(j) '.csv']);
            
        end
    end
    if BackupMode == 0
        %% Plot and save
        Flag = 0;
        for k4 = 1:length(OutputField)
            if ~strcmp(FOI, 'Edges')
                batchPlotter(SavePath, Cycle, WheelType, FOI, InputField, char(OutputField(k4)), Flag);
            else
                for j = WheelType
                    activeEdgesPlotter(SavePath, Cycle, j, FOI, InputField, char(OutputField(k4)));
                end
            end
            Flag = 1;
        end
    end
end