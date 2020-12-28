function create_folder()
%% create folder
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
newsubfolder = 'GrdData/EFrake';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/EFsigmah';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/EFsigmasw';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/EFRsigma';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/ELS';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
newsubfolder = 'GrdData/TTDD';
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end