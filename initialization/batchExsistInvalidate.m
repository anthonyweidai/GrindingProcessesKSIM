function Existence = batchExsistInvalidate(DiskPath, Cycle, FOI, SepParam, GeoParam)
%% If Exsist == 1, then skip to the next parameter combination
%%
FileName = [DiskPath FOI '/CY' num2str(Cycle) 'wheel' num2str(SepParam.WheelType) '-info.csv'];
if ~isfile(FileName)
    Existence = 0;
else
    %%
    BatchInfo = readtable(FileName);
    BatchInfo = table2struct(BatchInfo);
    FieldName1 = fieldnames(SepParam)';
    FieldName2 = fieldnames(GeoParam)';
    Len1 = length(FieldName1);
    Len2 = length(FieldName2);
    %%
    for i = 1:length(BatchInfo)
        count = 0;
        for j = 1:Len1
            FeldName = char(FieldName1(j));
            if SepParam.(FeldName) == BatchInfo(i).(FeldName)
                count = count + 1;
            end
        end
        for k = 1:Len2
            FeldName = char(FieldName2(k));
            if GeoParam.(FeldName) == BatchInfo(i).(FeldName)
                count = count + 1;
            end
        end
        if count == Len1 + Len2
            Existence = 1;
            return
        else
            Existence = 0;
        end
    end
end
end