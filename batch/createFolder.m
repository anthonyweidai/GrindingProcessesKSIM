function createFolder(FOI)
%% Add your new FOI path to function to create your folder
newsubfolder = ['M:/GrdData/' FOI];
if ~exist(newsubfolder,'dir')
    mkdir(newsubfolder);
end
end