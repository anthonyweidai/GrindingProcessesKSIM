function [SumScore, BestWeight] = getSumScore(BatchArray, ColNames, SumScore, MaterialType)
%% Get the sum values of each object
MTLength = length(MaterialType);
WRaAll = zeros(1,MTLength);
WFnAll = zeros(1,MTLength);
WFtAll = zeros(1,MTLength);
WMaxStressAll = zeros(1,MTLength);
WCuttingAll = zeros(1,MTLength);
WInactiveAll = zeros(1,MTLength);
WCGritsAll = zeros(1,MTLength);
CRAll = zeros(1,MTLength);
for MT = MaterialType
    %% Material setting up
    [WCutting, WInactive, WCGrits, WRa, WF, WMaxStress, CR] = ...
        weightSettingUp(MT);
    %%
    for k3 = 1:length(ColNames)
        ColNamesChar = char(ColNames(k3));
        if strcmp(ColNamesChar, 'Ra')
            Ra = BatchArray(:,k3)*WRa;
        elseif strcmp(ColNamesChar, 'FnSteady')
            FnSteady = BatchArray(:,k3)*WF/2;
        elseif strcmp(ColNamesChar, 'FtSteady')
            FtSteady = BatchArray(:,k3)*WF/2;
        elseif strcmp(ColNamesChar, 'MaxStress')
            MaxStress = BatchArray(:,k3)*WMaxStress;
        elseif strcmp(ColNamesChar, 'Cutting/%')
            Cutting = BatchArray(:,k3)*WCutting;
        elseif strcmp(ColNamesChar, 'Inactive/%')
            Inactive = BatchArray(:,k3)*WInactive;
        elseif strcmp(ColNamesChar, 'CGrits')
            CGrits = BatchArray(:,k3)*WCGrits;
        end
    end
    %%
    temp = Ra + MaxStress + FnSteady + FtSteady + Cutting + Inactive + CGrits;
    MaxSum = max(temp)/100;
    SumScore(:,MT) = temp/MaxSum;
    WRaAll(MT) = WRa;
    WFnAll(MT) = WF;
    WFtAll(MT) = WF;
    WMaxStressAll(MT) = WMaxStress;
    WCuttingAll(MT) = WCutting;
    WInactiveAll(MT) = WInactive;
    WCGritsAll(MT) = WCGrits;
    CRAll(MT) = CR;
end
BestWeight.WRaAll = WRaAll;
BestWeight.WFnAll = WFnAll;
BestWeight.WFtAll = WFtAll;
BestWeight.WMaxStressAll = WMaxStressAll;
BestWeight.WCuttingAll = WCuttingAll;
BestWeight.WInactiveAll = WInactiveAll;
BestWeight.WCGritsAll = WCGritsAll;
BestWeight.CRAll = CRAll;
end