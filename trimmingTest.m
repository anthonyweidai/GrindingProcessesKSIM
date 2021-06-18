Cycle = 1;
Shape = 1;
FOI = 'Trimmingh';
GeoParam.Sigmah = 0.05;
SepParam.WheelType = 2;
GeoParam.Shape = 1;
%% field of interest Geometry parameters
cof_cal_mode = 1;
createFolder(FOI);
%%
for Trimmingh = [0 0.005 0.02 0.03 0.04]
    GeoParam.Trimmingh = Trimmingh; % change getfilename
    errorReport(Cycle, FOI, SepParam, GeoParam);
    grindingProcess(cof_cal_mode, Cycle, FOI, SepParam, GeoParam);
end