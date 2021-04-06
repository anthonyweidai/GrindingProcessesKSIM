function [SepParam, GeoParam] = initializeParam(SepParam, GeoParam)
%% Initialize input variables
%%
SepParam.WheelType(~isfield(SepParam,'WheelType')) = 2;   % 1-random; 2-tgw
GeoParam.Shape(~isfield(GeoParam,'Shape')) = 1;

WheelType = SepParam.WheelType;
Shape = GeoParam.Shape;

DefaultVal = getDefaultParam(Shape);
%% Seperation parameters
if WheelType == 2
    SepParam.LSMode(~isfield(SepParam,'LSMode')) = DefaultVal.LSMode;
    if SepParam.LSMode == 1
        SepParam.theta(~isfield(SepParam,'theta')) = 60;
        SepParam.RowGap(~isfield(SepParam,'RowGap')) = 150;
        SepParam.SaveGap(~isfield(SepParam,'SaveGap')) = 100;
    end
elseif WheelType == 3
    SepParam.theta(~isfield(SepParam,'theta')) = DefaultVal.theta;  
    SepParam.SepGap(~isfield(SepParam,'SepGap')) = DefaultVal.SepGap;
    SepParam.RowGap(~isfield(SepParam,'RowGap')) = DefaultVal.RowGap;
    SepParam.KDev(~isfield(SepParam,'KDev')) = DefaultVal.KDev;
end
%% Geometries parameters
if Shape == 1
    GeoParam.Omega(~isfield(GeoParam,'Omega')) = DefaultVal.Omega;
    GeoParam.RHeightSize(~isfield(GeoParam,'RHeightSize')) = DefaultVal.RHeightSize;
    GeoParam.Rarea(~isfield(GeoParam,'Rarea')) = DefaultVal.Rarea;
    GeoParam.RAMode(~isfield(GeoParam,'RAMode')) = DefaultVal.RAMode;
    GeoParam.SigmaSkew(~isfield(GeoParam,'SigmaSkew')) = DefaultVal.SigmaSkew;
    GeoParam.FilletMode(~isfield(GeoParam,'FilletMode')) = DefaultVal.FilletMode;
elseif Shape == 2
    GeoParam.Rarea(~isfield(GeoParam,'Rarea')) = DefaultVal.Rarea;
elseif Shape == 3
    GeoParam.Xi(~isfield(GeoParam,'Xi')) = DefaultVal.Xi;
end
GeoParam.Trimmingh(~isfield(GeoParam,'Trimmingh')) = DefaultVal.Trimmingh;
GeoParam.Sigmarg(~isfield(GeoParam,'Sigmarg')) = DefaultVal.Sigmarg;
GeoParam.Sigmah(~isfield(GeoParam,'Sigmah')) = DefaultVal.Sigmah;
end