function [SepParam, GeoParam] = setBoxPlotParam(BatchInfo)
%% Set box plot param
%% Seperation parameters
SepParam.WheelType = getTabelValtoArray(BatchInfo, 'WheelType');
if SepParam.WheelType == 2
    SepParam.LSMode = getTabelValtoArray(BatchInfo, 'LSMode');
    if SepParam.LSMode == 1
        SepParam.theta = getTabelValtoArray(BatchInfo, 'theta');
        SepParam.RowGap = getTabelValtoArray(BatchInfo, 'RowGap');
        SepParam.SaveGap = getTabelValtoArray(BatchInfo, 'SaveGap');
    end
elseif SepParam.WheelType == 3
    SepParam.theta = getTabelValtoArray(BatchInfo, 'theta');
    SepParam.SepGap = getTabelValtoArray(BatchInfo, 'SepGap');
    SepParam.RowGap = getTabelValtoArray(BatchInfo, 'RowGap');
    SepParam.KDev = getTabelValtoArray(BatchInfo, 'KDev');
end
%% Geometries parameters
GeoParam.Shape = getTabelValtoArray(BatchInfo, 'Shape');
if GeoParam.Shape == 1
    GeoParam.Omega = getTabelValtoArray(BatchInfo, 'Omega');
    GeoParam.RHeightSize = getTabelValtoArray(BatchInfo, 'RHeightSize');
    GeoParam.Rarea = getTabelValtoArray(BatchInfo, 'Rarea');
    GeoParam.RAMode = getTabelValtoArray(BatchInfo, 'RAMode');
    GeoParam.SigmaSkew = getTabelValtoArray(BatchInfo, 'SigmaSkew');
    GeoParam.FilletMode = getTabelValtoArray(BatchInfo, 'FilletMode');
elseif GeoParam.Shape == 2
    GeoParam.Rarea = getTabelValtoArray(BatchInfo, 'Rarea');
elseif GeoParam.Shape == 3
    GeoParam.Xi = getTabelValtoArray(BatchInfo, 'Xi');
end
GeoParam.Trimmingh = getTabelValtoArray(BatchInfo, 'Trimmingh');
GeoParam.Sigmarg = getTabelValtoArray(BatchInfo, 'Sigmarg');
GeoParam.Sigmah = getTabelValtoArray(BatchInfo, 'Sigmah');
end