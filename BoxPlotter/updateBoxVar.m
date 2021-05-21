function [x, g] = updateBoxVar(BatchInfo, DiskPath, Cycle, FOI, FileIcon, x, g)
%% Update variables on x and y axis for box plot
%%
InputField = initInputField(FOI);

[SepParam, GeoParam] = setBoxPlotParam(BatchInfo(1,:));
vw = getTabelValtoArray(BatchInfo, 'vw');
FileName = getFilename(DiskPath, Cycle, SepParam, GeoParam, FOI, vw);
UCTInfo = readtable([FileName '-' FileIcon '.csv'],'PreserveVariableNames',1);

UCTArray = table2array(UCTInfo);
UCTArray = UCTArray(:);
UCTArray(UCTArray<=1e-3) = [];
if strcmp(FileIcon,'uct')
    UCTArray = rmoutliers(UCTArray);
end

x = [x; UCTArray];
LogicAll = strncmp(BatchInfo.Properties.VariableNames, 'datetime', length('datetime'));
if sum(LogicAll) >= 1
    BatchInfo = removevars(BatchInfo,{'datetime'});
end

BatchInfo = dataScaling(BatchInfo, FOI);
if strcmp(InputField,'Default')
    g = [];
else
    g = [g; repmat({num2str(getTabelValtoArray(BatchInfo,InputField))},length(UCTArray),1)];
end
end