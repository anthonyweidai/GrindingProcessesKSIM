function errorReport(Cycle,FOI,SepParam,GeoParam)
%% the function is used to save error information about batch
BatchInfo = array2table(convertCharsToStrings(char(datetime)),'VariableNames',{'datetime'});
BatchInfo = [BatchInfo array2table(convertCharsToStrings(char(FOI)),'VariableNames',{'FOI'})];
BatchInfo = [BatchInfo table(Cycle)];
BatchInfo = [BatchInfo struct2table(SepParam) struct2table(GeoParam)];
writetable(BatchInfo,['batch\\' 'errorReport.csv'],'WriteMode','append');
end