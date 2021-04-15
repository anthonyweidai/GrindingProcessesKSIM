function FOIGeoParam(BatNum, FOI, Shape, InterestingParam)
%% field of interest Geometry parameters
cof_cal_mode = 1;
GeoParam.Shape = Shape;
createFolder(FOI);
%%
InputField = initInputField(FOI);

if strcmp(FOI, 'RHeightSize')
    GeoParam.RAMode = 1;
end
%% Interesting variables
disp(['FOI: ' FOI ', Numbers of Variables: ' num2str(2*length(InterestingParam)*length(BatNum))]);
%%
for Cycle = BatNum
    for WheelType = 2:3
        SepParam.WheelType = WheelType;
        for InterestingField = InterestingParam
            GeoParam.(InputField) = InterestingField;
            errorReport(Cycle,FOI,SepParam,GeoParam);
            grindingProcess(cof_cal_mode, Cycle, FOI, SepParam, GeoParam);
        end
    end
end
end