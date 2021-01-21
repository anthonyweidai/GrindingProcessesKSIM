function create_folder()
%% Add your new FOI path to function to create your folder
%% Patrick
newsubfolder = 'GrdData/EFdist';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/EFdist_new';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
%% Dave
% shape == 1
newsubfolder = 'GrdData/ConeAngle';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/sigmasw';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/edges';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/FruRarea';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
% shape == 2
newsubfolder = 'GrdData/ELSRarea';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
% shape == 3
newsubfolder = 'GrdData/xi';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
% all
newsubfolder = 'GrdData/sigmah';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/Rsigma';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end