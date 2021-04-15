function singleEvaluation(Cycle, WheelType, FilePath, FOI, InputField, xName)
%% Evaluate each wheel
%%
for i = WheelType
    FileName = [FilePath '-Total' num2str(Cycle) 'Wheel' num2str(i) '.csv'];
    BatchInfo = readtable(FileName,'PreserveVariableNames',1);
    
    RemoveInfo = removeFieldParam(0, 1);
    BatchInfo = removeTableRows(FOI, BatchInfo, RemoveInfo);
    
    %% Data homogenization processing
    BatchArray = table2array(BatchInfo);
    ColNames = BatchInfo.Properties.VariableNames;
    for k2 = 1:length(ColNames)
        ColNamesChar = char(ColNames(k2));
        if strcmp(ColNamesChar, 'Inactive/%')
            BatchArray(:,k2) = 1 - BatchArray(:,k2);
        elseif strcmp(ColNamesChar, 'Ra') || strcmp(ColNamesChar, 'FnSteady') || ...
                strcmp(ColNamesChar, 'MaxStress')
            BatchArray(:,k2) = 1./BatchArray(:,k2);
        end
    end
    %%
    BatchArray = normalize(BatchArray,'range'); % normalize data in [0,1]
    %%
    Theight = height(BatchInfo);
    SumScore = zeros(Theight,3);
    %     if strcmp(FOI, 'Edges')
    %         MaterialType = 2;
    %     else
    MaterialType = 1:3;
    %     end
    MTLength = length(MaterialType);
    WRaAll = zeros(1,MTLength);
    WFnAll = zeros(1,MTLength);
    WMaxStressAll = zeros(1,MTLength);
    WCuttingAll = zeros(1,MTLength);
    WInactiveAll = zeros(1,MTLength);
    WCGritsAll = zeros(1,MTLength);
    CRAll = zeros(1,MTLength);
    for MT = MaterialType
        %% Material setting up
        [WCutting, WInactive, WCGrits, WRa, WFn, WMaxStress, CR] = ...
            weightSettingUp(MT);
        %%
        for k3 = 1:length(ColNames)
            ColNamesChar = char(ColNames(k3));
            if strcmp(ColNamesChar, 'Ra')
                Ra = BatchArray(:,k3)*WRa;
                % Ra = BatchArray(:,k3).^WRa;
            elseif strcmp(ColNamesChar, 'FnSteady')
                FnSteady = BatchArray(:,k3)*WFn;
            elseif strcmp(ColNamesChar, 'MaxStress')
                MaxStress = BatchArray(:,k3)*WMaxStress;
                % MaxStress = BatchArray(:,k3).^WMaxStress;
            elseif strcmp(ColNamesChar, 'Cutting/%')
                Cutting = BatchArray(:,k3)*WCutting;
            elseif strcmp(ColNamesChar, 'Inactive/%')
                Inactive = BatchArray(:,k3)*WInactive;
            elseif strcmp(ColNamesChar, 'CGrits')
                CGrits = BatchArray(:,k3)*WCGrits;
            end
        end
        %%
        temp = Ra + MaxStress + FnSteady + Cutting + Inactive + CGrits;
        MaxSum = max(temp)/100;
        SumScore(:,MT) = temp/MaxSum;
        WRaAll(MT) = WRa;
        WFnAll(MT) = WFn;
        WMaxStressAll(MT) = WMaxStress;
        WCuttingAll(MT) = WCutting;
        WInactiveAll(MT) = WInactive;
        WCGritsAll(MT) = WCGrits;
        CRAll(MT) = CR;
    end
    %% Plot and save data in image
    InputValue = table2array(BatchInfo(:,InputField));
    figure
    if strcmp(FOI, 'Edges')
        x = table2array(BatchInfo(:,'Omega'));
        y = table2array(BatchInfo(:,'Rarea'));
        for MT = MaterialType
            z = SumScore(:,MT);
            
            ft = 'cubicinterp';
            f = fit([x,y],z,ft);
            plot( f, [x, y], z )
            
            SavePath = ['MeanAnalysis/' FOI '/Commenting-' InputField 'Wheel' num2str(i) 'MType' num2str(MT)];
            savefig([SavePath '.fig']);
            print([SavePath '.jpg'], '-djpeg' );
            close gcf
        end
    else
        p = plot(InputValue,SumScore(:,1),'r-',...
            InputValue,SumScore(:,2),'b--',...
            InputValue,SumScore(:,3),'g-.');
        for k = 1:length(p)
            p(k).Marker = 'o';
        end
        xlabel(xName);ylabel('总评分');
        % legend('Rough grinding','brittle material','plastic material')
        legend('粗加工','脆性材料精加工','塑性材料精加工')
        SavePath = ['MeanAnalysis/' FOI '/Commenting-' InputField 'Wheel' num2str(i)];
        savefig([SavePath '.fig']);
        print([SavePath '.jpg'], '-djpeg' );
        close gcf
    end
    %% Save data in table
    T.(InputField) = InputValue;
    T.Rough = SumScore(:,1);
    T.Brittle = SumScore(:,2);
    T.Plastic = SumScore(:,3);
    T = struct2table(T);
    NewSubfolder = 'MeanAnalysis/Commenting/';
    if ~exist(NewSubfolder,'dir')
        mkdir(NewSubfolder);
    end
    SavePath = [NewSubfolder  '/Commenting-' InputField 'Wheel' num2str(i) '.csv'];
    writetable(T, SavePath);
    %% Save data above 80% score
    BestT.(InputField) = InputField;
    BestT.WheelType = num2str(i);
    % MaxNum = floor(0.2*Theight);
    MaxNum = 3;
    MaxNum = min(Theight,MaxNum);
    
    [~,I] = maxk(T.Rough,MaxNum);
    BestT.Rough = InputValue(I)';
    [~,I] = maxk(T.Brittle,MaxNum);
    BestT.Brittle = InputValue(I)';
    [~,I] = maxk(T.Plastic,MaxNum);
    BestT.Plastic = InputValue(I)';
    
    BestT.WRa = WRaAll;
    BestT.WFn = WFnAll;
    BestT.WMaxStress = WMaxStressAll;
    BestT.WCutting = WCuttingAll;
    BestT.WInactive = WInactiveAll;
    BestT.WCGrits = WCGritsAll;
    BestT.CR = CRAll;
    
    BestT = struct2table(BestT);
    SavePath = [NewSubfolder 'Comprehensive-commenting-Distribution' '.csv'];
    writetable(BestT, SavePath, 'WriteMode', 'append');
    %%
    clear T
    clear BestT
end
end