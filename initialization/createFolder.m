function createFolder()
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
newsubfolder = 'M:/GrdData/ConeAngle';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'M:/GrdData/sigmasw';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'M:/GrdData/edges';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'M:/GrdData/FruRarea';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
% shape == 2
newsubfolder = 'M:/GrdData/ELSRarea';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
% shape == 3
newsubfolder = 'M:/GrdData/xi';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
% all
newsubfolder = 'M:/GrdData/sigmah';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'M:/GrdData/Rsigma';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end