function filename = get_filename(batnum, sepparam, geoparam, FOI)
wheel_type = sepparam.wheel_type;
if wheel_type == 1
    if geoparam.shape == 1
        filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
            'w' num2str(geoparam.omega) 'Hsg' num2str(geoparam.sigmah) 'Ssg' num2str(geoparam.sigmasw) ...
            'Rsg' num2str(geoparam.Rsigma) 'FT' num2str(geoparam.fillet_mode) 'RA' num2str(geoparam.Rarea) ...
            'RAM' num2str(geoparam.RA_mode)] ;
    elseif geoparam.shape == 2
        filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) 'RA' num2str(geoparam.Rarea) 'Rsg' num2str(geoparam.Rsigma)];
    else
        filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) 'xi' num2str(geoparam.xi) 'Rsg' num2str(geoparam.Rsigma)] ;
    end
elseif wheel_type == 2
    if sepparam.LS_mode == 1
        if geoparam.shape == 1
            filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) 'LS' num2str(sepparam.LS_mode) ...
                'tgw' num2str(sepparam.theta) 'Sgap' num2str(sepparam.SaveGap) ...
                'Rgap' num2str(sepparam.RowGap) 'w' num2str(geoparam.omega)  ...
                'Hsg' num2str(geoparam.sigmah) 'Ssg' num2str(geoparam.sigmasw) 'Rsg' num2str(geoparam.Rsigma) ...
                'FT' num2str(geoparam.fillet_mode) 'RA' num2str(geoparam.Rarea) 'RAM' num2str(geoparam.RA_mode)] ;
        elseif geoparam.shape == 2
            filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
                'tgw' num2str(sepparam.theta) 'Sgap' num2str(sepparam.SaveGap) ...
                'Rgap' num2str(sepparam.RowGap) 'RA' num2str(geoparam.Rarea) 'Rsg' num2str(geoparam.Rsigma)] ;
        else
            filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
                'tgw' num2str(sepparam.theta) 'Sgap' num2str(sepparam.SaveGap) ...
                'Rgap' num2str(sepparam.RowGap)  'xi' num2str(geoparam.xi) 'Rsg' num2str(geoparam.Rsigma)] ;
        end
    else
        if geoparam.shape == 1
            filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
                'w' num2str(geoparam.omega)  ...
                'Hsg' num2str(geoparam.sigmah) 'Ssg' num2str(geoparam.sigmasw) 'Rsg' num2str(geoparam.Rsigma) ...
                'FT' num2str(geoparam.fillet_mode) 'RA' num2str(geoparam.Rarea) 'RAM' num2str(geoparam.RA_mode)] ;
        elseif geoparam.shape == 2
            filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
                'RA' num2str(geoparam.Rarea) 'Rsg' num2str(geoparam.Rsigma)] ;
        else
            filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
                'xi' num2str(geoparam.xi) 'Rsg' num2str(geoparam.Rsigma)] ;
        end
    end
elseif sepparam.wheel_type == 3
    if geoparam.shape == 1
        filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
            'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
            'Rgap' num2str(sepparam.RowGap) 'w' num2str(geoparam.omega)  ...
            'Hsg' num2str(geoparam.sigmah) 'Ssg' num2str(geoparam.sigmasw) 'Rsg' num2str(geoparam.Rsigma) ...
            'FT' num2str(geoparam.fillet_mode) 'RA' num2str(geoparam.Rarea) 'RAM' num2str(geoparam.RA_mode)] ;
    elseif geoparam.shape == 2
        filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
            'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
            'Rgap' num2str(sepparam.RowGap) 'RA' num2str(geoparam.Rarea) 'Rsg' num2str(geoparam.Rsigma)] ;
    else
        filename = ['GrdData/' FOI '/' 'Bat' num2str(batnum) ...
            'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
            'Rgap' num2str(sepparam.RowGap)  'xi' num2str(geoparam.xi) 'Rsg' num2str(geoparam.Rsigma)] ;
    end
end
end