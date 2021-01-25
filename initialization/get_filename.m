function filename = get_filename(cycle, sepparam, geoparam, FOI, vw)
%% get_filename is usedd to set path and files' names
wheel_type = sepparam.wheel_type;
shape = geoparam.shape;
filefolder = ['GrdData/' FOI '/' 'cycle' num2str(cycle)];
%%
if wheel_type == 1
    if shape == 1
        namebody = ['w' num2str(geoparam.omega)  'FT' num2str(geoparam.fillet_mode) 'RAM' num2str(geoparam.RA_mode) ...
            'Rarea' num2str(geoparam.Rarea)...
            'Ssg' num2str(geoparam.sigmasw) ] ;
    elseif shape == 2
        namebody = ['Rarea' num2str(geoparam.Rarea)];
    else
        namebody = ['xi' num2str(geoparam.xi)] ;
    end
elseif wheel_type == 2
    if sepparam.LS_mode == 1
        name_laser = ['LS' num2str(sepparam.LS_mode) ...
            'tgw' num2str(sepparam.theta) 'Sgap' num2str(sepparam.SaveGap) 'Rgap' num2str(sepparam.RowGap)];
        if shape == 1
            namebody = [name_laser ...
                'w' num2str(geoparam.omega) 'FT' num2str(geoparam.fillet_mode) 'RAM' num2str(geoparam.RA_mode) ...
                'Rarea' num2str(geoparam.Rarea) ...
                'Ssg' num2str(geoparam.sigmasw)] ;
        elseif shape == 2
            namebody = [name_laser 'Rarea' num2str(geoparam.Rarea)] ;
        else
            namebody = [name_laser 'xi' num2str(geoparam.xi)] ;
        end
    else
        if shape == 1
            namebody = ['w' num2str(geoparam.omega)  'FT' num2str(geoparam.fillet_mode) 'RAM' num2str(geoparam.RA_mode) ...
                'Rarea' num2str(geoparam.Rarea)...
                'Ssg' num2str(geoparam.sigmasw) ] ;
        elseif shape == 2
            namebody = ['Rarea' num2str(geoparam.Rarea)];
        else
            namebody = ['xi' num2str(geoparam.xi)] ;
        end
    end
elseif wheel_type == 3
    name_wheel_type3 = ['tgw' num2str(sepparam.theta) 'kd' num2str(sepparam.k_dev) ...
        'Sgap' num2str(sepparam.SepGap) 'Rgap' num2str(sepparam.RowGap)];
    if shape == 1
        namebody = [name_wheel_type3 'w' num2str(geoparam.omega)  ...
            'FT' num2str(geoparam.fillet_mode) 'RAM' num2str(geoparam.RA_mode) 'Rarea' num2str(geoparam.Rarea)...
            'Ssg' num2str(geoparam.sigmasw)] ;
    elseif shape == 2
        namebody = [name_wheel_type3 'Rarea' num2str(geoparam.Rarea)] ;
    else
        namebody = [name_wheel_type3 'xi' num2str(geoparam.xi)] ;
    end
end
%%
filename = [filefolder namebody ...
    'Hsg' num2str(geoparam.sigmah) 'Rsg' num2str(geoparam.Rsigma) 'vw' num2str(vw)];
end