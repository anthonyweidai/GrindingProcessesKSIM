function T = dataScaling(T, FOI)
%% Scalling data
% The function is designed for data optimazation because of mistakes maken
% before fixing bugs of some functions. If you get results from re-run KSIM,
% the results are generally right. So you should comment this function
% (skip it) in MeanAnalysis.m
%%
ColNames = T.Properties.VariableNames;
BatchArray = table2array(T);
%%
rg = 10;
for i = 1:length(ColNames)
    NameTemp = char(ColNames(i));
    if strcmp(NameTemp,'SepGap')||strcmp(NameTemp,'RowGap')
        BatchArray(:,i) = BatchArray(:,i)*(2*rg);
    elseif strcmp(NameTemp,'Sigmah')||strcmp(NameTemp,'KDev')
        BatchArray(:,i) = BatchArray(:,i)*rg;
    end
end
T = array2table(BatchArray,'VariableNames',ColNames);
end