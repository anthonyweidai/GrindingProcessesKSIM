function [Existence, SOI] = batchExsistInvalidate(DiskPath, Cycle, FOI, SepParam, GeoParam, ValidMode)
%% If Exsist == 1, then skip to the next parameter combination
%%
if ValidMode == 1
    FileName = [DiskPath FOI '/CY' num2str(Cycle) 'wheel' num2str(SepParam.WheelType) '-info.csv'];
elseif ValidMode == 2
    FileName = [DiskPath '-Total' num2str(Cycle) 'Wheel' num2str(SepParam.WheelType) '.csv'];
end
if ~isfile(FileName)
    Existence = 0;
    SOI = [];
else
    %%
    BatchInfo = readtable(FileName, 'PreserveVariableNames', 1);
    BatchInfo = removevars(BatchInfo,{'datetime'});
    BatchInfo = table2struct(BatchInfo);
    FieldName1 = fieldnames(SepParam)';
    FieldName2 = fieldnames(GeoParam)';
    Len1 = length(FieldName1);
    Len2 = length(FieldName2);
    %%
    for i = 1:length(BatchInfo)
        count = 0;
        for j = 1:Len1
            FieldName = char(FieldName1(j));
            if ~ isfield(BatchInfo(i),FieldName) || SepParam.(FieldName) == BatchInfo(i).(FieldName)
                count = count + 1;
            end
        end
        for k = 1:Len2
            FieldName = char(FieldName2(k));
            if GeoParam.(FieldName) == BatchInfo(i).(FieldName)
                count = count + 1;
            end
        end
        if count == Len1 + Len2
            Existence = 1;
            SOI = struct2table(BatchInfo(i,:)); % Set of interest
            return
        else
            Existence = 0;
            SOI = [];
        end
    end
end
end