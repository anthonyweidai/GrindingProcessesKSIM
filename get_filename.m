function filename = get_filename(num_grits, batnum, sepparam, geoparam, FOI)
wheel_type = sepparam.wheel_type;
if wheel_type == 1
    if geoparam.shape == 2
        if geoparam.Rarea ~= 1
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N'  num2str(num_grits) 'RA' num2str(geoparam.Rarea)] ;
        else
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N'  num2str(num_grits)] ;
        end
    else
        filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N'  num2str(num_grits) ...
            'SH' num2str(geoparam.shape) 'w' num2str(geoparam.omega) 'hsg' num2str(geoparam.sigmah) ...
            'swsg' num2str(geoparam.sigmasw) 'FT' num2str(geoparam.fillet_mode) 'RA' num2str(geoparam.Rarea) ...
            'RAM' num2str(geoparam.RA_mode)] ;
    end
elseif wheel_type == 2
    if geoparam.shape == 2
        if geoparam.Rarea ~= 1
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N' num2str(num_grits) ...
                'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
                'Rgap' num2str(sepparam.RowGap) 'RA' num2str(geoparam.Rarea)] ;
        else
            filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N' num2str(num_grits) ...
                'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
                'Rgap' num2str(sepparam.RowGap)] ;
        end
    else
        filename = ['UT_data/' FOI '/' 'Bat' num2str(batnum) 'N' num2str(num_grits) ...
            'tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) 'Sgap' num2str(sepparam.SepGap) ...
            'Rgap' num2str(sepparam.RowGap) 'SH' num2str(geoparam.shape) 'w' num2str(geoparam.omega)  ...
            'hsg' num2str(geoparam.sigmah) 'swsg' num2str(geoparam.sigmasw) 'FT' num2str(geoparam.fillet_mode) ...
            'RA' num2str(geoparam.Rarea) 'RAM' num2str(geoparam.RA_mode)] ;
    end
end
end