function FileName = getFilename(Cycle, SepParam, GeoParam, FOI, vw)
%% get_filename is usedd to set path and files' names
WheelType = SepParam.WheelType;
Shape = GeoParam.Shape;
filefolder = ['M:/GrdData/' FOI '/' 'CY' num2str(Cycle)];
%%
if WheelType == 1
    if Shape == 1
        NameBody = ['w' num2str(GeoParam.Omega)  'FT' num2str(GeoParam.FilletMode) 'RAM' num2str(GeoParam.RAMode) ...
            'Rarea' num2str(GeoParam.Rarea)...
            'Ssg' num2str(GeoParam.SigmaSkew) ] ;
    elseif Shape == 2
        NameBody = ['Rarea' num2str(GeoParam.Rarea)];
    else
        NameBody = ['Xi' num2str(GeoParam.Xi)] ;
    end
elseif WheelType == 2
    if SepParam.LSMode == 1
        NameLaser = ['LS' num2str(SepParam.LSMode) ...
            'tgw' num2str(SepParam.theta) 'Sgap' num2str(SepParam.SaveGap) 'Rgap' num2str(SepParam.RowGap)];
        if Shape == 1
            NameBody = [NameLaser ...
                'w' num2str(GeoParam.Omega) 'FT' num2str(GeoParam.FilletMode) 'RAM' num2str(GeoParam.RAMode) ...
                'Rarea' num2str(GeoParam.Rarea) ...
                'Ssg' num2str(GeoParam.SigmaSkew)] ;
        elseif Shape == 2
            NameBody = [NameLaser 'Rarea' num2str(GeoParam.Rarea)] ;
        else
            NameBody = [NameLaser 'Xi' num2str(GeoParam.Xi)] ;
        end
    else
        if Shape == 1
            NameBody = ['w' num2str(GeoParam.Omega)  'FT' num2str(GeoParam.FilletMode) 'RAM' num2str(GeoParam.RAMode) ...
                'Rarea' num2str(GeoParam.Rarea)...
                'Ssg' num2str(GeoParam.SigmaSkew) ] ;
        elseif Shape == 2
            NameBody = ['Rarea' num2str(GeoParam.Rarea)];
        else
            NameBody = ['Xi' num2str(GeoParam.Xi)] ;
        end
    end
elseif WheelType == 3
    NameWheelType3 = ['tgw' num2str(SepParam.theta) 'kd' num2str(SepParam.KDev) ...
        'Sgap' num2str(SepParam.SepGap) 'Rgap' num2str(SepParam.RowGap)];
    if Shape == 1
        NameBody = [NameWheelType3 'w' num2str(GeoParam.Omega)  ...
            'FT' num2str(GeoParam.FilletMode) 'RAM' num2str(GeoParam.RAMode) 'Rarea' num2str(GeoParam.Rarea)...
            'Ssg' num2str(GeoParam.SigmaSkew)] ;
    elseif Shape == 2
        NameBody = [NameWheelType3 'Rarea' num2str(GeoParam.Rarea)] ;
    else
        NameBody = [NameWheelType3 'Xi' num2str(GeoParam.Xi)] ;
    end
end
%%
FileName = [filefolder NameBody ...
    'Hsg' num2str(GeoParam.Sigmah) 'Rsg' num2str(GeoParam.Sigmarg) 'vw' num2str(vw)];
end