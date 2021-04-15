function [ColNames, SOI, BatchInfo] = calMeanofBatch(DiskPath, FOI, Cycle, SepParam, GeoParam, SOI)
[~, BatchInfo] = batchExsistInvalidate(DiskPath, Cycle, FOI, SepParam, GeoParam, 1);
ColNames = BatchInfo.Properties.VariableNames;
temp = table2array(BatchInfo);
if isempty(SOI)
    SOI = temp;
else
    SOI = SOI + temp;
end
end