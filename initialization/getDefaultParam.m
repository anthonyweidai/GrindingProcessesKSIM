function DefaultVal = getDefaultParam(Shape)
%% Set Default Parameters
%% Seperation parameters
DefaultVal.LSMode = 0;
DefaultVal.theta = 60;
DefaultVal.SepGap = 0.5;
DefaultVal.RowGap = 1;
DefaultVal.KDev = 0;
%% Geometries parameters
if Shape == 1
    DefaultVal.Omega = 7;
    DefaultVal.RHeightSize = 1;
    DefaultVal.Rarea = 0.7;
    DefaultVal.RAMode = 0;
    DefaultVal.SigmaSkew = 0;
    DefaultVal.FilletMode = 0;
elseif Shape == 2
    DefaultVal.Rarea = 1;
elseif Shape == 3
    DefaultVal.Xi = 0.55;
end
DefaultVal.Trimmingh = 0;
DefaultVal.Sigmarg = 0;
DefaultVal.Sigmah = 0;
end