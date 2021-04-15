function FOISepParam(BatNum, FOI, InterestingParam)
%% field of interest Triming height
cof_cal_mode = 1;
SepParam.WheelType = 3;
createFolder(FOI);
GeoParam.Shape = 1;
%% Interesting variables
disp(['FOI: ' FOI ', Numbers of Variables: ' num2str(length(InterestingParam)*length(BatNum))]);
%%
for Cycle = BatNum
    for InterestingField = InterestingParam
        SepParam.(FOI) = InterestingField;
        errorReport(Cycle, FOI, SepParam, GeoParam);
        grindingProcess(cof_cal_mode, Cycle, FOI, SepParam, GeoParam);
    end
end
end