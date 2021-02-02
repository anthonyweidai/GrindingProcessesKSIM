function FileName = getFilename(Cycle, SepParam, GeoParam, FOI, vw)
%% get_filename is usedd to set path and files' names
wheel_type = SepParam.wheel_type;
shape = GeoParam.shape;
filefolder = ['M:/GrdData/' FOI '/' 'CY' num2str(Cycle)];
%%
if wheel_type == 1
    if shape == 1
        namebody = ['w' num2str(GeoParam.omega)  'FT' num2str(GeoParam.fillet_mode) 'RAM' num2str(GeoParam.RA_mode) ...
            'Rarea' num2str(GeoParam.Rarea)...
            'Ssg' num2str(GeoParam.sigmasw) ] ;
    elseif shape == 2
        namebody = ['Rarea' num2str(GeoParam.Rarea)];
    else
        namebody = ['xi' num2str(GeoParam.xi)] ;
    end
elseif wheel_type == 2
    if SepParam.LS_mode == 1
        name_laser = ['LS' num2str(SepParam.LS_mode) ...
            'tgw' num2str(SepParam.theta) 'Sgap' num2str(SepParam.SaveGap) 'Rgap' num2str(SepParam.RowGap)];
        if shape == 1
            namebody = [name_laser ...
                'w' num2str(GeoParam.omega) 'FT' num2str(GeoParam.fillet_mode) 'RAM' num2str(GeoParam.RA_mode) ...
                'Rarea' num2str(GeoParam.Rarea) ...
                'Ssg' num2str(GeoParam.sigmasw)] ;
        elseif shape == 2
            namebody = [name_laser 'Rarea' num2str(GeoParam.Rarea)] ;
        else
            namebody = [name_laser 'xi' num2str(GeoParam.xi)] ;
        end
    else
        if shape == 1
            namebody = ['w' num2str(GeoParam.omega)  'FT' num2str(GeoParam.fillet_mode) 'RAM' num2str(GeoParam.RA_mode) ...
                'Rarea' num2str(GeoParam.Rarea)...
                'Ssg' num2str(GeoParam.sigmasw) ] ;
        elseif shape == 2
            namebody = ['Rarea' num2str(GeoParam.Rarea)];
        else
            namebody = ['xi' num2str(GeoParam.xi)] ;
        end
    end
elseif wheel_type == 3
    name_wheel_type3 = ['tgw' num2str(SepParam.theta) 'kd' num2str(SepParam.k_dev) ...
        'Sgap' num2str(SepParam.SepGap) 'Rgap' num2str(SepParam.RowGap)];
    if shape == 1
        namebody = [name_wheel_type3 'w' num2str(GeoParam.omega)  ...
            'FT' num2str(GeoParam.fillet_mode) 'RAM' num2str(GeoParam.RA_mode) 'Rarea' num2str(GeoParam.Rarea)...
            'Ssg' num2str(GeoParam.sigmasw)] ;
    elseif shape == 2
        namebody = [name_wheel_type3 'Rarea' num2str(GeoParam.Rarea)] ;
    else
        namebody = [name_wheel_type3 'xi' num2str(GeoParam.xi)] ;
    end
end
%%
FileName = [filefolder namebody ...
    'Hsg' num2str(GeoParam.sigmah) 'Rsg' num2str(GeoParam.Rsigma) 'vw' num2str(vw)];
end