function FOIEdges(BatNum, FOI, Shape, InterestingParam1, InterestingParam2)
%% field of interest Geometry parameters
cof_cal_mode = 1;
GeoParam.Shape = Shape;
createFolder(FOI);
%% Interesting variables
disp(['FOI: ' FOI ', Numbers of Variables: ' num2str(2*...
    length(InterestingParam1)*length(InterestingParam2)*length(BatNum))]);
%%
for Cycle = BatNum
    for WheelType = 2:3
        SepParam.WheelType = WheelType;
        for Omega = InterestingParam1
            GeoParam.Omega = Omega;
            for Rarea = InterestingParam2
                GeoParam.Rarea = Rarea;
                errorReport(Cycle,FOI,SepParam,GeoParam);
                grindingProcess(cof_cal_mode, Cycle, FOI, SepParam, GeoParam);
            end
        end
    end
end
end