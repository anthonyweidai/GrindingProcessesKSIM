function [SepParam, GeoParam] = initializeParam(SepParam, GeoParam)
%% Initialize input variables
%% Seperation parameters
SepParam.WheelType(~isfield(SepParam,'WheelType')) = 2;   % 1-random; 2-tgw
if SepParam.WheelType == 2
    SepParam.LSMode(~isfield(SepParam,'LSMode')) = 0;
    if SepParam.LSMode == 1
        SepParam.theta(~isfield(SepParam,'theta')) = 60;
        SepParam.RowGap(~isfield(SepParam,'RowGap')) = 150;
        SepParam.SaveGap(~isfield(SepParam,'SaveGap')) = 100;
    end
elseif SepParam.WheelType == 3
    SepParam.theta(~isfield(SepParam,'theta')) = 60;   % line tilt angle:30 40 50 60 70 80
    SepParam.SepGap(~isfield(SepParam,'SepGap')) = 0.5; % column gap: 0.5,1,3,5
    SepParam.RowGap(~isfield(SepParam,'RowGap')) = 3;   % row gap: 1,3,5,7
    SepParam.KDev(~isfield(SepParam,'KDev')) = 0;    % position deviation para: ~0.01 
end
%% Geometries parameters
GeoParam.Shape(~isfield(GeoParam,'Shape')) = 1;
if GeoParam.Shape == 1
    GeoParam.Omega(~isfield(GeoParam,'Omega')) = 7;
    GeoParam.RHeightSize(~isfield(GeoParam,'RHeightSize')) = 1;
    GeoParam.Rarea(~isfield(GeoParam,'Rarea')) = 0.7;
    GeoParam.RAMode(~isfield(GeoParam,'RAMode')) = 1;
    GeoParam.SigmaSkew(~isfield(GeoParam,'SigmaSkew')) = 0;
    GeoParam.FilletMode(~isfield(GeoParam,'FilletMode')) = 0;
elseif GeoParam.Shape == 2
    GeoParam.Rarea(~isfield(GeoParam,'Rarea')) = 0.5;
elseif GeoParam.Shape == 3
    GeoParam.Xi(~isfield(GeoParam,'Xi')) = 0;
    GeoParam.Rarea(~isfield(GeoParam,'Rarea')) = 0; % For get force module
end
GeoParam.Trimmingh(~isfield(GeoParam,'Trimmingh')) = 0;
GeoParam.Sigmarg(~isfield(GeoParam,'Sigmarg')) = 0;
GeoParam.Sigmah(~isfield(GeoParam,'Sigmah')) = 0;
end
