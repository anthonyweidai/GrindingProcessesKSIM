function BarValue = getValuefromStruct(BarValues, OutputField)

ColNames = BarValues.(['Name' 'W3']);
for k = 1:length(ColNames)
    ColName = string(ColNames(k));
    if strcmp(ColName,OutputField)
        BarValue = BarValues.(['SOI' 'W3'])(k);
        break
    end
end

ColNames = BarValues.(['Name' 'W2']);
for k = 1:length(ColNames)
    ColName = string(ColNames(k));
    if strcmp(ColName,OutputField)
        BarValue = [BarValue BarValues.(['SOI' 'W2'])(k)];
        return
    end
end
end