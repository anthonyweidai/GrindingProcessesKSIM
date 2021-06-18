function FOIConeAngle(BatNum)
%% field of interest is Cone angle
cof_cal_mode = 1;
GeoParam.Shape = 1;
FOI = 'ConeAngle';
createFolder(FOI);
%%
disp(['FOI: ' FOI ', Variables Numbers: ' num2str(2*2)]);
%%
for Cycle = BatNum
    for WheelType = 2:3
        SepParam.WheelType = WheelType;
        % Copy 0.3 0.7 RAMode = 1 form FOIFrustumRarea
        GeoParam.RAMode = 0;
        for Rarea = [0.3, 0.7]
            GeoParam.Rarea = Rarea;
            errorReport(Cycle,FOI,SepParam,GeoParam);
            grindingProcess(cof_cal_mode, Cycle, FOI, SepParam, GeoParam);
        end
    end
end
end