function mixedEvaluation(Cycle, WheelType, FilePath, FOI, InputField, xName)
%% Evaluate both wheels
%%
RemoveInfo = removeFieldParam(0, 1);
BatchArrayAll = [];
for i = WheelType
    FileName = [FilePath '-Total' num2str(Cycle) 'Wheel' num2str(i) '.csv'];
    BatchInfo = readtable(FileName,'PreserveVariableNames',1);
    BatchInfo = removeTableRows(FOI, BatchInfo, RemoveInfo);
    
    %% Data homogenization processing
    BatchArray = table2array(BatchInfo);
    ColNames = BatchInfo.Properties.VariableNames;
    for k2 = 1:length(ColNames)
        ColNamesChar = char(ColNames(k2));
        if strcmp(ColNamesChar, 'Inactive/%')
            BatchArray(:,k2) = 1 - BatchArray(:,k2);
        elseif strcmp(ColNamesChar, 'Ra') || strcmp(ColNamesChar, 'FnSteady') || ...
                strcmp(ColNamesChar, 'MaxStress')||strcmp(ColNamesChar, 'CGrits')
            BatchArray(:,k2) = 1./BatchArray(:,k2);
        end
    end
    BatchArrayAll = [BatchArrayAll;BatchArray];
end
%%
BatchArrayAll = normalize(BatchArrayAll,'range'); % normalize data in [0,1]
%%
Theight = height(BatchInfo);
SumScore = zeros(2*Theight,3);
MaterialType = 1:3;
MTLength = length(MaterialType);
WRaAll = zeros(1,MTLength);
WFnAll = zeros(1,MTLength);
WMaxStressAll = zeros(1,MTLength);
WCuttingAll = zeros(1,MTLength);
WInactiveAll = zeros(1,MTLength);
CRAll = zeros(1,MTLength);
for MT = MaterialType
    %% Material setting up
    [WCutting, WInactive, WCGrits, WRa, WFn, WMaxStress, CR] = ...
        weightSettingUp(MT);
    %%
    for k3 = 1:length(ColNames)
        ColNamesChar = char(ColNames(k3));
        if strcmp(ColNamesChar, 'Ra')
            Ra = BatchArrayAll(:,k3)*WRa;
        elseif strcmp(ColNamesChar, 'FnSteady')
            FnSteady = BatchArrayAll(:,k3)*WFn;
        elseif strcmp(ColNamesChar, 'MaxStress')
            MaxStress = BatchArrayAll(:,k3)*WMaxStress;
        elseif strcmp(ColNamesChar, 'Cutting/%')
            Cutting = BatchArrayAll(:,k3)*WCutting;
        elseif strcmp(ColNamesChar, 'Inactive/%')
            Inactive = BatchArrayAll(:,k3)*WInactive;
        elseif strcmp(ColNamesChar, 'CGrits')
            CGrits = BatchArrayAll(:,k3)*WCGrits;
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
plot(InputValue,SumScore(Theight+1:end,1),'r-',...
    InputValue,SumScore(Theight+1:end,2),'b-',...
    InputValue,SumScore(Theight+1:end,3),'g-');
hold on
plot(InputValue,SumScore(1:Theight,1),'r--',...
    InputValue,SumScore(1:Theight,2),'b--',...
    InputValue,SumScore(1:Theight,3),'g--');
xlabel(xName);ylabel('总评分');
% legend('Rough grinding','brittle material','plastic material')
legend('粗加工-有序','脆性材料精加工-有序','塑性材料精加工-有序',...
    '粗加工-无序','脆性材料精加工-无序','塑性材料精加工-无序')
SavePath = ['MeanAnalysis/' FOI '/Commenting-' InputField];
savefig([SavePath '.fig']);
print([SavePath '.jpg'], '-djpeg' );
close gcf
%% Save data in table
T.(InputField) = InputValue;
NewSubfolder = 'MeanAnalysis/Commenting/';
if ~exist(NewSubfolder,'dir')
    mkdir(NewSubfolder);
end

T.Rough = SumScore(1:Theight,1);
T.Brittle = SumScore(1:Theight,2);
T.Plastic = SumScore(1:Theight,3);
SavePath = [NewSubfolder  '/Commenting-' InputField 'Wheel2' '.csv'];
temp = struct2table(T);
writetable(temp, SavePath);

T.Rough = SumScore(Theight+1:end,1);
T.Brittle = SumScore(Theight+1:end,2);
T.Plastic = SumScore(Theight+1:end,3);
SavePath = [NewSubfolder  '/Commenting-' InputField 'Wheel3' '.csv'];
temp = struct2table(T);
writetable(temp, SavePath);
%% Save evaluation vector
BestT.WRa = WRaAll;
BestT.WFn = WFnAll;
BestT.WMaxStress = WMaxStressAll;
BestT.WCutting = WCuttingAll;
BestT.WInactive = WInactiveAll;
BestT.WCGrits = WCGritsAll;
BestT.CR = CRAll;

BestT = struct2table(BestT);
SavePath = [NewSubfolder 'Comprehensive-commenting-Shape' '.csv'];
writetable(BestT, SavePath, 'WriteMode', 'append');
end