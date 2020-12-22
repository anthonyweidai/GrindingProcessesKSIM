set(0,'defaultfigurecolor',[1 1 1])
create_folder();
%% if the programme works well, then use batnum 2
geoparam.shape = 1;
for batnum = 1
    for wheel_type = 1:2
        sepparam.wheel_type = wheel_type;
        for fillet_mode = 0:1%
            geoparam.fillet_mode = fillet_mode;
            %% for rake angle
            for omega = [3, 5, 7, 9, 25]
                geoparam.omega = omega;
                for RA_mode = 0:1 %
                    geoparam.RA_mode = RA_mode;
                    for Rarea = [0.1, 0.3, 0.5, 0.7, 0.9]
                        geoparam.Rarea = Rarea;
                        FOI = 'EF\_RA';  % field of interest
                        if wheel_type == 2 % within different distribution
                            for theta = [30, 60]
                                sepparam.theta = theta;
                                GrdProcess4(batnum,FOI,sepparam,geoparam);
                            end
                        else
                            GrdProcess4(batnum,FOI,sepparam,geoparam);
                        end
                    end
                end
            end
        end
        geoparam.fillet_mode = 1;
        geoparam.RA_mode = 1;
        %% for sigmah
        for omega = [7, 25]
            geoparam.omega = omega;
            for sigmah = [0.02, 0.04, 0.06] % R = 10, 3sigma
                geoparam.sigmah = sigmah;
                for Rarea = [0.1, 0.7] % pyramid and trapzoid
                    geoparam.Rarea = Rarea;
                    FOI = 'EF\_sigmah';
                    if wheel_type == 2
                        for theta = [30, 60]
                            sepparam.theta = theta;
                            GrdProcess4(batnum,FOI,sepparam,geoparam);
                        end
                    else
                        GrdProcess4(batnum,FOI,sepparam,geoparam);
                    end
                end
                
            end
            geoparam.sigmah = 0;
            %% for sigmasw
            for sigmasw = [0.04, 0.06, 0.08]
                geoparam.sigmasw = sigmasw;
                for Rarea = [0.1, 0.7]
                    geoparam.Rarea = Rarea;
                    FOI = 'EF\_sigmasw';
                    if wheel_type == 2
                        for theta = [30, 60]
                            sepparam.theta = theta;
                            GrdProcess4(batnum,FOI,sepparam,geoparam);
                        end
                    else
                        GrdProcess4(batnum,FOI,sepparam,geoparam);
                    end
                end
            end
            geoparam.sigmasw = 0;
            %% for grains radius
            for Rsigma = [0.05, 0.1, 0.15]
                geoparam.Rsigma = Rsigma;
                for Rarea = [0.1, 0.7]
                    geoparam.Rarea = Rarea;
                    FOI = 'EF\_Rsigma';
                    if wheel_type == 2
                        for theta = [30, 60]
                            sepparam.theta = theta;
                            GrdProcess4(batnum,FOI,sepparam,geoparam);
                        end
                    else
                        GrdProcess4(batnum,FOI,sepparam,geoparam);
                    end
                end
            end
        end
    end
end
%%
clear geoparam
clear sepparam
geoparam.shape = 2;
FOI = 'ELS'; % field of interest ellipsoid
for batnum = 1
    for wheel_type = 1:2
        sepparam.wheel_type = wheel_type;
        for Rarea = [0.4, 0.6, 0.8, 1, 1.5, 2, 2.5]
            geoparam.Rarea = Rarea;
            if wheel_type == 2
                for theta = [30, 60]
                    sepparam.theta = theta;
                    GrdProcess4(batnum,FOI,sepparam,geoparam);
                end
            else
                GrdProcess4(batnum,FOI,sepparam,geoparam);
            end
        end
    end
end
%%
clear geoparam
clear sepparam
geoparam.shape = 3;
FOI = 'TTDD'; % field of interest tetradecahedron
for batnum = 1
    for wheel_type = 1:2
        sepparam.wheel_type = wheel_type;
        for xi = [0, 1/(2*1.732), 1/1.732, 1/2]
            geoparam.xi = xi;
            if wheel_type == 2
                for theta = [30, 60]
                    sepparam.theta = theta;
                    GrdProcess4(batnum,FOI,sepparam,geoparam);
                end
            else
                GrdProcess4(batnum,FOI,sepparam,geoparam);
            end
        end
        % sigma_h can be added
    end
end

function create_folder()
%% create folder
newsubfolder = 'UT_data/EF\_RA';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/EF\_sigmah';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/EF\_sigmasw';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/EF\_Rsigma';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/ELS';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/TTDD';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end