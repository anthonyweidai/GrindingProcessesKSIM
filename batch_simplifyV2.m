set(0,'defaultfigurecolor',[1 1 1])
create_folder();
%%
geoparam.shape = 1;
for batnum = 1
    for wheel_type = 1:2
        sepparam.wheel_type = wheel_type;
        geoparam.omega = omega;
        for fillet_mode = 0:1%
            geoparam.fillet_mode = fillet_mode;
            %% for rake angle
            for omega = [3, 5, 7, 9, 25]
                for RA_mode = 0:1 %
                    geoparam.RA_mode = RA_mode;
                    for Rarea = [0.1, 0.3, 0.5, 0.7, 0.9]
                        geoparam.Rarea = Rarea;
                        FOI = 'EF_RA';  % field of interest
                        if wheel_type == 2 % within different distribution
                            for theta = [30, 60]
                                geoparam.theta = theta;
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
            for sigmah = [0.02, 0.04, 0.06] % R = 10, 3sigma
                geoparam.sigmah = sigmah;
                for Rarea = [0.1, 0.7] % pyramid and trapzoid
                    geoparam.Rarea = Rarea;
                    FOI = 'EF_sigmah';
                    if wheel_type == 2
                        for theta = [30, 60]
                            geoparam.theta = theta;
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
                    FOI = 'EF_sigmasw';
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
geoparam.shape = 2;
FOI = 'ellipsoid'; % field of interest
for batnum = 1:2
    for wheel_type = 1:2
        sepparam.wheel_type = wheel_type;
        for Rarea = [0.4, 0.6, 0.8, 1, 1.5, 2, 2.5]
            geoparam.Rarea = Rarea;
            if wheel_type == 2
                for theta = [30, 60]
                    geoparam.theta = theta;
                    GrdProcess4(batnum,FOI,sepparam,geoparam);
                end
            else
                GrdProcess4(batnum,FOI,sepparam,geoparam);
            end
        end
    end
end
%%
geoparam.shape = 3;
FOI = 'tetradecahedron'; % field of interest
for batnum = 1:2
    for wheel_type = 1:2
        sepparam.wheel_type = wheel_type;
        for xi = [0, 1/(2*1.732), 1/1.732, 1/2]
            if wheel_type == 2
                for theta = [30, 60]
                    geoparam.theta = theta;
                    GrdProcess4(batnum,FOI,sepparam,geoparam);
                end
            else
                GrdProcess4(batnum,FOI,sepparam,geoparam);
            end
        end
    end
end

function create_folder()
%% create folder
newsubfolder = 'UT_data/EF_RA';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/EF_sigmah';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/EF_sigmasw';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/ellipsoid';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'UT_data/tetradecahedron';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end