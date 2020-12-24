set(0,'defaultfigurecolor',[1 1 1])
create_folder();
%% if the programme works well, then use batnum 2
geoparam.shape = 1;
for batnum = 1:10
    for wheel_type = 3
        sepparam.wheel_type = wheel_type;
        geoparam.fillet_mode = 1;
        geoparam.RA_mode = 0;
        %% for rake angle
        for omega = [8]
            geoparam.omega = omega;
            for Rarea = [0.3, 0.7]
                geoparam.Rarea = Rarea;
                FOI = 'EFdist';  % field of interest
                if wheel_type == 2 % within different distribution
                    for theta = [15, 30, 45, 60, 75]
                        sepparam.theta = theta;
                        sepparam.RowGap = 100;
                        sepparam.SaveGap = 25;
                        sepparam.LS_mode = 1;
                        GrdProcess4(batnum,FOI,sepparam,geoparam);
                    end
                elseif wheel_type == 3
                    for theta = [15, 30, 45, 60, 75]
                        sepparam.theta = theta;
                        sepparam.RowGap = 3;
                        sepparam.SepGap = 0.5;
                        sepparam.k_dev = 0;
                        geoparam.Rsigma = 2; %R=10, +3sigma=6,sigma=2; trimming height=10
                        geoparam.trim_h = 10; %50%trim, trim back to the average height
                        GrdProcess4(batnum,FOI,sepparam,geoparam);
                    end
                else
                    GrdProcess4(batnum,FOI,sepparam,geoparam);
                end
            end                
        end
    end
end

function create_folder()
%% create folder
newsubfolder = 'UT_data/EFdist';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end